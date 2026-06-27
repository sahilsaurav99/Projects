import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { AuditAction, Prisma } from '@prisma/client';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';
import { CreateSubjectDto } from './dto/create-subject.dto';
import { ListSubjectsQueryDto } from './dto/list-subjects.query';
import { UpdateSubjectDto } from './dto/update-subject.dto';

// Re-exported for future audit-log re-integration (mirrors faculty.service).
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
 * SubjectsService
 *
 * CRUD + soft delete for the Subject aggregate. Audit logging is intentionally
 * omitted in this revision (parity with faculty.service); AuditAction is
 * re-exported so a follow-up can re-wire AuditService without touching
 * controllers.
 *
 * Invariants enforced:
 *  - `code` is unique per institute among non-deleted subjects.
 *  - `instituteId` references a non-deleted Institute.
 *  - `departmentId` references a non-deleted Department belonging to the same
 *    `instituteId`.
 *  - `programId`, when provided, references a non-deleted Program belonging to
 *    the same `instituteId`.
 *  - `syllabusFileId`, when provided, references an existing FileObject.
 */
@Injectable()
export class SubjectsService {
  private readonly logger = new Logger(SubjectsService.name);

  constructor(private readonly prisma: PrismaService) {}

  // --------------------------------------------------------------------------
  // CREATE
  // --------------------------------------------------------------------------
  async create(dto: CreateSubjectDto) {
    await this.assertInstituteExists(dto.instituteId);
    await this.assertDepartmentBelongsToInstitute(
      dto.departmentId,
      dto.instituteId,
    );
    if (dto.programId) {
      await this.assertProgramBelongsToInstitute(
        dto.programId,
        dto.instituteId,
      );
    }
    if (dto.syllabusFileId) {
      await this.assertFileExists(dto.syllabusFileId);
    }
    await this.assertCodeUnique(dto.instituteId, dto.code);

    try {
      const subject = await this.prisma.subject.create({
        data: {
          instituteId: dto.instituteId,
          departmentId: dto.departmentId,
          programId: dto.programId ?? null,
          code: dto.code,
          name: dto.name,
          shortName: dto.shortName ?? null,
          type: dto.type ?? undefined,
          termSequence: dto.termSequence ?? null,
          credits: new Prisma.Decimal(dto.credits),
          lectureHours: dto.lectureHours ?? undefined,
          tutorialHours: dto.tutorialHours ?? undefined,
          practicalHours: dto.practicalHours ?? undefined,
          contactHoursWeek: dto.contactHoursWeek ?? null,
          assessmentScheme: dto.assessmentScheme ?? undefined,
          gradingScheme: dto.gradingScheme ?? undefined,
          maxMarks: dto.maxMarks ?? undefined,
          passMarks: dto.passMarks ?? undefined,
          internalWeight: dto.internalWeight ?? undefined,
          externalWeight: dto.externalWeight ?? undefined,
          syllabusFileId: dto.syllabusFileId ?? null,
          description: dto.description ?? null,
          outcomes:
            dto.outcomes === undefined
              ? undefined
              : (dto.outcomes as Prisma.InputJsonValue),
          effectiveFrom: new Date(dto.effectiveFrom),
          effectiveTo: dto.effectiveTo ? new Date(dto.effectiveTo) : null,
          isActive: dto.isActive ?? undefined,
          metadata:
            dto.metadata === undefined
              ? undefined
              : (dto.metadata as Prisma.InputJsonValue),
        },
      });

      this.logger.log(`Subject created: ${subject.id} (${subject.code})`);
      return subject;
    } catch (err) {
      if (
        err instanceof Prisma.PrismaClientKnownRequestError &&
        err.code === 'P2002'
      ) {
        throw new ConflictException(
          `Subject with code "${dto.code}" already exists for this institute.`,
        );
      }
      throw err;
    }
  }

