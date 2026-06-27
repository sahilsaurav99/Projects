import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { TermStatus, TermType } from '@prisma/client';
import { Type } from 'class-transformer';
import {
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
 * CreateTermDto
 *
 * Fields mirror the Prisma `Term` model exactly:
 *   instituteId, academicYearId, code, name, type, sequence, startDate,
 *   endDate, registrationStart?, registrationEnd?, classesStart?, classesEnd?,
 *   examsStart?, examsEnd?, resultsDate?, status?, isCurrent?, metadata?
 *
 * Hierarchy (AcademicYear belongs to Institute) and uniqueness invariants
 * (code unique within AcademicYear, sequence unique within AcademicYear,
 * among non-deleted terms) are enforced in the service.
 */
export class CreateTermDto {
  @ApiProperty({ description: 'Parent institute UUID.', format: 'uuid' })
  @IsUUID()
  instituteId!: string;

  @ApiProperty({ description: 'Owning academic year UUID.', format: 'uuid' })
  @IsUUID()
  academicYearId!: string;

  @ApiProperty({
    description:
      'AcademicYear-scoped term code (unique within an academic year among non-deleted terms).',
    minLength: 1,
    maxLength: 64,
    example: 'AY-2025-26-SEM1',
  })
  @IsString()
  @Length(1, 64)
  @Matches(/^[A-Za-z0-9_\-\/.]+$/, {
    message:
      'code may only contain letters, digits, underscore, hyphen, slash, and dot.',
  })
  code!: string;

  @ApiProperty({ description: 'Term name.', minLength: 1, maxLength: 200 })
  @IsString()
  @Length(1, 200)
  name!: string;

  @ApiProperty({ enum: TermType, description: 'Term type.' })
  @IsEnum(TermType)
  type!: TermType;

  @ApiProperty({
    description: 'Sequence number within the academic year (1..N).',
    minimum: 1,
    example: 1,
  })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  sequence!: number;

  @ApiProperty({
    description: 'Term start date.',
    format: 'date',
    example: '2025-07-01',
  })
  @IsDateString()
  startDate!: string;

  @ApiProperty({
    description: 'Term end date (inclusive).',
    format: 'date',
    example: '2025-12-15',
  })
  @IsDateString()
  endDate!: string;

  @ApiPropertyOptional({
    description: 'Registration window start (timestamp).',
    format: 'date-time',
  })
  @IsOptional()
  @IsDateString()
  registrationStart?: string;

  @ApiPropertyOptional({
    description: 'Registration window end (timestamp).',
    format: 'date-time',
  })
  @IsOptional()
  @IsDateString()
  registrationEnd?: string;

  @ApiPropertyOptional({ description: 'Classes start date.', format: 'date' })
  @IsOptional()
  @IsDateString()
  classesStart?: string;

  @ApiPropertyOptional({ description: 'Classes end date.', format: 'date' })
  @IsOptional()
  @IsDateString()
  classesEnd?: string;

  @ApiPropertyOptional({ description: 'Exams start date.', format: 'date' })
  @IsOptional()
  @IsDateString()
  examsStart?: string;

  @ApiPropertyOptional({ description: 'Exams end date.', format: 'date' })
  @IsOptional()
  @IsDateString()
  examsEnd?: string;

  @ApiPropertyOptional({
    description: 'Date results are published.',
    format: 'date',
  })
  @IsOptional()
  @IsDateString()
  resultsDate?: string;

  @ApiPropertyOptional({ enum: TermStatus, default: TermStatus.PLANNED })
  @IsOptional()
  @IsEnum(TermStatus)
  status?: TermStatus;

  @ApiPropertyOptional({
    description: 'Marks this term as the active/current one.',
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  isCurrent?: boolean;

  @ApiPropertyOptional({
    description: 'Free-form metadata bag.',
    type: 'object',
    additionalProperties: true,
  })
  @IsOptional()
  @IsObject()
  metadata?: Record<string, unknown>;

  // MaxLength imported but unused-guarded: keep available for future fields.
  /** @internal */
  
}
