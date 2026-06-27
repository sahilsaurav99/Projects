import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  AssessmentScheme,
  GradingScheme,
  Prisma,
  SubjectType,
} from '@prisma/client';
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
  'termSequence',
  'effectiveFrom',
] as const;
export type SubjectSortField = (typeof SORTABLE_FIELDS)[number];

/**
 * ListSubjectsQueryDto
 *
 * Mirrors ListFacultyQueryDto: offset pagination, free-text `search` against
 * code/name/shortName, plus filters and sort controls.
 */
export class ListSubjectsQueryDto {
  @ApiPropertyOptional({
    description: 'Filter by parent institute UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  instituteId?: string;

  @ApiPropertyOptional({
    description: 'Filter by owning department UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  departmentId?: string;

  @ApiPropertyOptional({
    description: 'Filter by associated program UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  programId?: string;

  @ApiPropertyOptional({ enum: SubjectType })
  @IsOptional()
  @IsEnum(SubjectType)
  type?: SubjectType;

  @ApiPropertyOptional({ enum: AssessmentScheme })
  @IsOptional()
  @IsEnum(AssessmentScheme)
  assessmentScheme?: AssessmentScheme;

  @ApiPropertyOptional({ enum: GradingScheme })
  @IsOptional()
  @IsEnum(GradingScheme)
  gradingScheme?: GradingScheme;

  @ApiPropertyOptional({ description: 'Filter by intended term/semester.', minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  termSequence?: number;

  @ApiPropertyOptional({ description: 'Filter by active flag.' })
  @IsOptional()
  @Transform(({ value }) =>
    value === true || value === 'true'
      ? true
      : value === false || value === 'false'
        ? false
        : value,
  )
  @IsBoolean()
  isActive?: boolean;

  @ApiPropertyOptional({
    description:
      'Case-insensitive substring match on code, name, or shortName.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  search?: string;

  @ApiPropertyOptional({
    description: 'Include soft-deleted subjects in the result set.',
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

  @ApiPropertyOptional({ enum: SORTABLE_FIELDS, default: 'createdAt' })
  @IsOptional()
  @IsIn(SORTABLE_FIELDS as unknown as string[])
  sortBy?: SubjectSortField = 'createdAt';

  @ApiPropertyOptional({ enum: ['asc', 'desc'], default: 'desc' })
  @IsOptional()
  @IsIn(['asc', 'desc'])
  sortOrder?: Prisma.SortOrder = 'desc';
}
