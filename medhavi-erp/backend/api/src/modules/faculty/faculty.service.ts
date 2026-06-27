import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { AuditAction, FacultyStatus, Prisma } from '@prisma/client';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';
import { CreateFacultyDto } from './dto/create-faculty.dto';
import { ListFacultyQueryDto } from './dto/list-faculty.query';
import { UpdateFacultyDto } from './dto/update-faculty.dto';

// Re-exported for future audit-log re-integration (mirrors students.service).
export { AuditAction };

export interface PaginatedResult<T> {
  data: T[];
  meta: {
    page: number;
    pageSize: number;
    total: number;
    totalPages: number;
  };
}

const DEFAULT_STATUS: FacultyStatus = FacultyStatus.ACTIVE;
const DELETED_STATUS: FacultyStatus = FacultyStatus.RESIGNED;

/**
 * FacultyService
 *
 * CRUD + soft delete for the Faculty aggregate. Audit logging is intentionally
 * omitted in this revision (parity with students.service); AuditAction is
 * re-exported so a follow-up can re-wire AuditService without touching
 * controllers.
 *
 * Invariants enforced:
 *  - `employeeCode` is unique per institute among non-deleted faculty.
 *  - `userId` is globally unique among non-deleted faculty (schema also
 *    enforces a hard unique constraint; we proactively check to deliver a
 *    friendly ConflictException).
 *  - `schoolId` must reference a non-deleted School belonging to the same
 *    `instituteId`.
 *  - `departmentId` must reference a non-deleted Department belonging to the
 *    same `schoolId` AND the same `instituteId`.
 *  - `campusId`, when provided, must reference a non-deleted Campus belonging
 *    to the same `instituteId` (and, if the school is campus-bound, match).
 *  - `reportsToFacultyId`, when provided, must reference a non-deleted Faculty
 *    in the same `instituteId` and cannot be self.
 */
@Injectable()
export class FacultyService {
  private readonly logger = new Logger(FacultyService.name);

  constructor(private readonly prisma: PrismaService) {}

  // --------------------------------------------------------------------------
  // CREATE
  // --------------------------------------------------------------------------
  async create(dto: CreateFacultyDto) {
    await this.assertInstituteExists(dto.instituteId);
    await this.assertUserExists(dto.userId);
    await this.assertSchoolBelongsToInstitute(dto.schoolId, dto.instituteId);
    await this.assertDepartmentBelongsToSchool(
      dto.departmentId,
      dto.schoolId,
      dto.instituteId,
    );
    if (dto.campusId) {
      await this.assertCampusBelongsToInstitute(dto.campusId, dto.instituteId);
    }
    if (dto.reportsToFacultyId) {
      await this.assertReportsToValid(
        dto.reportsToFacultyId,
        dto.instituteId,
        undefined,
      );
    }
    await this.assertEmployeeCodeUnique(dto.instituteId, dto.employeeCode);
    await this.assertUserIdUnique(dto.userId);

    try {
      const faculty = await this.prisma.faculty.create({
        data: {
          instituteId: dto.instituteId,
          userId: dto.userId,
          campusId: dto.campusId ?? null,
          schoolId: dto.schoolId,
          departmentId: dto.departmentId,
          employeeCode: dto.employeeCode,
          designation: dto.designation,
          employmentType: dto.employmentType ?? undefined,
          joinDate: new Date(dto.joinDate),
          confirmationDate: dto.confirmationDate
            ? new Date(dto.confirmationDate)
            : null,
          exitDate: dto.exitDate ? new Date(dto.exitDate) : null,
          qualifications: (dto.qualifications ?? undefined) as Prisma.InputJsonValue | undefined,
          specializations: dto.specializations ?? [],
          researchAreas: dto.researchAreas ?? [],
          officeRoom: dto.officeRoom ?? null,
          officeHours: (dto.officeHours ?? undefined) as Prisma.InputJsonValue | undefined,
          weeklyLoadHours: dto.weeklyLoadHours ?? null,
          maxWeeklyLoadHours: dto.maxWeeklyLoadHours ?? null,
          reportsToFacultyId: dto.reportsToFacultyId ?? null,
          isHod: dto.isHod ?? false,
          isMentor: dto.isMentor ?? false,
          isAdvisor: dto.isAdvisor ?? false,
          status: dto.status ?? DEFAULT_STATUS,
          biography: dto.biography ?? null,
          profilePhotoFileId: dto.profilePhotoFileId ?? null,
          metadata: (dto.metadata ?? undefined) as Prisma.InputJsonValue | undefined,
        },
      });

      this.logger.log(
        `Faculty created: ${faculty.id} (${faculty.employeeCode})`,
      );
      return faculty;
    } catch (err) {
      if (
        err instanceof Prisma.PrismaClientKnownRequestError &&
        err.code === 'P2002'
      ) {
        throw new ConflictException(
          `Faculty with employeeCode "${dto.employeeCode}" or userId "${dto.userId}" already exists.`,
        );
      }
      throw err;
    }
  }

