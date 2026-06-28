import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CourseStatus } from '@prisma/client';
import {
  IsBoolean,
  IsDateString,
  IsEnum,
  IsNumberString,
  IsObject,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Matches,
  MaxLength,
} from 'class-validator';

/**
 * CreateCourseDto
 *
 * Fields mirror the Prisma `Course` model exactly:
 *   instituteId, subjectOfferingId?, termId?, ownerFacultyId,
 *   code, title, description?, coverImageUrl?, status?, isSelfPaced?,
 *   startsAt?, endsAt?, syllabusUrl?, estimatedHours?, metadata?
 *
 * Hierarchy validation (ownerFaculty/subjectOffering/term belong to the
 * same institute) and uniqueness invariants (`code` unique within institute)
 * are enforced in the service.
 */
export class CreateCourseDto {
  @ApiProperty({ description: 'Parent institute UUID.', format: 'uuid' })
  @IsUUID()
  instituteId!: string;

  @ApiPropertyOptional({
    description: 'Optional SubjectOffering UUID this course backs.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  subjectOfferingId?: string;

  @ApiPropertyOptional({
    description: 'Optional Term UUID this course is scheduled in.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  termId?: string;

  @ApiProperty({
    description: 'Owning Faculty UUID (course owner / lead instructor).',
    format: 'uuid',
  })
  @IsUUID()
  ownerFacultyId!: string;

  @ApiProperty({
    description: 'Course code (unique within the institute among non-deleted courses).',
    minLength: 1,
    maxLength: 64,
    example: 'CS-201-2026',
  })
  @IsString()
  @Length(1, 64)
  @Matches(/^[A-Za-z0-9_\-\/.]+$/, {
    message:
      'code may only contain letters, digits, underscore, hyphen, slash, and dot.',
  })
  code!: string;

  @ApiProperty({ description: 'Human-readable course title.', maxLength: 255 })
  @IsString()
  @Length(1, 255)
  title!: string;

  @ApiPropertyOptional({ description: 'Long-form course description.' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({
    description: 'Cover image URL for the course catalogue/listing.',
    maxLength: 2048,
  })
  @IsOptional()
  @IsString()
  @MaxLength(2048)
  coverImageUrl?: string;

  @ApiPropertyOptional({ enum: CourseStatus, default: CourseStatus.DRAFT })
  @IsOptional()
  @IsEnum(CourseStatus)
  status?: CourseStatus;

  @ApiPropertyOptional({
    description: 'Whether the course is self-paced (no fixed schedule).',
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  isSelfPaced?: boolean;

  @ApiPropertyOptional({ description: 'Course start datetime (ISO-8601).' })
  @IsOptional()
  @IsDateString()
  startsAt?: string;

  @ApiPropertyOptional({ description: 'Course end datetime (ISO-8601).' })
  @IsOptional()
  @IsDateString()
  endsAt?: string;

  @ApiPropertyOptional({
    description: 'Syllabus URL (public or signed link).',
    maxLength: 2048,
  })
  @IsOptional()
  @IsString()
  @MaxLength(2048)
  syllabusUrl?: string;

  @ApiPropertyOptional({
    description:
      'Estimated effort in hours (Decimal(6,2)) — accepted as a numeric string.',
    example: '40.00',
  })
  @IsOptional()
  @IsNumberString()
  estimatedHours?: string;

  @ApiPropertyOptional({
    description: 'Free-form metadata bag.',
    type: 'object',
    additionalProperties: true,
  })
  @IsOptional()
  @IsObject()
  metadata?: Record<string, unknown>;
}
