import {
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { AuditAction, OrgUnitStatus, Prisma } from '@prisma/client';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';
import { CreateCampusDto } from './dto/create-campus.dto';
import { ListCampusesQueryDto } from './dto/list-campuses.query';
import { UpdateCampusDto } from './dto/update-campus.dto';

// Re-exported for future audit-log re-integration (mirrors institutes.service).
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
 * CampusesService
 *
 * CRUD + soft delete for the Campus aggregate. Audit logging is intentionally
 * omitted in this revision (parity with institutes.service post-regeneration);
 * AuditAction is re-exported so a follow-up can re-wire AuditService without
 * touching controllers.
 */
@Injectable()
export class CampusesService {
  private readonly logger = new Logger(CampusesService.name);

  constructor(private readonly prisma: PrismaService) {}

  // --------------------------------------------------------------------------
  // CREATE
  // --------------------------------------------------------------------------
  async create(dto: CreateCampusDto) {
    await this.assertInstituteExists(dto.instituteId);
    await this.assertCodeUnique(dto.instituteId, dto.code);

    try {
      const campus = await this.prisma.$transaction(async (tx) => {
        // If this campus is being marked main, demote any existing main campus
        // in the same institute so the "one main per institute" invariant holds.
        if (dto.isMain) {
          await tx.campus.updateMany({
            where: { instituteId: dto.instituteId, isMain: true, deletedAt: null },
            data: { isMain: false },
          });
        }

        return tx.campus.create({
          data: {
            instituteId: dto.instituteId,
            code: dto.code,
            name: dto.name,
            isMain: dto.isMain ?? false,
            addressLine1: dto.addressLine1,
            addressLine2: dto.addressLine2,
            city: dto.city,
            state: dto.state,
            country: dto.country,
            postalCode: dto.postalCode,
            latitude: dto.latitude as unknown as Prisma.Decimal | undefined,
            longitude: dto.longitude as unknown as Prisma.Decimal | undefined,
            status: dto.status ?? OrgUnitStatus.ACTIVE,
            metadata: (dto.metadata ?? undefined) as Prisma.InputJsonValue | undefined,
          },
        });
      });

      this.logger.log(`Campus created: ${campus.id} (${campus.code})`);
      return campus;
    } catch (err) {
      if (
        err instanceof Prisma.PrismaClientKnownRequestError &&
        err.code === 'P2002'
      ) {
        throw new ConflictException(
          `Campus code "${dto.code}" already exists for this institute.`,
        );
      }
      throw err;
    }
  }

  // --------------------------------------------------------------------------
  // READ — list with pagination/filters
  // --------------------------------------------------------------------------
  async findAll(query: ListCampusesQueryDto): Promise<PaginatedResult<Awaited<ReturnType<typeof this.prisma.campus.findFirst>>>> {
    const page = query.page ?? 1;
    const pageSize = query.pageSize ?? 20;
    const sortBy = query.sortBy ?? 'createdAt';
    const sortOrder = query.sortOrder ?? 'desc';

    const where: Prisma.CampusWhereInput = {
      ...(query.includeDeleted ? {} : { deletedAt: null }),
      ...(query.instituteId ? { instituteId: query.instituteId } : {}),
      ...(query.status ? { status: query.status } : {}),
      ...(typeof query.isMain === 'boolean' ? { isMain: query.isMain } : {}),
      ...(query.search
        ? {
            OR: [
              { name: { contains: query.search, mode: 'insensitive' } },
              { code: { contains: query.search, mode: 'insensitive' } },
            ],
          }
        : {}),
    };

    const [total, data] = await this.prisma.$transaction([
      this.prisma.campus.count({ where }),
      this.prisma.campus.findMany({
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
    const campus = await this.prisma.campus.findFirst({
      where: {
        id,
        ...(opts.includeDeleted ? {} : { deletedAt: null }),
      },
    });
    if (!campus) throw new NotFoundException(`Campus ${id} not found.`);
    return campus;
  }

  // --------------------------------------------------------------------------
  // UPDATE
  // --------------------------------------------------------------------------
  async update(id: string, dto: UpdateCampusDto) {
    const existing = await this.findOne(id);

    if (dto.code && dto.code !== existing.code) {
      await this.assertCodeUnique(existing.instituteId, dto.code, id);
    }

    try {
      return await this.prisma.$transaction(async (tx) => {
        if (dto.isMain === true && !existing.isMain) {
          await tx.campus.updateMany({
            where: {
              instituteId: existing.instituteId,
              isMain: true,
              deletedAt: null,
              NOT: { id },
            },
            data: { isMain: false },
          });
        }

        return tx.campus.update({
          where: { id },
          data: {
            code: dto.code ?? undefined,
            name: dto.name ?? undefined,
            isMain: dto.isMain ?? undefined,
            addressLine1: dto.addressLine1 ?? undefined,
            addressLine2: dto.addressLine2 ?? undefined,
            city: dto.city ?? undefined,
            state: dto.state ?? undefined,
            country: dto.country ?? undefined,
            postalCode: dto.postalCode ?? undefined,
            latitude:
              dto.latitude === undefined
                ? undefined
                : (dto.latitude as unknown as Prisma.Decimal),
            longitude:
              dto.longitude === undefined
                ? undefined
                : (dto.longitude as unknown as Prisma.Decimal),
            status: dto.status ?? undefined,
            metadata:
              dto.metadata === undefined
                ? undefined
                : (dto.metadata as Prisma.InputJsonValue),
          },
        });
      });
    } catch (err) {
      if (
        err instanceof Prisma.PrismaClientKnownRequestError &&
        err.code === 'P2002'
      ) {
        throw new ConflictException(
          `Campus code "${dto.code}" already exists for this institute.`,
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
    return this.prisma.campus.update({
      where: { id: existing.id },
      data: {
        deletedAt: new Date(),
        status: OrgUnitStatus.ARCHIVED,
      },
    });
  }

  // --------------------------------------------------------------------------
  // RESTORE
  // --------------------------------------------------------------------------
  async restore(id: string) {
    const existing = await this.findOne(id, { includeDeleted: true });
    if (!existing.deletedAt) return existing;

    // Re-validate uniqueness because another campus may have taken the code
    // while this one was archived.
    await this.assertCodeUnique(existing.instituteId, existing.code, existing.id);

    return this.prisma.campus.update({
      where: { id: existing.id },
      data: {
        deletedAt: null,
        status: OrgUnitStatus.ACTIVE,
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

  private async assertCodeUnique(
    instituteId: string,
    code: string,
    ignoreId?: string,
  ) {
    const clash = await this.prisma.campus.findFirst({
      where: {
        instituteId,
        code,
        deletedAt: null,
        ...(ignoreId ? { NOT: { id: ignoreId } } : {}),
      },
      select: { id: true },
    });
    if (clash) {
      throw new ConflictException(
        `Campus code "${code}" already exists for this institute.`,
      );
    }
  }
}
