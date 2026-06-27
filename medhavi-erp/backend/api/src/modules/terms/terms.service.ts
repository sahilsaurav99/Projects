import {
  BadRequestException,
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { AuditAction, Prisma } from '@prisma/client';
import { PrismaService } from '../../infrastructure/prisma/prisma.service';
import { CreateTermDto } from './dto/create-term.dto';
import { ListTermsQueryDto } from './dto/list-terms.query';
import { UpdateTermDto } from './dto/update-term.dto';

// Re-exported for future audit-log re-integration (mirrors subjects.service).
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
 * TermsService
 *
 * CRUD + soft delete for the Term aggregate. Audit logging is intentionally
 * omitted in this revision (parity with subjects.service); AuditAction is
 * re-exported so a follow-up can re-wire AuditService without touching
 * controllers.
 *
 * Invariants enforced:
 *  - `instituteId` references a non-deleted Institute.
 *  - `academicYearId` references a non-deleted AcademicYear belonging to the
 *    same `instituteId`.
 *  - `code` is unique within an AcademicYear among non-deleted terms.
 *  - `sequence` is unique within an AcademicYear among non-deleted terms.
 *  - `startDate <= endDate`.
 */
@Injectable()
export class TermsService {
  private readonly logger = new Logger(TermsService.name);

  constructor(private readonly prisma: PrismaService) {}

  // --------------------------------------------------------------------------
  // CREATE
  // --------------------------------------------------------------------------
  async create(dto: CreateTermDto) {
    await this.assertInstituteExists(dto.instituteId);
    await this.assertAcademicYearBelongsToInstitute(
      dto.academicYearId,
      dto.instituteId,
    );
    this.assertDateRange(dto.startDate, dto.endDate);
    await this.assertCodeUnique(dto.academicYearId, dto.code);
    await this.assertSequenceUnique(dto.academicYearId, dto.sequence);

    try {
      const term = await this.prisma.term.create({
        data: {
          instituteId: dto.instituteId,
          academicYearId: dto.academicYearId,
          code: dto.code,
          name: dto.name,
          type: dto.type,
          sequence: dto.sequence,
          startDate: new Date(dto.startDate),
          endDate: new Date(dto.endDate),
          registrationStart: dto.registrationStart
            ? new Date(dto.registrationStart)
            : null,
          registrationEnd: dto.registrationEnd
            ? new Date(dto.registrationEnd)
            : null,
          classesStart: dto.classesStart ? new Date(dto.classesStart) : null,
          classesEnd: dto.classesEnd ? new Date(dto.classesEnd) : null,
          examsStart: dto.examsStart ? new Date(dto.examsStart) : null,
          examsEnd: dto.examsEnd ? new Date(dto.examsEnd) : null,
          resultsDate: dto.resultsDate ? new Date(dto.resultsDate) : null,
          status: dto.status ?? undefined,
          isCurrent: dto.isCurrent ?? undefined,
          metadata:
            dto.metadata === undefined
              ? undefined
              : (dto.metadata as Prisma.InputJsonValue),
        },
      });

      this.logger.log(`Term created: ${term.id} (${term.code})`);
      return term;
    } catch (err) {
      if (
        err instanceof Prisma.PrismaClientKnownRequestError &&
        err.code === 'P2002'
      ) {
        throw new ConflictException(
          `A term with the same code or sequence already exists in this academic year.`,
        );
      }
      throw err;
    }
  }

  // --------------------------------------------------------------------------
  // READ — list with pagination/filters
  // --------------------------------------------------------------------------
  async findAll(
    query: ListTermsQueryDto,
  ): Promise<
    PaginatedResult<Awaited<ReturnType<typeof this.prisma.term.findFirst>>>
  > {
    const page = query.page ?? 1;
    const pageSize = query.pageSize ?? 20;
    const sortBy = query.sortBy ?? 'sequence';
    const sortOrder = query.sortOrder ?? 'asc';

    const where: Prisma.TermWhereInput = {
      ...(query.includeDeleted ? {} : { deletedAt: null }),
      ...(query.instituteId ? { instituteId: query.instituteId } : {}),
      ...(query.academicYearId
        ? { academicYearId: query.academicYearId }
        : {}),
      ...(query.type ? { type: query.type } : {}),
      ...(query.status ? { status: query.status } : {}),
      ...(query.isCurrent !== undefined ? { isCurrent: query.isCurrent } : {}),
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
      this.prisma.term.count({ where }),
      this.prisma.term.findMany({
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
    const term = await this.prisma.term.findFirst({
      where: {
        id,
        ...(opts.includeDeleted ? {} : { deletedAt: null }),
      },
    });
    if (!term) throw new NotFoundException(`Term ${id} not found.`);
    return term;
  }

  // --------------------------------------------------------------------------
  // UPDATE
  // --------------------------------------------------------------------------
  async update(id: string, dto: UpdateTermDto) {
    const existing = await this.findOne(id);

    if (
      dto.academicYearId &&
      dto.academicYearId !== existing.academicYearId
    ) {
      await this.assertAcademicYearBelongsToInstitute(
        dto.academicYearId,
        existing.instituteId,
      );
    }

    const targetAcademicYearId = dto.academicYearId ?? existing.academicYearId;

    if (
      (dto.code && dto.code !== existing.code) ||
      (dto.academicYearId && dto.academicYearId !== existing.academicYearId)
    ) {
      await this.assertCodeUnique(
        targetAcademicYearId,
        dto.code ?? existing.code,
        id,
      );
    }

    if (
      (dto.sequence !== undefined && dto.sequence !== existing.sequence) ||
      (dto.academicYearId && dto.academicYearId !== existing.academicYearId)
    ) {
      await this.assertSequenceUnique(
        targetAcademicYearId,
        dto.sequence ?? existing.sequence,
        id,
      );
    }

    const nextStart = dto.startDate
      ? new Date(dto.startDate)
      : existing.startDate;
    const nextEnd = dto.endDate ? new Date(dto.endDate) : existing.endDate;
    if (dto.startDate || dto.endDate) {
      this.assertDateRange(nextStart, nextEnd);
    }

    try {
      return await this.prisma.term.update({
        where: { id },
        data: {
          academicYearId: dto.academicYearId ?? undefined,
          code: dto.code ?? undefined,
          name: dto.name ?? undefined,
          type: dto.type ?? undefined,
          sequence: dto.sequence ?? undefined,
          startDate: dto.startDate ? new Date(dto.startDate) : undefined,
          endDate: dto.endDate ? new Date(dto.endDate) : undefined,
          registrationStart:
            dto.registrationStart === undefined
              ? undefined
              : dto.registrationStart
                ? new Date(dto.registrationStart)
                : null,
          registrationEnd:
            dto.registrationEnd === undefined
              ? undefined
              : dto.registrationEnd
                ? new Date(dto.registrationEnd)
                : null,
          classesStart:
            dto.classesStart === undefined
              ? undefined
              : dto.classesStart
                ? new Date(dto.classesStart)
                : null,
          classesEnd:
            dto.classesEnd === undefined
              ? undefined
              : dto.classesEnd
                ? new Date(dto.classesEnd)
                : null,
          examsStart:
            dto.examsStart === undefined
              ? undefined
              : dto.examsStart
                ? new Date(dto.examsStart)
                : null,
          examsEnd:
            dto.examsEnd === undefined
              ? undefined
              : dto.examsEnd
                ? new Date(dto.examsEnd)
                : null,
          resultsDate:
            dto.resultsDate === undefined
              ? undefined
              : dto.resultsDate
                ? new Date(dto.resultsDate)
                : null,
          status: dto.status ?? undefined,
          isCurrent: dto.isCurrent ?? undefined,
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
          `A term with the same code or sequence already exists in this academic year.`,
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
    return this.prisma.term.update({
      where: { id: existing.id },
      data: {
        deletedAt: new Date(),
        isCurrent: false,
      },
    });
  }

  // --------------------------------------------------------------------------
  // RESTORE
  // --------------------------------------------------------------------------
  async restore(id: string) {
    const existing = await this.findOne(id, { includeDeleted: true });
    if (!existing.deletedAt) return existing;

    // Re-validate parent hierarchy and uniqueness on restore.
    await this.assertAcademicYearBelongsToInstitute(
      existing.academicYearId,
      existing.instituteId,
    );
    await this.assertCodeUnique(
      existing.academicYearId,
      existing.code,
      existing.id,
    );
    await this.assertSequenceUnique(
      existing.academicYearId,
      existing.sequence,
      existing.id,
    );

    return this.prisma.term.update({
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

  private async assertAcademicYearBelongsToInstitute(
    academicYearId: string,
    instituteId: string,
  ) {
    const ay = await this.prisma.academicYear.findFirst({
      where: { id: academicYearId, deletedAt: null },
      select: { id: true, instituteId: true },
    });
    if (!ay) {
      throw new NotFoundException(
        `AcademicYear ${academicYearId} not found.`,
      );
    }
    if (ay.instituteId !== instituteId) {
      throw new BadRequestException(
        `AcademicYear ${academicYearId} does not belong to institute ${instituteId}.`,
      );
    }
  }

  private assertDateRange(start: Date | string, end: Date | string) {
    const s = start instanceof Date ? start : new Date(start);
    const e = end instanceof Date ? end : new Date(end);
    if (s.getTime() > e.getTime()) {
      throw new BadRequestException('startDate must be on or before endDate.');
    }
  }

  private async assertCodeUnique(
    academicYearId: string,
    code: string,
    excludeId?: string,
  ) {
    const existing = await this.prisma.term.findFirst({
      where: {
        academicYearId,
        code,
        deletedAt: null,
        ...(excludeId ? { NOT: { id: excludeId } } : {}),
      },
      select: { id: true },
    });
    if (existing) {
      throw new ConflictException(
        `Term with code "${code}" already exists in this academic year.`,
      );
    }
  }

  private async assertSequenceUnique(
    academicYearId: string,
    sequence: number,
    excludeId?: string,
  ) {
    const existing = await this.prisma.term.findFirst({
      where: {
        academicYearId,
        sequence,
        deletedAt: null,
        ...(excludeId ? { NOT: { id: excludeId } } : {}),
      },
      select: { id: true },
    });
    if (existing) {
      throw new ConflictException(
        `Term with sequence ${sequence} already exists in this academic year.`,
      );
    }
  }
}
