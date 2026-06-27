import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  AssessmentScheme,
  GradingScheme,
  SubjectType,
} from '@prisma/client';
import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsDateString,
  IsEnum,
  IsInt,
  IsNumberString,
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
 * CreateSubjectDto
 *
 * Fields mirror the Prisma `Subject` model exactly:
 *   instituteId, departmentId, programId?, code, name, shortName?, type,
 *   termSequence?, credits, lectureHours, tutorialHours, practicalHours,
 *   contactHoursWeek?, assessmentScheme, gradingScheme, maxMarks, passMarks,
 *   internalWeight, externalWeight, syllabusFileId?, description?, outcomes?,
 *   effectiveFrom, effectiveTo?, isActive?, metadata?
 *
 * Hierarchy invariants (Department/Program belong to Institute) and `code`
 * uniqueness per institute (among non-deleted subjects) are enforced in the
 * service.
 */
export class CreateSubjectDto {
  @ApiProperty({ description: 'Parent institute UUID.', format: 'uuid' })
  @IsUUID()
  instituteId!: string;

  @ApiProperty({ description: 'Owning department UUID.', format: 'uuid' })
  @IsUUID()
  departmentId!: string;

  @ApiPropertyOptional({
    description: 'Associated program UUID (optional).',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  programId?: string;

  @ApiProperty({
    description:
      'Institute-scoped subject code (unique within an institute among non-deleted subjects).',
    minLength: 1,
    maxLength: 32,
    example: 'CS201',
  })
  @IsString()
  @Length(1, 32)
  @Matches(/^[A-Za-z0-9_\-\/.]+$/, {
    message:
      'code may only contain letters, digits, underscore, hyphen, slash, and dot.',
  })
  code!: string;

  @ApiProperty({ description: 'Subject name.', minLength: 1, maxLength: 200 })
  @IsString()
  @Length(1, 200)
  name!: string;

  @ApiPropertyOptional({ description: 'Short / abbreviated name.', maxLength: 64 })
  @IsOptional()
  @IsString()
  @MaxLength(64)
  shortName?: string;

  @ApiPropertyOptional({ enum: SubjectType, default: SubjectType.CORE })
  @IsOptional()
  @IsEnum(SubjectType)
  type?: SubjectType;

  @ApiPropertyOptional({
    description: 'Intended semester / term sequence number.',
    minimum: 1,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  termSequence?: number;

  @ApiProperty({
    description: 'Credit value (Decimal(4,2), passed as a numeric string).',
    example: '4.00',
  })
  @IsNumberString(
    { no_symbols: false },
    { message: 'credits must be a decimal number string, e.g. "4.00".' },
  )
  credits!: string;

  @ApiPropertyOptional({ description: 'Lecture hours per week.', minimum: 0, default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  lectureHours?: number;

  @ApiPropertyOptional({ description: 'Tutorial hours per week.', minimum: 0, default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  tutorialHours?: number;

  @ApiPropertyOptional({ description: 'Practical hours per week.', minimum: 0, default: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  practicalHours?: number;

  @ApiPropertyOptional({ description: 'Total contact hours per week.', minimum: 0 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  contactHoursWeek?: number;

  @ApiPropertyOptional({
    enum: AssessmentScheme,
    default: AssessmentScheme.THEORY,
  })
  @IsOptional()
  @IsEnum(AssessmentScheme)
  assessmentScheme?: AssessmentScheme;

  @ApiPropertyOptional({
    enum: GradingScheme,
    default: GradingScheme.CGPA_10,
  })
  @IsOptional()
  @IsEnum(GradingScheme)
  gradingScheme?: GradingScheme;

  @ApiPropertyOptional({ description: 'Maximum marks.', minimum: 0, default: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  maxMarks?: number;

  @ApiPropertyOptional({ description: 'Pass marks.', minimum: 0, default: 40 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  passMarks?: number;

  @ApiPropertyOptional({ description: 'Internal weight (%).', minimum: 0, default: 40 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  internalWeight?: number;

  @ApiPropertyOptional({ description: 'External weight (%).', minimum: 0, default: 60 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  externalWeight?: number;

  @ApiPropertyOptional({
    description: 'FileObject UUID for the syllabus document.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  syllabusFileId?: string;

  @ApiPropertyOptional({ description: 'Long description / overview.' })
  @IsOptional()
  @IsString()
  @MaxLength(8000)
  description?: string;

  @ApiPropertyOptional({
    description: 'Course outcomes as a JSON structure.',
    type: 'object',
    additionalProperties: true,
  })
  @IsOptional()
  @IsObject()
  outcomes?: Record<string, unknown>;

  @ApiProperty({
    description: 'Date this subject definition becomes effective.',
    format: 'date',
    example: '2025-07-01',
  })
  @IsDateString()
  effectiveFrom!: string;

  @ApiPropertyOptional({
    description: 'Date this subject definition stops being effective.',
    format: 'date',
  })
  @IsOptional()
  @IsDateString()
  effectiveTo?: string;

  @ApiPropertyOptional({ description: 'Active flag.', default: true })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @ApiPropertyOptional({
    description: 'Free-form metadata bag.',
    type: 'object',
    additionalProperties: true,
  })
  @IsOptional()
  @IsObject()
  metadata?: Record<string, unknown>;
}