  // --------------------------------------------------------------------------
  // READ — list with pagination/filters
  // --------------------------------------------------------------------------
  async findAll(
    query: ListSubjectsQueryDto,
  ): Promise<
    PaginatedResult<Awaited<ReturnType<typeof this.prisma.subject.findFirst>>>
  > {
    const page = query.page ?? 1;
    const pageSize = query.pageSize ?? 20;
    const sortBy = query.sortBy ?? 'createdAt';
    const sortOrder = query.sortOrder ?? 'desc';

    const where: Prisma.SubjectWhereInput = {
      ...(query.includeDeleted ? {} : { deletedAt: null }),
      ...(query.instituteId ? { instituteId: query.instituteId } : {}),
      ...(query.departmentId ? { departmentId: query.departmentId } : {}),
      ...(query.programId ? { programId: query.programId } : {}),
      ...(query.type ? { type: query.type } : {}),
      ...(query.assessmentScheme
        ? { assessmentScheme: query.assessmentScheme }
        : {}),
      ...(query.gradingScheme ? { gradingScheme: query.gradingScheme } : {}),
      ...(query.termSequence !== undefined
        ? { termSequence: query.termSequence }
        : {}),
      ...(query.isActive !== undefined ? { isActive: query.isActive } : {}),
      ...(query.search
        ? {
            OR: [
              { code: { contains: query.search, mode: 'insensitive' } },
              { name: { contains: query.search, mode: 'insensitive' } },
              { shortName: { contains: query.search, mode: 'insensitive' } },
            ],
          }
        : {}),
    };

    const [total, data] = await this.prisma.$transaction([
      this.prisma.subject.count({ where }),
      this.prisma.subject.findMany({
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
    const subject = await this.prisma.subject.findFirst({
      where: {
        id,
        ...(opts.includeDeleted ? {} : { deletedAt: null }),
      },
    });
    if (!subject) throw new NotFoundException(`Subject ${id} not found.`);
    return subject;
  }

  // --------------------------------------------------------------------------
  // UPDATE
  // --------------------------------------------------------------------------
  async update(id: string, dto: UpdateSubjectDto) {
    const existing = await this.findOne(id);

    if (dto.departmentId && dto.departmentId !== existing.departmentId) {
      await this.assertDepartmentBelongsToInstitute(
        dto.departmentId,
        existing.instituteId,
      );
    }

    if (
      dto.programId !== undefined &&
      dto.programId !== existing.programId &&
      dto.programId !== null
    ) {
      await this.assertProgramBelongsToInstitute(
        dto.programId,
        existing.instituteId,
      );
    }

    if (
      dto.syllabusFileId !== undefined &&
      dto.syllabusFileId !== existing.syllabusFileId &&
      dto.syllabusFileId !== null
    ) {
      await this.assertFileExists(dto.syllabusFileId);
    }

    if (dto.code && dto.code !== existing.code) {
      await this.assertCodeUnique(existing.instituteId, dto.code, id);
    }

    try {
      return await this.prisma.subject.update({
        where: { id },
        data: {
          departmentId: dto.departmentId ?? undefined,
          programId: dto.programId === undefined ? undefined : dto.programId,
          code: dto.code ?? undefined,
          name: dto.name ?? undefined,
          shortName: dto.shortName === undefined ? undefined : dto.shortName,
          type: dto.type ?? undefined,
          termSequence:
            dto.termSequence === undefined ? undefined : dto.termSequence,
          credits:
            dto.credits === undefined
              ? undefined
              : new Prisma.Decimal(dto.credits),
          lectureHours: dto.lectureHours ?? undefined,
          tutorialHours: dto.tutorialHours ?? undefined,
          practicalHours: dto.practicalHours ?? undefined,
          contactHoursWeek:
            dto.contactHoursWeek === undefined
              ? undefined
              : dto.contactHoursWeek,
          assessmentScheme: dto.assessmentScheme ?? undefined,
          gradingScheme: dto.gradingScheme ?? undefined,
          maxMarks: dto.maxMarks ?? undefined,
          passMarks: dto.passMarks ?? undefined,
          internalWeight: dto.internalWeight ?? undefined,
          externalWeight: dto.externalWeight ?? undefined,
          syllabusFileId:
            dto.syllabusFileId === undefined
              ? undefined
              : dto.syllabusFileId,
          description:
            dto.description === undefined ? undefined : dto.description,
          outcomes:
            dto.outcomes === undefined
              ? undefined
              : (dto.outcomes as Prisma.InputJsonValue),
          effectiveFrom: dto.effectiveFrom
            ? new Date(dto.effectiveFrom)
            : undefined,
          effectiveTo:
            dto.effectiveTo === undefined
              ? undefined
              : dto.effectiveTo
                ? new Date(dto.effectiveTo)
                : null,
          isActive: dto.isActive ?? undefined,
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
          `Subject with code "${dto.code}" already exists for this institute.`,
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
    return this.prisma.subject.update({
      where: { id: existing.id },
      data: {
        deletedAt: new Date(),
        isActive: false,
      },
    });
  }

  // --------------------------------------------------------------------------
  // RESTORE
  // --------------------------------------------------------------------------
  async restore(id: string) {
    const existing = await this.findOne(id, { includeDeleted: true });
    if (!existing.deletedAt) return existing;

    // Re-validate that the parent hierarchy is still alive and that the
    // subject code remains available.
    await this.assertDepartmentBelongsToInstitute(
      existing.departmentId,
      existing.instituteId,
    );
    if (existing.programId) {
      await this.assertProgramBelongsToInstitute(
        existing.programId,
        existing.instituteId,
      );
    }
    await this.assertCodeUnique(
      existing.instituteId,
      existing.code,
      existing.id,
    );

    return this.prisma.subject.update({
      where: { id: existing.id },
      data: {
        deletedAt: null,
        isActive: true,
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

  private async assertDepartmentBelongsToInstitute(
    departmentId: string,
    instituteId: string,
  ) {
    const department = await this.prisma.department.findFirst({
      where: { id: departmentId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!department) {
      throw new NotFoundException(`Department ${departmentId} not found.`);
    }
    if (department.instituteId !== instituteId) {
      throw new BadRequestException(
        `Department ${departmentId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertProgramBelongsToInstitute(
    programId: string,
    instituteId: string,
  ) {
    const program = await this.prisma.program.findFirst({
      where: { id: programId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!program) {
      throw new NotFoundException(`Program ${programId} not found.`);
    }
    if (program.instituteId !== instituteId) {
      throw new BadRequestException(
        `Program ${programId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertFileExists(fileId: string) {
    const file = await this.prisma.fileObject.findFirst({
      where: { id: fileId },
      select: { id: true },
    });
    if (!file) {
      throw new NotFoundException(`Syllabus file ${fileId} not found.`);
    }
  }

  private async assertCodeUnique(
    instituteId: string,
    code: string,
    excludeId?: string,
  ) {
    const existing = await this.prisma.subject.findFirst({
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
        `Subject with code "${code}" already exists for this institute.`,
      );
    }
  }
}
