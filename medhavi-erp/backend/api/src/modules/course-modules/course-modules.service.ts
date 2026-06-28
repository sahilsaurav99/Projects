import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { AuditAction, Prisma } from '@prisma/client';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';
import { CreateCourseModuleDto } from './dto/create-course-module.dto';
import { ListCourseModulesQueryDto } from './dto/list-course-modules.query';
import { UpdateCourseModuleDto } from './dto/update-course-module.dto';

// Re-exported for future audit-log re-integration (mirrors courses.service).
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
 * CourseModulesService
 *
 * CRUD + soft delete for the CourseModule aggregate. Audit logging is
 * intentionally omitted in this revision (parity with courses.service);
 * AuditAction is re-exported so a follow-up can re-wire AuditService without
 * touching controllers.
 *
 * Invariants enforced:
 *  - `instituteId` references a non-deleted Institute.
 *  - `courseId` references a non-deleted Course belonging to the same institute.
 *  - `parentId` (when provided) references a non-deleted CourseModule that
 *    belongs to the same course AND the same institute.
 *  - A module cannot be its own parent or descendant (cycle prevention on update).
 *  - `orderIndex` is unique within `(courseId, parentId)` among non-deleted
 *    modules. (Matches the Prisma `@@unique([courseId, parentId, orderIndex])`
 *    but ignores soft-deleted rows.)
 *  - `unlocksAt` <= `locksAt` when both are provided.
 */
@Injectable()
export class CourseModulesService {
  private readonly logger = new Logger(CourseModulesService.name);

  constructor(private readonly prisma: PrismaService) {}

