import { ApiPropertyOptional } from '@nestjs/swagger';
import { Prisma, SectionStatus } from '@prisma/client';
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
  'code',
  'name',
  'capacity',
  'enrolledCount',
] as const;
export type SectionSortField = (typeof SORTABLE_FIELDS)[number];

/**
 * ListSectionsQueryDto
 *
 * Mirrors ListTermsQueryDto: offset pagination, free-text `search` against
 * code/name, plus filters and sort controls.
 */
export class ListSectionsQueryDto {
  @ApiPropertyOptional({
    description: 'Filter by parent institute UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  instituteId?: string;

  @ApiPropertyOptional({
    description: 'Filter by owning batch UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  batchId?: string;

  @ApiPropertyOptional({
    description: 'Filter by owning term UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  termId?: string;

  @ApiPropertyOptional({ enum: SectionStatus })
  @IsOptional()
  @IsEnum(SectionStatus)
  status?: SectionStatus;

  @ApiPropertyOptional({
    description: 'Filter by class advisor faculty UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  classAdvisorFacultyId?: string;

  @ApiPropertyOptional({
    description: 'Case-insensitive substring match on code or name.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  search?: string;

  @ApiPropertyOptional({
    description: 'Include soft-deleted sections in the result set.',
    default: false,
  })
  @IsOptional()
  @Transform(({ value }) =>
    value === true || value === 'true'
      ? true
      : value === false || value === 'false'
        ? false
        : value,
  )
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

  @ApiPropertyOptional({ enum: SORTABLE_FIELDS, default: 'code' })
  @IsOptional()
  @IsIn(SORTABLE_FIELDS as unknown as string[])
  sortBy?: SectionSortField = 'code';

  @ApiPropertyOptional({ enum: ['asc', 'desc'], default: 'asc' })
  @IsOptional()
  @IsIn(['asc', 'desc'])
  sortOrder?: Prisma.SortOrder = 'asc';
}
