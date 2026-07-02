import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { AuditAction, Prisma } from '@prisma/client';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';
import { CreateLmsSessionDto } from './dto/create-lms-session.dto';
import { ListLmsSessionsQueryDto } from './dto/list-lms-sessions.query';
import { UpdateLmsSessionDto } from './dto/update-lms-session.dto';

// Re-exported for future audit-log re-integration (mirrors course-modules.service).
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
 * LmsSessionsService
 *
 * CRUD + soft delete for the LmsSession aggregate. Audit logging is
 * intentionally omitted in this revision (parity with course-modules.service);
 * AuditAction is re-exported so a follow-up can re-wire AuditService without
 * touching controllers.
 *
 * Invariants enforced:
 *  - `instituteId` references a non-deleted Institute.
 *  - `moduleId` references a non-deleted CourseModule that belongs to the
 *    same institute.
 *  - `orderIndex` is unique within `(moduleId)` among non-deleted sessions
 *    (matches the Prisma `@@unique([moduleId, orderIndex])` but ignores
 *    soft-deleted rows).
 */
@Injectable()
export class LmsSessionsService {
  private readonly logger = new Logger(LmsSessionsService.name);

  constructor(private readonly prisma: PrismaService) {}

  // --------------------------------------------------------------------------
  // CREATE
  // --------------------------------------------------------------------------
  async create(dto: CreateLmsSessionDto) {
    return this.prisma.$transaction(async (tx) => {
      await this.assertInstituteExists(tx, dto.instituteId);
      await this.assertModuleBelongsToInstitute(
        tx,
        dto.moduleId,
        dto.instituteId,
      );

      await this.assertOrderIndexUnique(tx, dto.moduleId, dto.orderIndex);

      try {
        const session = await tx.lmsSession.create({
          data: {
            instituteId: dto.instituteId,
            moduleId: dto.moduleId,
            title: dto.title,
            description: dto.description ?? null,
            type: dto.type,
            orderIndex: dto.orderIndex,
            durationMin: dto.durationMin ?? null,
            scheduledAt: dto.scheduledAt ? new Date(dto.scheduledAt) : null,
            meetingUrl: dto.meetingUrl ?? null,
            recordingUrl: dto.recordingUrl ?? null,
            contentMarkdown: dto.contentMarkdown ?? null,
            isMandatory: dto.isMandatory ?? undefined,
          },
        });

        this.logger.log(
          `LmsSession created: ${session.id} (${session.title})`,
        );
        return session;
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
    query: ListLmsSessionsQueryDto,
  ): Promise<
    PaginatedResult<Awaited<ReturnType<typeof this.prisma.lmsSession.findFirst>>>
  > {
    const page = query.page ?? 1;
    const pageSize = query.pageSize ?? 20;
    const sortBy = query.sortBy ?? 'orderIndex';
    const sortOrder = query.sortOrder ?? 'asc';

    const where: Prisma.LmsSessionWhereInput = {
      ...(query.includeDeleted ? {} : { deletedAt: null }),
      ...(query.instituteId ? { instituteId: query.instituteId } : {}),
      ...(query.moduleId ? { moduleId: query.moduleId } : {}),
      ...(query.type ? { type: query.type } : {}),
      ...(query.isMandatory !== undefined
        ? { isMandatory: query.isMandatory }
        : {}),
      ...(query.search
        ? {
            OR: [
              { title: { contains: query.search, mode: 'insensitive' } },
              { description: { contains: query.search, mode: 'insensitive' } },
            ],
          }
        : {}),
    };

    const [total, data] = await this.prisma.$transaction([
      this.prisma.lmsSession.count({ where }),
      this.prisma.lmsSession.findMany({
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
    const session = await this.prisma.lmsSession.findFirst({
      where: {
        id,
        ...(opts.includeDeleted ? {} : { deletedAt: null }),
      },
    });
    if (!session) {
      throw new NotFoundException(`LmsSession ${id} not found.`);
    }
    return session;
  }

  // --------------------------------------------------------------------------
  // UPDATE
  // --------------------------------------------------------------------------
  async update(id: string, dto: UpdateLmsSessionDto) {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.lmsSession.findFirst({
        where: { id, deletedAt: null },
      });
      if (!existing) {
        throw new NotFoundException(`LmsSession ${id} not found.`);
      }

      const nextOrderIndex =
        dto.orderIndex !== undefined ? dto.orderIndex : existing.orderIndex;

      if (nextOrderIndex !== existing.orderIndex) {
        await this.assertOrderIndexUnique(
          tx,
          existing.moduleId,
          nextOrderIndex,
          id,
        );
      }

      try {
        return await tx.lmsSession.update({
          where: { id },
          data: {
            title: dto.title ?? undefined,
            description:
              dto.description === undefined
                ? undefined
                : (dto.description ?? null),
            type: dto.type ?? undefined,
            orderIndex:
              dto.orderIndex === undefined ? undefined : dto.orderIndex,
            durationMin:
              dto.durationMin === undefined
                ? undefined
                : (dto.durationMin ?? null),
            scheduledAt:
              dto.scheduledAt === undefined
                ? undefined
                : dto.scheduledAt
                  ? new Date(dto.scheduledAt)
                  : null,
            meetingUrl:
              dto.meetingUrl === undefined
                ? undefined
                : (dto.meetingUrl ?? null),
            recordingUrl:
              dto.recordingUrl === undefined
                ? undefined
                : (dto.recordingUrl ?? null),
            contentMarkdown:
              dto.contentMarkdown === undefined
                ? undefined
                : (dto.contentMarkdown ?? null),
            isMandatory:
              dto.isMandatory === undefined ? undefined : dto.isMandatory,
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
    return this.prisma.lmsSession.update({
      where: { id: existing.id },
      data: { deletedAt: new Date() },
    });
  }

  // --------------------------------------------------------------------------
  // RESTORE
  // --------------------------------------------------------------------------
  async restore(id: string) {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.lmsSession.findFirst({ where: { id } });
      if (!existing) {
        throw new NotFoundException(`LmsSession ${id} not found.`);
      }
      if (!existing.deletedAt) return existing;

      // Re-validate hierarchy and uniqueness on restore.
      await this.assertModuleBelongsToInstitute(
        tx,
        existing.moduleId,
        existing.instituteId,
      );
      await this.assertOrderIndexUnique(
        tx,
        existing.moduleId,
        existing.orderIndex,
        existing.id,
      );

      return tx.lmsSession.update({
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

  private async assertModuleBelongsToInstitute(
    tx: Prisma.TransactionClient,
    moduleId: string,
    instituteId: string,
  ) {
    const mod = await tx.courseModule.findFirst({
      where: { id: moduleId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!mod) {
      throw new NotFoundException(`CourseModule ${moduleId} not found.`);
    }
    if (mod.instituteId !== instituteId) {
      throw new BadRequestException(
        `CourseModule ${moduleId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertOrderIndexUnique(
    tx: Prisma.TransactionClient,
    moduleId: string,
    orderIndex: number,
    excludeId?: string,
  ) {
    const clash = await tx.lmsSession.findFirst({
      where: {
        moduleId,
        orderIndex,
        deletedAt: null,
        ...(excludeId ? { NOT: { id: excludeId } } : {}),
      },
      select: { id: true },
    });
    if (clash) {
      throw new ConflictException(
        `orderIndex ${orderIndex} is already used within this module.`,
      );
    }
  }

  private translateUniqueViolation(err: unknown): void {
    if (
      err instanceof Prisma.PrismaClientKnownRequestError &&
      err.code === 'P2002'
    ) {
      throw new ConflictException(
        'An LmsSession with the same orderIndex already exists within this module.',
      );
    }
  }
}
