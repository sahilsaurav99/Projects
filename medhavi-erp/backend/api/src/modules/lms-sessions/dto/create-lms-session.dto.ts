import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { LmsSessionType } from '@prisma/client';
import {
  IsBoolean,
  IsDateString,
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  IsUrl,
  IsUUID,
  Length,
  Min,
} from 'class-validator';

/**
 * CreateLmsSessionDto
 *
 * Fields mirror the Prisma `LmsSession` model exactly:
 *   instituteId, moduleId, title, description?, type, orderIndex,
 *   durationMin?, scheduledAt?, meetingUrl?, recordingUrl?,
 *   contentMarkdown?, isMandatory?
 *
 * Hierarchy validation (module belongs to same institute) and uniqueness
 * invariants (`orderIndex` unique within module) are enforced in the service.
 */
export class CreateLmsSessionDto {
  @ApiProperty({ description: 'Parent institute UUID.', format: 'uuid' })
  @IsUUID()
  instituteId!: string;

  @ApiProperty({ description: 'Owning CourseModule UUID.', format: 'uuid' })
  @IsUUID()
  moduleId!: string;

  @ApiProperty({ description: 'Session title.', maxLength: 255 })
  @IsString()
  @Length(1, 255)
  title!: string;

  @ApiPropertyOptional({ description: 'Long-form session description.' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({ enum: LmsSessionType, description: 'Session delivery type.' })
  @IsEnum(LmsSessionType)
  type!: LmsSessionType;

  @ApiProperty({
    description:
      'Zero-based ordering index within the module. Unique within module among non-deleted sessions.',
    minimum: 0,
    example: 0,
  })
  @IsInt()
  @Min(0)
  orderIndex!: number;

  @ApiPropertyOptional({
    description: 'Planned duration in minutes.',
    minimum: 0,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  durationMin?: number;

  @ApiPropertyOptional({
    description: 'Scheduled start datetime (ISO-8601) for live sessions.',
  })
  @IsOptional()
  @IsDateString()
  scheduledAt?: string;

  @ApiPropertyOptional({
    description: 'URL for the live meeting (e.g. Zoom/Teams).',
  })
  @IsOptional()
  @IsUrl({ require_tld: false })
  meetingUrl?: string;

  @ApiPropertyOptional({
    description: 'URL for the post-session recording.',
  })
  @IsOptional()
  @IsUrl({ require_tld: false })
  recordingUrl?: string;

  @ApiPropertyOptional({
    description: 'Markdown-formatted textual content for the session.',
  })
  @IsOptional()
  @IsString()
  contentMarkdown?: string;

  @ApiPropertyOptional({
    description: 'Whether attendance/completion is mandatory.',
    default: true,
  })
  @IsOptional()
  @IsBoolean()
  isMandatory?: boolean;
}