  // --------------------------------------------------------------------------
  // READ — list with pagination/filters
  // --------------------------------------------------------------------------
  async findAll(
    query: ListFacultyQueryDto,
  ): Promise<
    PaginatedResult<Awaited<ReturnType<typeof this.prisma.faculty.findFirst>>>
  > {
    const page = query.page ?? 1;
    const pageSize = query.pageSize ?? 20;
    const sortBy = query.sortBy ?? 'createdAt';
    const sortOrder = query.sortOrder ?? 'desc';

    const where: Prisma.FacultyWhereInput = {
      ...(query.includeDeleted ? {} : { deletedAt: null }),
      ...(query.instituteId ? { instituteId: query.instituteId } : {}),
      ...(query.campusId ? { campusId: query.campusId } : {}),
      ...(query.schoolId ? { schoolId: query.schoolId } : {}),
      ...(query.departmentId ? { departmentId: query.departmentId } : {}),
      ...(query.userId ? { userId: query.userId } : {}),
      ...(query.reportsToFacultyId
        ? { reportsToFacultyId: query.reportsToFacultyId }
        : {}),
      ...(query.designation ? { designation: query.designation } : {}),
      ...(query.employmentType ? { employmentType: query.employmentType } : {}),
      ...(query.status ? { status: query.status } : {}),
      ...(query.isHod !== undefined ? { isHod: query.isHod } : {}),
      ...(query.isMentor !== undefined ? { isMentor: query.isMentor } : {}),
      ...(query.isAdvisor !== undefined ? { isAdvisor: query.isAdvisor } : {}),
      ...(query.search
        ? {
            OR: [
              { employeeCode: { contains: query.search, mode: 'insensitive' } },
              { officeRoom: { contains: query.search, mode: 'insensitive' } },
            ],
          }
        : {}),
    };

    const [total, data] = await this.prisma.$transaction([
      this.prisma.faculty.count({ where }),
      this.prisma.faculty.findMany({
        where,
        orderBy: { [sortBy]: sortOrder },
        skip: (page - 1) * pageSize,
        take: pageSize,
      }),
    ]);

    return {
      data,
      meta: {
        page,
        pageSize,
        total,
        totalPages: Math.max(1, Math.ceil(total / pageSize)),
      },
    };
  }

  // --------------------------------------------------------------------------
  // READ — single
  // --------------------------------------------------------------------------
  async findOne(id: string, opts: { includeDeleted?: boolean } = {}) {
    const faculty = await this.prisma.faculty.findFirst({
      where: {
        id,
        ...(opts.includeDeleted ? {} : { deletedAt: null }),
      },
    });
    if (!faculty) throw new NotFoundException(`Faculty ${id} not found.`);
    return faculty;
  }

