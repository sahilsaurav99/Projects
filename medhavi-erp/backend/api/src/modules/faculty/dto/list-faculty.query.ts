import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  EmploymentType,
  FacultyDesignation,
  FacultyStatus,
  Prisma,
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
  'employeeCode',
  'designation',
  'joinDate',
] as const;
export type FacultySortField = (typeof SORTABLE_FIELDS)[number];

/**
 * ListFacultyQueryDto
 *
 * Mirrors ListStudentsQueryDto: offset pagination, free-text `search` against
 * employeeCode/officeRoom, plus filters and sort controls.
 */
export class ListFacultyQueryDto {
  @ApiPropertyOptional({
    description: 'Filter by parent institute UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  instituteId?: string;

  @ApiPropertyOptional({
    description: 'Filter by parent campus UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  campusId?: string;

  @ApiPropertyOptional({
    description: 'Filter by parent school UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  schoolId?: string;

  @ApiPropertyOptional({
    description: 'Filter by parent department UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  departmentId?: string;

  @ApiPropertyOptional({
    description: 'Filter by linked auth User UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  userId?: string;

  @ApiPropertyOptional({
    description: 'Filter by reporting manager Faculty UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  reportsToFacultyId?: string;

  @ApiPropertyOptional({ enum: FacultyDesignation })
  @IsOptional()
  @IsEnum(FacultyDesignation)
  designation?: FacultyDesignation;

  @ApiPropertyOptional({ enum: EmploymentType })
  @IsOptional()
  @IsEnum(EmploymentType)
  employmentType?: EmploymentType;

  @ApiPropertyOptional({ enum: FacultyStatus })
  @IsOptional()
  @IsEnum(FacultyStatus)
  status?: FacultyStatus;

  @ApiPropertyOptional({ description: 'Filter by HoD flag.' })
  @IsOptional()
  @Transform(({ value }) =>
    value === true || value === 'true'
      ? true
      : value === false || value === 'false'
        ? false
        : value,
  )
  @IsBoolean()
  isHod?: boolean;

  @ApiPropertyOptional({ description: 'Filter by Mentor add-on flag.' })
  @IsOptional()
  @Transform(({ value }) =>
    value === true || value === 'true'
      ? true
      : value === false || value === 'false'
        ? false
        : value,
  )
  @IsBoolean()
  isMentor?: boolean;

  @ApiPropertyOptional({ description: 'Filter by Advisor flag.' })
  @IsOptional()
  @Transform(({ value }) =>
    value === true || value === 'true'
      ? true
      : value === false || value === 'false'
        ? false
        : value,
  )
  @IsBoolean()
  isAdvisor?: boolean;

  @ApiPropertyOptional({
    description: 'Case-insensitive substring match on employeeCode or officeRoom.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(120)
  search?: string;

  @ApiPropertyOptional({
    description: 'Include soft-deleted faculty in the result set.',
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
  sortBy?: FacultySortField = 'createdAt';

  @ApiPropertyOptional({ enum: ['asc', 'desc'], default: 'desc' })
  @IsOptional()
  @IsIn(['asc', 'desc'])
  sortOrder?: Prisma.SortOrder = 'desc';
}
