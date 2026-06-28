import {
  BadRequestException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { AuditAction, Prisma } from '@prisma/client';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';
import { CreateResourceDto } from './dto/create-resource.dto';
import { ListResourcesQueryDto } from './dto/list-resources.query';
import { UpdateResourceDto } from './dto/update-resource.dto';

// Re-exported for future audit-log re-integration (mirrors courses /
// course-modules services).
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
 * ResourcesService
 *
 * CRUD + soft delete for the Resource aggregate. Audit logging is
 * intentionally omitted in this revision (parity with courses /
 * course-modules services); AuditAction is re-exported so a follow-up
 * can re-wire AuditService without touching controllers.
 *
 * Invariants enforced:
 *  - `instituteId` references a non-deleted Institute.
 *  - `courseId`     (when provided) references a non-deleted Course
 *                    belonging to the same institute.
 *  - `moduleId`     (when provided) references a non-deleted CourseModule
 *                    belonging to the same institute; if `courseId` is also
 *                    provided, the module must belong to that course.
 *  - `sessionId`    (when provided) references a non-deleted LmsSession
 *                    belonging to the same institute; if `moduleId` is also
 *                    provided, the session must belong to that module.
 *  - `fileObjectId` (when provided) references a non-deleted FileObject
 *                    belonging to the same institute.
 *  - `createdById`  (when provided) references a non-deleted User
 *                    belonging to the same institute.
 */
@Injectable()
export class ResourcesService {
  private readonly logger = new Logger(ResourcesService.name);

  constructor(private readonly prisma: PrismaService) {}

  // --------------------------------------------------------------------------
  // CREATE
  // --------------------------------------------------------------------------
  async create(dto: CreateResourceDto) {
    return this.prisma.$transaction(async (tx) => {
      await this.assertInstituteExists(tx, dto.instituteId);

      if (dto.courseId) {
        await this.assertCourseBelongsToInstitute(
          tx,
          dto.courseId,
          dto.instituteId,
        );
      }
      if (dto.moduleId) {
        await this.assertModuleValid(
          tx,
          dto.moduleId,
          dto.instituteId,
          dto.courseId ?? null,
        );
      }
      if (dto.sessionId) {
        await this.assertSessionValid(
          tx,
          dto.sessionId,
          dto.instituteId,
          dto.moduleId ?? null,
        );
      }
      if (dto.fileObjectId) {
        await this.assertFileObjectBelongsToInstitute(
          tx,
          dto.fileObjectId,
          dto.instituteId,
        );
      }
      if (dto.createdById) {
        await this.assertUserBelongsToInstitute(
          tx,
          dto.createdById,
          dto.instituteId,
        );
      }

      const resource = await tx.resource.create({
        data: {
          instituteId: dto.instituteId,
          courseId: dto.courseId ?? null,
          moduleId: dto.moduleId ?? null,
          sessionId: dto.sessionId ?? null,
          title: dto.title,
          type: dto.type,
          url: dto.url ?? null,
          fileObjectId: dto.fileObjectId ?? null,
          sizeBytes:
            dto.sizeBytes !== undefined && dto.sizeBytes !== null
              ? BigInt(dto.sizeBytes)
              : null,
          mimeType: dto.mimeType ?? null,
          description: dto.description ?? null,
          isDownloadable: dto.isDownloadable ?? undefined,
          orderIndex: dto.orderIndex ?? undefined,
          createdById: dto.createdById ?? null,
        },
      });

      this.logger.log(`Resource created: ${resource.id} (${resource.title})`);
      return resource;
    });
  }

  // --------------------------------------------------------------------------
  // READ — list with pagination/filters
  // --------------------------------------------------------------------------
  async findAll(
    query: ListResourcesQueryDto,
  ): Promise<
    PaginatedResult<Awaited<ReturnType<typeof this.prisma.resource.findFirst>>>
  > {
    const page = query.page ?? 1;
    const pageSize = query.pageSize ?? 20;
    const sortBy = query.sortBy ?? 'orderIndex';
    const sortOrder = query.sortOrder ?? 'asc';

    const where: Prisma.ResourceWhereInput = {
      ...(query.includeDeleted ? {} : { deletedAt: null }),
      ...(query.instituteId ? { instituteId: query.instituteId } : {}),
      ...(query.courseId ? { courseId: query.courseId } : {}),
      ...(query.moduleId ? { moduleId: query.moduleId } : {}),
      ...(query.sessionId ? { sessionId: query.sessionId } : {}),
      ...(query.createdById ? { createdById: query.createdById } : {}),
      ...(query.type ? { type: query.type } : {}),
      ...(query.isDownloadable !== undefined
        ? { isDownloadable: query.isDownloadable }
        : {}),
      ...(query.search
        ? {
            OR: [{ title: { contains: query.search, mode: 'insensitive' } }],
          }
        : {}),
    };

    const [total, data] = await this.prisma.$transaction([
      this.prisma.resource.count({ where }),
      this.prisma.resource.findMany({
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
    const resource = await this.prisma.resource.findFirst({
      where: {
        id,
        ...(opts.includeDeleted ? {} : { deletedAt: null }),
      },
    });
    if (!resource) {
      throw new NotFoundException(`Resource ${id} not found.`);
    }
    return resource;
  }

  // --------------------------------------------------------------------------
  // UPDATE
  // --------------------------------------------------------------------------
  async update(id: string, dto: UpdateResourceDto) {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.resource.findFirst({
        where: { id, deletedAt: null },
      });
      if (!existing) {
        throw new NotFoundException(`Resource ${id} not found.`);
      }

      const nextCourseId =
        dto.courseId !== undefined ? (dto.courseId ?? null) : existing.courseId;
      const nextModuleId =
        dto.moduleId !== undefined ? (dto.moduleId ?? null) : existing.moduleId;
      const nextSessionId =
        dto.sessionId !== undefined
          ? (dto.sessionId ?? null)
          : existing.sessionId;
      const nextFileObjectId =
        dto.fileObjectId !== undefined
          ? (dto.fileObjectId ?? null)
          : existing.fileObjectId;
      const nextCreatedById =
        dto.createdById !== undefined
          ? (dto.createdById ?? null)
          : existing.createdById;

      // Re-validate any references that changed.
      if (
        dto.courseId !== undefined &&
        nextCourseId &&
        nextCourseId !== existing.courseId
      ) {
        await this.assertCourseBelongsToInstitute(
          tx,
          nextCourseId,
          existing.instituteId,
        );
      }
      if (
        dto.moduleId !== undefined ||
        (dto.courseId !== undefined && nextModuleId)
      ) {
        if (nextModuleId) {
          await this.assertModuleValid(
            tx,
            nextModuleId,
            existing.instituteId,
            nextCourseId,
          );
        }
      }
      if (
        dto.sessionId !== undefined ||
        (dto.moduleId !== undefined && nextSessionId)
      ) {
        if (nextSessionId) {
          await this.assertSessionValid(
            tx,
            nextSessionId,
            existing.instituteId,
            nextModuleId,
          );
        }
      }
      if (
        dto.fileObjectId !== undefined &&
        nextFileObjectId &&
        nextFileObjectId !== existing.fileObjectId
      ) {
        await this.assertFileObjectBelongsToInstitute(
          tx,
          nextFileObjectId,
          existing.instituteId,
        );
      }
      if (
        dto.createdById !== undefined &&
        nextCreatedById &&
        nextCreatedById !== existing.createdById
      ) {
        await this.assertUserBelongsToInstitute(
          tx,
          nextCreatedById,
          existing.instituteId,
        );
      }

      return tx.resource.update({
        where: { id },
        data: {
          courseId:
            dto.courseId === undefined ? undefined : (dto.courseId ?? null),
          moduleId:
            dto.moduleId === undefined ? undefined : (dto.moduleId ?? null),
          sessionId:
            dto.sessionId === undefined ? undefined : (dto.sessionId ?? null),
          title: dto.title ?? undefined,
          type: dto.type ?? undefined,
          url: dto.url === undefined ? undefined : (dto.url ?? null),
          fileObjectId:
            dto.fileObjectId === undefined
              ? undefined
              : (dto.fileObjectId ?? null),
          sizeBytes:
            dto.sizeBytes === undefined
              ? undefined
              : dto.sizeBytes === null
                ? null
                : BigInt(dto.sizeBytes),
          mimeType:
            dto.mimeType === undefined ? undefined : (dto.mimeType ?? null),
          description:
            dto.description === undefined
              ? undefined
              : (dto.description ?? null),
          isDownloadable:
            dto.isDownloadable === undefined ? undefined : dto.isDownloadable,
          orderIndex: dto.orderIndex === undefined ? undefined : dto.orderIndex,
          createdById:
            dto.createdById === undefined
              ? undefined
              : (dto.createdById ?? null),
        },
      });
    });
  }

  // --------------------------------------------------------------------------
  // SOFT DELETE
  // --------------------------------------------------------------------------
  async remove(id: string) {
    const existing = await this.findOne(id);
    return this.prisma.resource.update({
      where: { id: existing.id },
      data: { deletedAt: new Date() },
    });
  }

  // --------------------------------------------------------------------------
  // RESTORE
  // --------------------------------------------------------------------------
  async restore(id: string) {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.resource.findFirst({ where: { id } });
      if (!existing) {
        throw new NotFoundException(`Resource ${id} not found.`);
      }
      if (!existing.deletedAt) return existing;

      // Re-validate references on restore.
      await this.assertInstituteExists(tx, existing.instituteId);
      if (existing.courseId) {
        await this.assertCourseBelongsToInstitute(
          tx,
          existing.courseId,
          existing.instituteId,
        );
      }
      if (existing.moduleId) {
        await this.assertModuleValid(
          tx,
          existing.moduleId,
          existing.instituteId,
          existing.courseId,
        );
      }
      if (existing.sessionId) {
        await this.assertSessionValid(
          tx,
          existing.sessionId,
          existing.instituteId,
          existing.moduleId,
        );
      }

      return tx.resource.update({
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

  private async assertModuleValid(
    tx: Prisma.TransactionClient,
    moduleId: string,
    instituteId: string,
    courseId: string | null,
  ) {
    const mod = await tx.courseModule.findFirst({
      where: { id: moduleId, deletedAt: null },
      select: { id: true, instituteId: true, courseId: true },
    });
    if (!mod) {
      throw new NotFoundException(`CourseModule ${moduleId} not found.`);
    }
    if (mod.instituteId !== instituteId) {
      throw new BadRequestException(
        `CourseModule ${moduleId} does not belong to institute ${instituteId}.`,
      );
    }
    if (courseId && mod.courseId !== courseId) {
      throw new BadRequestException(
        `CourseModule ${moduleId} does not belong to course ${courseId}.`,
      );
    }
  }

  private async assertSessionValid(
    tx: Prisma.TransactionClient,
    sessionId: string,
    instituteId: string,
    moduleId: string | null,
  ) {
    const session = await tx.lmsSession.findFirst({
      where: { id: sessionId, deletedAt: null },
      select: { id: true, instituteId: true, moduleId: true },
    });
    if (!session) {
      throw new NotFoundException(`LmsSession ${sessionId} not found.`);
    }
    if (session.instituteId !== instituteId) {
      throw new BadRequestException(
        `LmsSession ${sessionId} does not belong to institute ${instituteId}.`,
      );
    }
    if (moduleId && session.moduleId !== moduleId) {
      throw new BadRequestException(
        `LmsSession ${sessionId} does not belong to module ${moduleId}.`,
      );
    }
  }

  private async assertFileObjectBelongsToInstitute(
    tx: Prisma.TransactionClient,
    fileObjectId: string,
    instituteId: string,
  ) {
    const file = await tx.fileObject.findFirst({
      where: { id: fileObjectId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!file) {
      throw new NotFoundException(`FileObject ${fileObjectId} not found.`);
    }
    if (file.instituteId !== instituteId) {
      throw new BadRequestException(
        `FileObject ${fileObjectId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private async assertUserBelongsToInstitute(
    tx: Prisma.TransactionClient,
    userId: string,
    instituteId: string,
  ) {
    const user = await tx.user.findFirst({
      where: { id: userId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!user) {
      throw new NotFoundException(`User ${userId} not found.`);
    }
    if (user.instituteId !== instituteId) {
      throw new BadRequestException(
        `User ${userId} does not belong to institute ${instituteId}.`,
      );
    }
  }
}