  // --------------------------------------------------------------------------
  // UPDATE
  // --------------------------------------------------------------------------
  async update(id: string, dto: UpdateFacultyDto) {
    const existing = await this.findOne(id);

    const nextSchoolId = dto.schoolId ?? existing.schoolId;
    const nextDepartmentId = dto.departmentId ?? existing.departmentId;
    const nextCampusId =
      dto.campusId === undefined ? existing.campusId : dto.campusId;

    if (dto.schoolId && dto.schoolId !== existing.schoolId) {
      await this.assertSchoolBelongsToInstitute(
        nextSchoolId,
        existing.instituteId,
      );
    }

    if (
      (dto.departmentId && dto.departmentId !== existing.departmentId) ||
      (dto.schoolId && dto.schoolId !== existing.schoolId)
    ) {
      await this.assertDepartmentBelongsToSchool(
        nextDepartmentId,
        nextSchoolId,
        existing.instituteId,
      );
    }

    if (
      dto.campusId !== undefined &&
      dto.campusId !== existing.campusId &&
      dto.campusId !== null
    ) {
      await this.assertCampusBelongsToInstitute(
        nextCampusId as string,
        existing.instituteId,
      );
    }

    if (
      dto.reportsToFacultyId !== undefined &&
      dto.reportsToFacultyId !== existing.reportsToFacultyId &&
      dto.reportsToFacultyId !== null
    ) {
      await this.assertReportsToValid(
        dto.reportsToFacultyId,
        existing.instituteId,
        existing.id,
      );
    }

    if (dto.employeeCode && dto.employeeCode !== existing.employeeCode) {
      await this.assertEmployeeCodeUnique(
        existing.instituteId,
        dto.employeeCode,
        id,
      );
    }

    try {
      return await this.prisma.faculty.update({
        where: { id },
        data: {
          campusId: dto.campusId === undefined ? undefined : dto.campusId,
          schoolId: dto.schoolId ?? undefined,
          departmentId: dto.departmentId ?? undefined,
          employeeCode: dto.employeeCode ?? undefined,
          designation: dto.designation ?? undefined,
          employmentType: dto.employmentType ?? undefined,
          joinDate: dto.joinDate ? new Date(dto.joinDate) : undefined,
          confirmationDate:
            dto.confirmationDate === undefined
              ? undefined
              : dto.confirmationDate
                ? new Date(dto.confirmationDate)
                : null,
          exitDate:
            dto.exitDate === undefined
              ? undefined
              : dto.exitDate
                ? new Date(dto.exitDate)
                : null,
          qualifications:
            dto.qualifications === undefined
              ? undefined
              : (dto.qualifications as Prisma.InputJsonValue),
          specializations: dto.specializations ?? undefined,
          researchAreas: dto.researchAreas ?? undefined,
          officeRoom: dto.officeRoom === undefined ? undefined : dto.officeRoom,
          officeHours:
            dto.officeHours === undefined
              ? undefined
              : (dto.officeHours as Prisma.InputJsonValue),
          weeklyLoadHours:
            dto.weeklyLoadHours === undefined ? undefined : dto.weeklyLoadHours,
          maxWeeklyLoadHours:
            dto.maxWeeklyLoadHours === undefined
              ? undefined
              : dto.maxWeeklyLoadHours,
          reportsToFacultyId:
            dto.reportsToFacultyId === undefined
              ? undefined
              : dto.reportsToFacultyId,
          isHod: dto.isHod ?? undefined,
          isMentor: dto.isMentor ?? undefined,
          isAdvisor: dto.isAdvisor ?? undefined,
          status: dto.status ?? undefined,
          biography: dto.biography === undefined ? undefined : dto.biography,
          profilePhotoFileId:
            dto.profilePhotoFileId === undefined
              ? undefined
              : dto.profilePhotoFileId,
          metadata:
            dto.metadata === undefined
              ? undefined
              : (dto.metadata as Prisma.InputJsonValue),
        },
      });
    } catch (err) {
      if (
        err instanceof Prisma.PrismaClientKnownRequestError &&
        err.code === 'P2002'
      ) {
        throw new ConflictException(
          `Faculty with employeeCode "${dto.employeeCode}" already exists for this institute.`,
        );
      }
      throw err;
    }
  }

  // --------------------------------------------------------------------------
  // SOFT DELETE
  // --------------------------------------------------------------------------
  async remove(id: string) {
    const existing = await this.findOne(id);
    return this.prisma.faculty.update({
      where: { id: existing.id },
      data: {
        deletedAt: new Date(),
        status: DELETED_STATUS,
      },
    });
  }

