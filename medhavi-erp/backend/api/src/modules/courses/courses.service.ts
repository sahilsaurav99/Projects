import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { AuditAction, Prisma } from '@prisma/client';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';
import { CreateCourseDto } from './dto/create-course.dto';
import { ListCoursesQueryDto } from './dto/list-courses.query';
import { UpdateCourseDto } from './dto/update-course.dto';

// Re-exported for future audit-log re-integration (mirrors
// subject-offerings.service).
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

/**
 * CoursesService
 *
 * CRUD + soft delete for the Course aggregate. Audit logging is intentionally
 * omitted in this revision (parity with subject-offerings.service);
 * AuditAction is re-exported so a follow-up can re-wire AuditService without
 * touching controllers.
 *
 * Invariants enforced:
 *  - `instituteId` references a non-deleted Institute.
 *  - `ownerFacultyId` references a non-deleted Faculty belonging to the same institute.
 *  - `subjectOfferingId` (when provided) references a non-deleted SubjectOffering
 *    belonging to the same institute.
 *  - `termId` (when provided) references a non-deleted Term belonging to the same institute.
 *  - `code` is unique within `instituteId` among non-deleted courses.
 *  - `startsAt` <= `endsAt` when both are provided.
 */
@Injectable()
export class CoursesService {
  private readonly logger = new Logger(CoursesService.name);

  constructor(private readonly prisma: PrismaService) {}

  // --------------------------------------------------------------------------
  // CREATE
  // --------------------------------------------------------------------------
  async create(dto: CreateCourseDto) {
    return this.prisma.$transaction(async (tx) => {
      await this.assertInstituteExists(tx, dto.instituteId);
      await this.assertOwnerFacultyBelongsToInstitute(
        tx,
        dto.ownerFacultyId,
        dto.instituteId,
      );
      if (dto.subjectOfferingId) {
        await this.assertSubjectOfferingBelongsToInstitute(
          tx,
          dto.subjectOfferingId,
          dto.instituteId,
        );
      }
      if (dto.termId) {
        await this.assertTermBelongsToInstitute(
          tx,
          dto.termId,
          dto.instituteId,
        );
      }

      this.assertScheduleWindow(dto.startsAt, dto.endsAt);

      await this.assertCodeUnique(tx, dto.instituteId, dto.code);

      try {
        const course = await tx.course.create({
          data: {
            instituteId: dto.instituteId,
            subjectOfferingId: dto.subjectOfferingId ?? null,
            termId: dto.termId ?? null,
            ownerFacultyId: dto.ownerFacultyId,
            code: dto.code,
            title: dto.title,
            description: dto.description ?? null,
            coverImageUrl: dto.coverImageUrl ?? null,
            status: dto.status ?? undefined,
            isSelfPaced: dto.isSelfPaced ?? undefined,
            startsAt: dto.startsAt ? new Date(dto.startsAt) : null,
            endsAt: dto.endsAt ? new Date(dto.endsAt) : null,
            syllabusUrl: dto.syllabusUrl ?? null,
            estimatedHours:
              dto.estimatedHours === undefined
                ? undefined
                : new Prisma.Decimal(dto.estimatedHours),
            metadata:
              dto.metadata === undefined
                ? undefined
                : (dto.metadata as Prisma.InputJsonValue),
          },
        });

        this.logger.log(`Course created: ${course.id} (${course.code})`);
        return course;
      } catch (err) {
        this.translateUniqueViolation(err);
        throw err;
      }
    });
  }

