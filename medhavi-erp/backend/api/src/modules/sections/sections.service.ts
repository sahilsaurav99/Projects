import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { AuditAction, Prisma } from '@prisma/client';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';
import { CreateSectionDto } from './dto/create-section.dto';
import { ListSectionsQueryDto } from './dto/list-sections.query';
import { UpdateSectionDto } from './dto/update-section.dto';

// Re-exported for future audit-log re-integration (mirrors terms.service).
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
 * SectionsService
 *
 * CRUD + soft delete for the Section aggregate. Audit logging is intentionally
 * omitted in this revision (parity with terms.service); AuditAction is
 * re-exported so a follow-up can re-wire AuditService without touching
 * controllers.
 *
 * Invariants enforced:
 *  - `instituteId` references a non-deleted Institute.
 *  - `batchId` references a non-deleted Batch belonging to the same institute.
 *  - `termId` references a non-deleted Term belonging to the same institute.
 *  - `classAdvisorFacultyId` (when provided) references a non-deleted Faculty.
 *  - `classRepUserId` (when provided) references a non-deleted User.
 *  - `code` is unique within (`batchId`, `termId`) among non-deleted sections.
 */
@Injectable()
export class SectionsService {
  private readonly logger = new Logger(SectionsService.name);

  constructor(private readonly prisma: PrismaService) {}

  // --------------------------------------------------------------------------
  // CREATE
  // --------------------------------------------------------------------------
  async create(dto: CreateSectionDto) {
    await this.assertInstituteExists(dto.instituteId);
    await this.assertBatchBelongsToInstitute(dto.batchId, dto.instituteId);
    await this.assertTermBelongsToInstitute(dto.termId, dto.instituteId);
    if (dto.classAdvisorFacultyId) {
      await this.assertFacultyExists(dto.classAdvisorFacultyId);
    }
    if (dto.classRepUserId) {
      await this.assertUserExists(dto.classRepUserId);
    }
    await this.assertCodeUnique(dto.batchId, dto.termId, dto.code);

    try {
      const section = await this.prisma.section.create({
        data: {
          instituteId: dto.instituteId,
          batchId: dto.batchId,
          termId: dto.termId,
          code: dto.code,
          name: dto.name,
          capacity: dto.capacity,
          enrolledCount: dto.enrolledCount ?? undefined,
          classRepUserId: dto.classRepUserId ?? null,
          classAdvisorFacultyId: dto.classAdvisorFacultyId ?? null,
          roomHint: dto.roomHint ?? null,
          status: dto.status ?? undefined,
          metadata:
            dto.metadata === undefined
              ? undefined
              : (dto.metadata as Prisma.InputJsonValue),
        },
      });

      this.logger.log(`Section created: ${section.id} (${section.code})`);
      return section;
    } catch (err) {
      if (
        err instanceof Prisma.PrismaClientKnownRequestError &&
        err.code === 'P2002'
      ) {
        throw new ConflictException(
          `A section with the same code already exists in this batch and term.`,
        );
      }
      throw err;
    }
  }