  // --------------------------------------------------------------------------
  // RESTORE
  // --------------------------------------------------------------------------
  async restore(id: string) {
    const existing = await this.findOne(id, { includeDeleted: true });
    if (!existing.deletedAt) return existing;

    // Re-validate that the parent hierarchy is still alive and that
    // employeeCode/userId remain available.
    await this.assertSchoolBelongsToInstitute(
      existing.schoolId,
      existing.instituteId,
    );
    await this.assertDepartmentBelongsToSchool(
      existing.departmentId,
      existing.schoolId,
      existing.instituteId,
    );
    if (existing.campusId) {
      await this.assertCampusBelongsToInstitute(
        existing.campusId,
        existing.instituteId,
      );
    }
    if (existing.reportsToFacultyId) {
      await this.assertReportsToValid(
        existing.reportsToFacultyId,
        existing.instituteId,
        existing.id,
      );
    }
    await this.assertEmployeeCodeUnique(
      existing.instituteId,
      existing.employeeCode,
      existing.id,
    );

    return this.prisma.faculty.update({
      where: { id: existing.id },
      data: {
        deletedAt: null,
        status: DEFAULT_STATUS,
      },
    });
  }

  // --------------------------------------------------------------------------
  // Internal helpers
  // --------------------------------------------------------------------------
  private async assertInstituteExists(instituteId: string) {
    const institute = await this.prisma.institute.findFirst({
      where: { id: instituteId, deletedAt: null },
      select: { id: true },
    });
    if (!institute) {
      throw new NotFoundException(`Institute ${instituteId} not found.`);
    }
  }

  private async assertUserExists(userId: string) {
    const user = await this.prisma.user.findFirst({
      where: { id: userId, deletedAt: null },
      select: { id: true },
    });
    if (!user) {
      throw new NotFoundException(`User ${userId} not found.`);
    }
  }

  private async assertCampusBelongsToInstitute(
    campusId: string,
    instituteId: string,
  ) {
    const campus = await this.prisma.campus.findFirst({
      where: { id: campusId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!campus) {
      throw new NotFoundException(`Campus ${campusId} not found.`);
    }
    if (campus.instituteId !== instituteId) {
      throw new BadRequestException(
        `Campus ${campusId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertSchoolBelongsToInstitute(
    schoolId: string,
    instituteId: string,
  ) {
    const school = await this.prisma.school.findFirst({
      where: { id: schoolId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!school) {
      throw new NotFoundException(`School ${schoolId} not found.`);
    }
    if (school.instituteId !== instituteId) {
      throw new BadRequestException(
        `School ${schoolId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertDepartmentBelongsToSchool(
    departmentId: string,
    schoolId: string,
    instituteId: string,
  ) {
    const department = await this.prisma.department.findFirst({
      where: { id: departmentId, deletedAt: null },
      select: { id: true, schoolId: true, instituteId: true },
    });
    if (!department) {
      throw new NotFoundException(`Department ${departmentId} not found.`);
    }
    if (department.instituteId !== instituteId) {
      throw new BadRequestException(
        `Department ${departmentId} does not belong to institute ${instituteId}.`,
      );
    }
    if (department.schoolId !== schoolId) {
      throw new BadRequestException(
        `Department ${departmentId} does not belong to school ${schoolId}.`,
      );
    }
  }

  private async assertReportsToValid(
    reportsToFacultyId: string,
    instituteId: string,
    selfId?: string,
  ) {
    if (selfId && reportsToFacultyId === selfId) {
      throw new BadRequestException(
        `A faculty member cannot report to themselves.`,
      );
    }
    const manager = await this.prisma.faculty.findFirst({
      where: { id: reportsToFacultyId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!manager) {
      throw new NotFoundException(
        `Reporting manager faculty ${reportsToFacultyId} not found.`,
      );
    }
    if (manager.instituteId !== instituteId) {
      throw new BadRequestException(
        `Reporting manager ${reportsToFacultyId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertEmployeeCodeUnique(
    instituteId: string,
    employeeCode: string,
    ignoreId?: string,
  ) {
    const clash = await this.prisma.faculty.findFirst({
      where: {
        instituteId,
        employeeCode,
        deletedAt: null,
        ...(ignoreId ? { NOT: { id: ignoreId } } : {}),
      },
      select: { id: true },
    });
    if (clash) {
      throw new ConflictException(
        `employeeCode "${employeeCode}" already exists for this institute.`,
      );
    }
  }

  private async assertUserIdUnique(userId: string, ignoreId?: string) {
    const clash = await this.prisma.faculty.findFirst({
      where: {
        userId,
        deletedAt: null,
        ...(ignoreId ? { NOT: { id: ignoreId } } : {}),
      },
      select: { id: true },
    });
    if (clash) {
      throw new ConflictException(
        `User ${userId} is already linked to an existing faculty record.`,
      );
    }
  }
}