  // --------------------------------------------------------------------------
  // READ — list with pagination/filters
  // --------------------------------------------------------------------------
  async findAll(
    query: ListCoursesQueryDto,
  ): Promise<
    PaginatedResult<Awaited<ReturnType<typeof this.prisma.course.findFirst>>>
  > {
    const page = query.page ?? 1;
    const pageSize = query.pageSize ?? 20;
    const sortBy = query.sortBy ?? 'code';
    const sortOrder = query.sortOrder ?? 'asc';

    const where: Prisma.CourseWhereInput = {
      ...(query.includeDeleted ? {} : { deletedAt: null }),
      ...(query.instituteId ? { instituteId: query.instituteId } : {}),
      ...(query.subjectOfferingId
        ? { subjectOfferingId: query.subjectOfferingId }
        : {}),
      ...(query.termId ? { termId: query.termId } : {}),
      ...(query.ownerFacultyId
        ? { ownerFacultyId: query.ownerFacultyId }
        : {}),
      ...(query.status ? { status: query.status } : {}),
      ...(query.isSelfPaced !== undefined
        ? { isSelfPaced: query.isSelfPaced }
        : {}),
      ...(query.search
        ? {
            OR: [
              { code: { contains: query.search, mode: 'insensitive' } },
              { title: { contains: query.search, mode: 'insensitive' } },
            ],
          }
        : {}),
    };

    const [total, data] = await this.prisma.$transaction([
      this.prisma.course.count({ where }),
      this.prisma.course.findMany({
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
    const course = await this.prisma.course.findFirst({
      where: {
        id,
        ...(opts.includeDeleted ? {} : { deletedAt: null }),
      },
    });
    if (!course) {
      throw new NotFoundException(`Course ${id} not found.`);
    }
    return course;
  }

  // --------------------------------------------------------------------------
  // UPDATE
  // --------------------------------------------------------------------------
  async update(id: string, dto: UpdateCourseDto) {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.course.findFirst({
        where: { id, deletedAt: null },
      });
      if (!existing) {
        throw new NotFoundException(`Course ${id} not found.`);
      }

      if (
        dto.ownerFacultyId &&
        dto.ownerFacultyId !== existing.ownerFacultyId
      ) {
        await this.assertOwnerFacultyBelongsToInstitute(
          tx,
          dto.ownerFacultyId,
          existing.instituteId,
        );
      }
      if (
        dto.subjectOfferingId !== undefined &&
        dto.subjectOfferingId !== existing.subjectOfferingId
      ) {
        if (dto.subjectOfferingId) {
          await this.assertSubjectOfferingBelongsToInstitute(
            tx,
            dto.subjectOfferingId,
            existing.instituteId,
          );
        }
      }
      if (dto.termId !== undefined && dto.termId !== existing.termId) {
        if (dto.termId) {
          await this.assertTermBelongsToInstitute(
            tx,
            dto.termId,
            existing.instituteId,
          );
        }
      }

      if (dto.code && dto.code !== existing.code) {
        await this.assertCodeUnique(tx, existing.instituteId, dto.code, id);
      }

      const nextStart =
        dto.startsAt !== undefined
          ? dto.startsAt
            ? new Date(dto.startsAt)
            : null
          : existing.startsAt;
      const nextEnd =
        dto.endsAt !== undefined
          ? dto.endsAt
            ? new Date(dto.endsAt)
            : null
          : existing.endsAt;
      this.assertScheduleWindow(nextStart ?? undefined, nextEnd ?? undefined);

      try {
        return await tx.course.update({
          where: { id },
          data: {
            subjectOfferingId:
              dto.subjectOfferingId === undefined
                ? undefined
                : (dto.subjectOfferingId ?? null),
            termId:
              dto.termId === undefined ? undefined : (dto.termId ?? null),
            ownerFacultyId: dto.ownerFacultyId ?? undefined,
            code: dto.code ?? undefined,
            title: dto.title ?? undefined,
            description:
              dto.description === undefined
                ? undefined
                : (dto.description ?? null),
            coverImageUrl:
              dto.coverImageUrl === undefined
                ? undefined
                : (dto.coverImageUrl ?? null),
            status: dto.status ?? undefined,
            isSelfPaced:
              dto.isSelfPaced === undefined ? undefined : dto.isSelfPaced,
            startsAt:
              dto.startsAt === undefined
                ? undefined
                : dto.startsAt
                  ? new Date(dto.startsAt)
                  : null,
            endsAt:
              dto.endsAt === undefined
                ? undefined
                : dto.endsAt
                  ? new Date(dto.endsAt)
                  : null,
            syllabusUrl:
              dto.syllabusUrl === undefined
                ? undefined
                : (dto.syllabusUrl ?? null),
            estimatedHours:
              dto.estimatedHours === undefined
                ? undefined
                : new Prisma.Decimal(dto.estimatedHours),
            metadata:
              dto.metadata === undefined
                ? undefined
                : (dto.metadata as Prisma.InputJsonValue),
          },
        });
      } catch (err) {
        this.translateUniqueViolation(err);
        throw err;
      }
    });
  }

  // --------------------------------------------------------------------------
  // SOFT DELETE
  // --------------------------------------------------------------------------
  async remove(id: string) {
    const existing = await this.findOne(id);
    return this.prisma.course.update({
      where: { id: existing.id },
      data: { deletedAt: new Date() },
    });
  }

  // --------------------------------------------------------------------------
  // RESTORE
  // --------------------------------------------------------------------------
  async restore(id: string) {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.course.findFirst({ where: { id } });
      if (!existing) {
        throw new NotFoundException(`Course ${id} not found.`);
      }
      if (!existing.deletedAt) return existing;

      // Re-validate hierarchy and uniqueness on restore.
      await this.assertOwnerFacultyBelongsToInstitute(
        tx,
        existing.ownerFacultyId,
        existing.instituteId,
      );
      if (existing.subjectOfferingId) {
        await this.assertSubjectOfferingBelongsToInstitute(
          tx,
          existing.subjectOfferingId,
          existing.instituteId,
        );
      }
      if (existing.termId) {
        await this.assertTermBelongsToInstitute(
          tx,
          existing.termId,
          existing.instituteId,
        );
      }
      await this.assertCodeUnique(
        tx,
        existing.instituteId,
        existing.code,
        existing.id,
      );

      return tx.course.update({
        where: { id: existing.id },
        data: { deletedAt: null },
      });
    });
  }