  // --------------------------------------------------------------------------
  // READ — list with pagination/filters
  // --------------------------------------------------------------------------
  async findAll(
    query: ListSectionsQueryDto,
  ): Promise<
    PaginatedResult<Awaited<ReturnType<typeof this.prisma.section.findFirst>>>
  > {
    const page = query.page ?? 1;
    const pageSize = query.pageSize ?? 20;
    const sortBy = query.sortBy ?? 'code';
    const sortOrder = query.sortOrder ?? 'asc';

    const where: Prisma.SectionWhereInput = {
      ...(query.includeDeleted ? {} : { deletedAt: null }),
      ...(query.instituteId ? { instituteId: query.instituteId } : {}),
      ...(query.batchId ? { batchId: query.batchId } : {}),
      ...(query.termId ? { termId: query.termId } : {}),
      ...(query.status ? { status: query.status } : {}),
      ...(query.classAdvisorFacultyId
        ? { classAdvisorFacultyId: query.classAdvisorFacultyId }
        : {}),
      ...(query.search
        ? {
            OR: [
              { code: { contains: query.search, mode: 'insensitive' } },
              { name: { contains: query.search, mode: 'insensitive' } },
            ],
          }
        : {}),
    };

    const [total, data] = await this.prisma.$transaction([
      this.prisma.section.count({ where }),
      this.prisma.section.findMany({
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
    const section = await this.prisma.section.findFirst({
      where: {
        id,
        ...(opts.includeDeleted ? {} : { deletedAt: null }),
      },
    });
    if (!section) throw new NotFoundException(`Section ${id} not found.`);
    return section;
  }

  // --------------------------------------------------------------------------
  // UPDATE
  // --------------------------------------------------------------------------
  async update(id: string, dto: UpdateSectionDto) {
    const existing = await this.findOne(id);

    if (dto.batchId && dto.batchId !== existing.batchId) {
      await this.assertBatchBelongsToInstitute(
        dto.batchId,
        existing.instituteId,
      );
    }

    if (dto.termId && dto.termId !== existing.termId) {
      await this.assertTermBelongsToInstitute(dto.termId, existing.instituteId);
    }

    if (
      dto.classAdvisorFacultyId &&
      dto.classAdvisorFacultyId !== existing.classAdvisorFacultyId
    ) {
      await this.assertFacultyExists(dto.classAdvisorFacultyId);
    }

    if (
      dto.classRepUserId &&
      dto.classRepUserId !== existing.classRepUserId
    ) {
      await this.assertUserExists(dto.classRepUserId);
    }

    const targetBatchId = dto.batchId ?? existing.batchId;
    const targetTermId = dto.termId ?? existing.termId;

    if (
      (dto.code && dto.code !== existing.code) ||
      (dto.batchId && dto.batchId !== existing.batchId) ||
      (dto.termId && dto.termId !== existing.termId)
    ) {
      await this.assertCodeUnique(
        targetBatchId,
        targetTermId,
        dto.code ?? existing.code,
        id,
      );
    }

    if (
      dto.capacity !== undefined &&
      dto.capacity < (dto.enrolledCount ?? existing.enrolledCount)
    ) {
      throw new BadRequestException(
        'capacity cannot be less than enrolledCount.',
      );
    }

    try {
      return await this.prisma.section.update({
        where: { id },
        data: {
          batchId: dto.batchId ?? undefined,
          termId: dto.termId ?? undefined,
          code: dto.code ?? undefined,
          name: dto.name ?? undefined,
          capacity: dto.capacity ?? undefined,
          enrolledCount: dto.enrolledCount ?? undefined,
          classRepUserId:
            dto.classRepUserId === undefined
              ? undefined
              : (dto.classRepUserId ?? null),
          classAdvisorFacultyId:
            dto.classAdvisorFacultyId === undefined
              ? undefined
              : (dto.classAdvisorFacultyId ?? null),
          roomHint:
            dto.roomHint === undefined ? undefined : (dto.roomHint ?? null),
          status: dto.status ?? undefined,
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
          `A section with the same code already exists in this batch and term.`,
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
    return this.prisma.section.update({
      where: { id: existing.id },
      data: { deletedAt: new Date() },
    });
  }

  // --------------------------------------------------------------------------
  // RESTORE
  // --------------------------------------------------------------------------
  async restore(id: string) {
    const existing = await this.findOne(id, { includeDeleted: true });
    if (!existing.deletedAt) return existing;

    // Re-validate parent hierarchy and uniqueness on restore.
    await this.assertBatchBelongsToInstitute(
      existing.batchId,
      existing.instituteId,
    );
    await this.assertTermBelongsToInstitute(
      existing.termId,
      existing.instituteId,
    );
    await this.assertCodeUnique(
      existing.batchId,
      existing.termId,
      existing.code,
      existing.id,
    );

    return this.prisma.section.update({
      where: { id: existing.id },
      data: { deletedAt: null },
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

  private async assertBatchBelongsToInstitute(
    batchId: string,
    instituteId: string,
  ) {
    const batch = await this.prisma.batch.findFirst({
      where: { id: batchId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!batch) {
      throw new NotFoundException(`Batch ${batchId} not found.`);
    }
    if (batch.instituteId !== instituteId) {
      throw new BadRequestException(
        `Batch ${batchId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertTermBelongsToInstitute(
    termId: string,
    instituteId: string,
  ) {
    const term = await this.prisma.term.findFirst({
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

  private async assertFacultyExists(facultyId: string) {
    const faculty = await this.prisma.faculty.findFirst({
      where: { id: facultyId, deletedAt: null },
      select: { id: true },
    });
    if (!faculty) {
      throw new NotFoundException(`Faculty ${facultyId} not found.`);
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

  private async assertCodeUnique(
    batchId: string,
    termId: string,
    code: string,
    excludeId?: string,
  ) {
    const existing = await this.prisma.section.findFirst({
      where: {
        batchId,
        termId,
        code,
        deletedAt: null,
        ...(excludeId ? { NOT: { id: excludeId } } : {}),
      },
      select: { id: true },
    });
    if (existing) {
      throw new ConflictException(
        `Section with code "${code}" already exists in this batch and term.`,
      );
    }
  }
}