  // --------------------------------------------------------------------------
  // CREATE
  // --------------------------------------------------------------------------
  async create(dto: CreateCourseModuleDto) {
    return this.prisma.$transaction(async (tx) => {
      await this.assertInstituteExists(tx, dto.instituteId);
      await this.assertCourseBelongsToInstitute(
        tx,
        dto.courseId,
        dto.instituteId,
      );
      if (dto.parentId) {
        await this.assertParentValid(
          tx,
          dto.parentId,
          dto.courseId,
          dto.instituteId,
        );
      }

      this.assertUnlockWindow(dto.unlocksAt, dto.locksAt);

      await this.assertOrderIndexUnique(
        tx,
        dto.courseId,
        dto.parentId ?? null,
        dto.orderIndex,
      );

      try {
        const courseModule = await tx.courseModule.create({
          data: {
            instituteId: dto.instituteId,
            courseId: dto.courseId,
            parentId: dto.parentId ?? null,
            title: dto.title,
            description: dto.description ?? null,
            orderIndex: dto.orderIndex,
            status: dto.status ?? undefined,
            unlocksAt: dto.unlocksAt ? new Date(dto.unlocksAt) : null,
            locksAt: dto.locksAt ? new Date(dto.locksAt) : null,
          },
        });

        this.logger.log(
          `CourseModule created: ${courseModule.id} (${courseModule.title})`,
        );
        return courseModule;
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
    query: ListCourseModulesQueryDto,
  ): Promise<
    PaginatedResult<
      Awaited<ReturnType<typeof this.prisma.courseModule.findFirst>>
    >
  > {
    const page = query.page ?? 1;
    const pageSize = query.pageSize ?? 20;
    const sortBy = query.sortBy ?? 'orderIndex';
    const sortOrder = query.sortOrder ?? 'asc';

    const where: Prisma.CourseModuleWhereInput = {
      ...(query.includeDeleted ? {} : { deletedAt: null }),
      ...(query.instituteId ? { instituteId: query.instituteId } : {}),
      ...(query.courseId ? { courseId: query.courseId } : {}),
      ...(query.rootOnly
        ? { parentId: null }
        : query.parentId
          ? { parentId: query.parentId }
          : {}),
      ...(query.status ? { status: query.status } : {}),
      ...(query.search
        ? {
            OR: [{ title: { contains: query.search, mode: 'insensitive' } }],
          }
        : {}),
    };

    const [total, data] = await this.prisma.$transaction([
      this.prisma.courseModule.count({ where }),
      this.prisma.courseModule.findMany({
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
    const courseModule = await this.prisma.courseModule.findFirst({
      where: {
        id,
        ...(opts.includeDeleted ? {} : { deletedAt: null }),
      },
    });
    if (!courseModule) {
      throw new NotFoundException(`CourseModule ${id} not found.`);
    }
    return courseModule;
  }

  // --------------------------------------------------------------------------
  // UPDATE
  // --------------------------------------------------------------------------
  async update(id: string, dto: UpdateCourseModuleDto) {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.courseModule.findFirst({
        where: { id, deletedAt: null },
      });
      if (!existing) {
        throw new NotFoundException(`CourseModule ${id} not found.`);
      }

      const nextParentId =
        dto.parentId !== undefined ? (dto.parentId ?? null) : existing.parentId;

      if (dto.parentId !== undefined && dto.parentId !== existing.parentId) {
        if (dto.parentId) {
          if (dto.parentId === id) {
            throw new BadRequestException(
              'A CourseModule cannot be its own parent.',
            );
          }
          await this.assertParentValid(
            tx,
            dto.parentId,
            existing.courseId,
            existing.instituteId,
          );
          await this.assertNotDescendant(tx, id, dto.parentId);
        }
      }

      const nextOrderIndex =
        dto.orderIndex !== undefined ? dto.orderIndex : existing.orderIndex;

      const parentChanged = nextParentId !== existing.parentId;
      const orderChanged = nextOrderIndex !== existing.orderIndex;
      if (parentChanged || orderChanged) {
        await this.assertOrderIndexUnique(
          tx,
          existing.courseId,
          nextParentId,
          nextOrderIndex,
          id,
        );
      }

      const nextUnlocks =
        dto.unlocksAt !== undefined
          ? dto.unlocksAt
            ? new Date(dto.unlocksAt)
            : null
          : existing.unlocksAt;
      const nextLocks =
        dto.locksAt !== undefined
          ? dto.locksAt
            ? new Date(dto.locksAt)
            : null
          : existing.locksAt;
      this.assertUnlockWindow(
        nextUnlocks ?? undefined,
        nextLocks ?? undefined,
      );

      try {
        return await tx.courseModule.update({
          where: { id },
          data: {
            parentId:
              dto.parentId === undefined ? undefined : (dto.parentId ?? null),
            title: dto.title ?? undefined,
            description:
              dto.description === undefined
                ? undefined
                : (dto.description ?? null),
            orderIndex:
              dto.orderIndex === undefined ? undefined : dto.orderIndex,
            status: dto.status ?? undefined,
            unlocksAt:
              dto.unlocksAt === undefined
                ? undefined
                : dto.unlocksAt
                  ? new Date(dto.unlocksAt)
                  : null,
            locksAt:
              dto.locksAt === undefined
                ? undefined
                : dto.locksAt
                  ? new Date(dto.locksAt)
                  : null,
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
    return this.prisma.courseModule.update({
      where: { id: existing.id },
      data: { deletedAt: new Date() },
    });
  }

  // --------------------------------------------------------------------------
  // RESTORE
  // --------------------------------------------------------------------------
  async restore(id: string) {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.courseModule.findFirst({ where: { id } });
      if (!existing) {
        throw new NotFoundException(`CourseModule ${id} not found.`);
      }
      if (!existing.deletedAt) return existing;

      // Re-validate hierarchy and uniqueness on restore.
      await this.assertCourseBelongsToInstitute(
        tx,
        existing.courseId,
        existing.instituteId,
      );
      if (existing.parentId) {
        await this.assertParentValid(
          tx,
          existing.parentId,
          existing.courseId,
          existing.instituteId,
        );
      }
      await this.assertOrderIndexUnique(
        tx,
        existing.courseId,
        existing.parentId,
        existing.orderIndex,
        existing.id,
      );

      return tx.courseModule.update({
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

  private async assertCourseBelongsToInstitute(
    tx: Prisma.TransactionClient,
    courseId: string,
    instituteId: string,
  ) {
    const course = await tx.course.findFirst({
      where: { id: courseId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!course) {
      throw new NotFoundException(`Course ${courseId} not found.`);
    }
    if (course.instituteId !== instituteId) {
      throw new BadRequestException(
        `Course ${courseId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertParentValid(
    tx: Prisma.TransactionClient,
    parentId: string,
    courseId: string,
    instituteId: string,
  ) {
    const parent = await tx.courseModule.findFirst({
      where: { id: parentId, deletedAt: null },
      select: { id: true, courseId: true, instituteId: true },
    });
    if (!parent) {
      throw new NotFoundException(`Parent CourseModule ${parentId} not found.`);
    }
    if (parent.instituteId !== instituteId) {
      throw new BadRequestException(
        `Parent CourseModule ${parentId} does not belong to institute ${instituteId}.`,
      );
    }
    if (parent.courseId !== courseId) {
      throw new BadRequestException(
        `Parent CourseModule ${parentId} does not belong to course ${courseId}.`,
      );
    }
  }

  /**
   * Prevent cycles: walk the prospective parent's ancestor chain and ensure
   * `id` is not encountered.
   */
  private async assertNotDescendant(
    tx: Prisma.TransactionClient,
    id: string,
    prospectiveParentId: string,
  ) {
    let cursor: string | null = prospectiveParentId;
    const visited = new Set<string>();
    while (cursor) {
      if (cursor === id) {
        throw new BadRequestException(
          'Cannot set parent to a descendant of this module (cycle).',
        );
      }
      if (visited.has(cursor)) {
        // Defensive guard against pre-existing corrupt data.
        break;
      }
      visited.add(cursor);
      const node: { parentId: string | null } | null =
        await tx.courseModule.findUnique({
          where: { id: cursor },
          select: { parentId: true },
        });
      cursor = node?.parentId ?? null;
    }
  }

  private async assertOrderIndexUnique(
    tx: Prisma.TransactionClient,
    courseId: string,
    parentId: string | null,
    orderIndex: number,
    excludeId?: string,
  ) {
    const clash = await tx.courseModule.findFirst({
      where: {
        courseId,
        parentId,
        orderIndex,
        deletedAt: null,
        ...(excludeId ? { NOT: { id: excludeId } } : {}),
      },
      select: { id: true },
    });
    if (clash) {
      throw new ConflictException(
        `orderIndex ${orderIndex} is already used within this parent module.`,
      );
    }
  }

  private assertUnlockWindow(start?: Date | string, end?: Date | string) {
    if (!start || !end) return;
    const s = start instanceof Date ? start : new Date(start);
    const e = end instanceof Date ? end : new Date(end);
    if (s.getTime() > e.getTime()) {
      throw new BadRequestException('unlocksAt must be on or before locksAt.');
    }
  }

  private translateUniqueViolation(err: unknown): void {
    if (
      err instanceof Prisma.PrismaClientKnownRequestError &&
      err.code === 'P2002'
    ) {
      throw new ConflictException(
        'A CourseModule with the same orderIndex already exists within this parent.',
      );
    }
  }
}