  // --------------------------------------------------------------------------
  // Internal helpers
  // --------------------------------------------------------------------------
  private async assertInstituteExists(
    tx: Prisma.TransactionClient,
    instituteId: string,
  ) {
    const institute = await tx.institute.findFirst({
      where: { id: instituteId, deletedAt: null },
      select: { id: true },
    });
    if (!institute) {
      throw new NotFoundException(`Institute ${instituteId} not found.`);
    }
  }

  private async assertOwnerFacultyBelongsToInstitute(
    tx: Prisma.TransactionClient,
    facultyId: string,
    instituteId: string,
  ) {
    const faculty = await tx.faculty.findFirst({
      where: { id: facultyId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!faculty) {
      throw new NotFoundException(`Faculty ${facultyId} not found.`);
    }
    if (faculty.instituteId !== instituteId) {
      throw new BadRequestException(
        `Faculty ${facultyId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertSubjectOfferingBelongsToInstitute(
    tx: Prisma.TransactionClient,
    subjectOfferingId: string,
    instituteId: string,
  ) {
    const offering = await tx.subjectOffering.findFirst({
      where: { id: subjectOfferingId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!offering) {
      throw new NotFoundException(
        `SubjectOffering ${subjectOfferingId} not found.`,
      );
    }
    if (offering.instituteId !== instituteId) {
      throw new BadRequestException(
        `SubjectOffering ${subjectOfferingId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertTermBelongsToInstitute(
    tx: Prisma.TransactionClient,
    termId: string,
    instituteId: string,
  ) {
    const term = await tx.term.findFirst({
      where: { id: termId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!term) {
      throw new NotFoundException(`Term ${termId} not found.`);
    }
    if (term.instituteId !== instituteId) {
      throw new BadRequestException(
        `Term ${termId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertCodeUnique(
    tx: Prisma.TransactionClient,
    instituteId: string,
    code: string,
    excludeId?: string,
  ) {
    const existing = await tx.course.findFirst({
      where: {
        instituteId,
        code,
        deletedAt: null,
        ...(excludeId ? { NOT: { id: excludeId } } : {}),
      },
      select: { id: true },
    });
    if (existing) {
      throw new ConflictException(
        `Course with code "${code}" already exists in this institute.`,
      );
    }
  }

  private assertScheduleWindow(start?: Date | string, end?: Date | string) {
    if (!start || !end) return;
    const s = start instanceof Date ? start : new Date(start);
    const e = end instanceof Date ? end : new Date(end);
    if (s.getTime() > e.getTime()) {
      throw new BadRequestException('startsAt must be on or before endsAt.');
    }
  }

  private translateUniqueViolation(err: unknown): void {
    if (
      err instanceof Prisma.PrismaClientKnownRequestError &&
      err.code === 'P2002'
    ) {
      throw new ConflictException(
        'A Course with the same code already exists in this institute.',
      );
    }
  }
}
