import { ApiPropertyOptional } from '@nestjs/swagger';
import { LmsSessionType, Prisma } from '@prisma/client';
import { Transform, Type } from 'class-transformer';
import {
  IsBoolean,
  IsEnum,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
} from 'class-validator';

const SORTABLE_FIELDS = [
  'createdAt',
  'updatedAt',
  'title',
  'orderIndex',
  'type',
  'scheduledAt',
  'durationMin',
  'isMandatory',
] as const;
export type LmsSessionSortField = (typeof SORTABLE_FIELDS)[number];

const toBoolean = ({ value }: { value: unknown }) =>
  value === true || value === 'true'
    ? true
    : value === false || value === 'false'
      ? false
      : value;

/**
 * ListLmsSessionsQueryDto
 *
 * Mirrors ListCourseModulesQueryDto: offset pagination, free-text `search`
 * across title/description, plus filters and sort controls.
 */
export class ListLmsSessionsQueryDto {
  @ApiPropertyOptional({
    description: 'Filter by parent institute UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  instituteId?: string;

  @ApiPropertyOptional({
    description: 'Filter by owning CourseModule UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  moduleId?: string;

  @ApiPropertyOptional({ enum: LmsSessionType })
  @IsOptional()
  @IsEnum(LmsSessionType)
  type?: LmsSessionType;

  @ApiPropertyOptional({ description: 'Filter by mandatory flag.' })
  @IsOptional()
  @Transform(toBoolean)
  @IsBoolean()
  isMandatory?: boolean;

  @ApiPropertyOptional({
    description: 'Case-insensitive substring match on title/description.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  search?: string;

  @ApiPropertyOptional({
    description: 'Include soft-deleted sessions in the result set.',
    default: false,
  })
  @IsOptional()
  @Transform(toBoolean)
  @IsBoolean()
  includeDeleted?: boolean;

  @ApiPropertyOptional({ minimum: 1, default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ minimum: 1, maximum: 100, default: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  pageSize?: number = 20;

  @ApiPropertyOptional({ enum: SORTABLE_FIELDS, default: 'orderIndex' })
  @IsOptional()
  @IsIn(SORTABLE_FIELDS as unknown as string[])
  sortBy?: LmsSessionSortField = 'orderIndex';

  @ApiPropertyOptional({ enum: ['asc', 'desc'], default: 'asc' })
  @IsOptional()
  @IsIn(['asc', 'desc'])
  sortOrder?: Prisma.SortOrder = 'asc';
}
