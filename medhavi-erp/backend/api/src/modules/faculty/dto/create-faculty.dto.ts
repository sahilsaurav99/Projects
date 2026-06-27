import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  EmploymentType,
  FacultyDesignation,
  FacultyStatus,
} from '@prisma/client';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsDateString,
  IsEnum,
  IsInt,
  IsObject,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Matches,
  MaxLength,
  Min,
} from 'class-validator';

/**
 * CreateFacultyDto
 *
 * Fields mirror the Prisma `Faculty` model exactly:
 *   instituteId, userId, campusId?, schoolId, departmentId, employeeCode,
 *   designation, employmentType?, joinDate, confirmationDate?, exitDate?,
 *   qualifications?, specializations?, researchAreas?, officeRoom?,
 *   officeHours?, weeklyLoadHours?, maxWeeklyLoadHours?, reportsToFacultyId?,
 *   isHod?, isMentor?, isAdvisor?, status?, biography?, profilePhotoFileId?,
 *   metadata?
 *
 * Hierarchy invariants (Campus/School/Department belong to Institute, and
 * Department belongs to School & — if provided — Campus) are enforced in the
 * service. `employeeCode` is unique per institute among non-deleted faculty.
 */
export class CreateFacultyDto {
  @ApiProperty({ description: 'Parent institute UUID.', format: 'uuid' })
  @IsUUID()
  instituteId!: string;

  @ApiProperty({
    description: 'Linked auth User UUID. Must be globally unique among faculty.',
    format: 'uuid',
  })
  @IsUUID()
  userId!: string;

  @ApiPropertyOptional({
    description: 'Parent campus UUID (optional).',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  campusId?: string;

  @ApiProperty({ description: 'Parent school UUID.', format: 'uuid' })
  @IsUUID()
  schoolId!: string;

  @ApiProperty({ description: 'Parent department UUID.', format: 'uuid' })
  @IsUUID()
  departmentId!: string;

  @ApiProperty({
    description:
      'Institute-issued employee code (unique within an institute among non-deleted faculty).',
    minLength: 1,
    maxLength: 64,
    example: 'MEDH-FAC-0001',
  })
  @IsString()
  @Length(1, 64)
  @Matches(/^[A-Za-z0-9_\-\/]+$/, {
    message:
      'employeeCode may only contain letters, digits, underscore, hyphen, and slash.',
  })
  employeeCode!: string;

  @ApiProperty({ enum: FacultyDesignation })
  @IsEnum(FacultyDesignation)
  designation!: FacultyDesignation;

  @ApiPropertyOptional({ enum: EmploymentType, default: EmploymentType.PERMANENT })
  @IsOptional()
  @IsEnum(EmploymentType)
  employmentType?: EmploymentType;

  @ApiProperty({
    description: 'Date of joining (ISO-8601 date).',
    format: 'date',
    example: '2025-07-15',
  })
  @IsDateString()
  joinDate!: string;

  @ApiPropertyOptional({ description: 'Confirmation date.', format: 'date' })
  @IsOptional()
  @IsDateString()
  confirmationDate?: string;

  @ApiPropertyOptional({ description: 'Exit date.', format: 'date' })
  @IsOptional()
  @IsDateString()
  exitDate?: string;

  @ApiPropertyOptional({
    description: 'Qualifications as a JSON structure.',
    type: 'object',
    additionalProperties: true,
  })
  @IsOptional()
  @IsObject()
  qualifications?: Record<string, unknown>;

  @ApiPropertyOptional({
    description: 'Areas of specialization.',
    type: [String],
    maxItems: 32,
  })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(32)
  @IsString({ each: true })
  @MaxLength(120, { each: true })
  specializations?: string[];

  @ApiPropertyOptional({
    description: 'Research areas.',
    type: [String],
    maxItems: 32,
  })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(32)
  @IsString({ each: true })
  @MaxLength(120, { each: true })
  researchAreas?: string[];

  @ApiPropertyOptional({ description: 'Office room identifier.', maxLength: 64 })
  @IsOptional()
  @IsString()
  @MaxLength(64)
  officeRoom?: string;

  @ApiPropertyOptional({
    description: 'Office hours as a JSON structure.',
    type: 'object',
    additionalProperties: true,
  })
  @IsOptional()
  @IsObject()
  officeHours?: Record<string, unknown>;

  @ApiPropertyOptional({ description: 'Current weekly teaching load (hours).', minimum: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  weeklyLoadHours?: number;

  @ApiPropertyOptional({ description: 'Maximum allowed weekly load (hours).', minimum: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  maxWeeklyLoadHours?: number;

  @ApiPropertyOptional({
    description: 'Reporting manager (another faculty in the same institute).',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  reportsToFacultyId?: string;

  @ApiPropertyOptional({ description: 'Head-of-Department flag.', default: false })
  @IsOptional()
  @IsBoolean()
  isHod?: boolean;

  @ApiPropertyOptional({ description: 'Mentor add-on flag.', default: false })
  @IsOptional()
  @IsBoolean()
  isMentor?: boolean;

  @ApiPropertyOptional({ description: 'Student-advisor flag.', default: false })
  @IsOptional()
  @IsBoolean()
  isAdvisor?: boolean;

  @ApiPropertyOptional({ enum: FacultyStatus, default: FacultyStatus.ACTIVE })
  @IsOptional()
  @IsEnum(FacultyStatus)
  status?: FacultyStatus;

  @ApiPropertyOptional({ description: 'Short biography / profile blurb.' })
  @IsOptional()
  @IsString()
  @MaxLength(4000)
  biography?: string;

  @ApiPropertyOptional({
    description: 'FileObject UUID for the profile photo.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  profilePhotoFileId?: string;

  @ApiPropertyOptional({
    description: 'Free-form metadata bag.',
    type: 'object',
    additionalProperties: true,
  })
  @IsOptional()
  @IsObject()
  metadata?: Record<string, unknown>;
}
