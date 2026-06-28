import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { SectionStatus } from '@prisma/client';
import { Type } from 'class-transformer';
import {
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
 * CreateSectionDto
 *
 * Fields mirror the Prisma `Section` model exactly:
 *   instituteId, batchId, termId, code, name, capacity, enrolledCount?,
 *   classRepUserId?, classAdvisorFacultyId?, roomHint?, status?, metadata?
 *
 * Hierarchy (Batch and Term both belong to Institute) and uniqueness
 * invariants (code unique within `batchId` × `termId` among non-deleted
 * sections) are enforced in the service.
 */
export class CreateSectionDto {
  @ApiProperty({ description: 'Parent institute UUID.', format: 'uuid' })
  @IsUUID()
  instituteId!: string;

  @ApiProperty({ description: 'Owning batch UUID.', format: 'uuid' })
  @IsUUID()
  batchId!: string;

  @ApiProperty({ description: 'Owning term UUID.', format: 'uuid' })
  @IsUUID()
  termId!: string;

  @ApiProperty({
    description:
      'Section code (unique within batch × term among non-deleted sections).',
    minLength: 1,
    maxLength: 64,
    example: 'A',
  })
  @IsString()
  @Length(1, 64)
  @Matches(/^[A-Za-z0-9_\-\/.]+$/, {
    message:
      'code may only contain letters, digits, underscore, hyphen, slash, and dot.',
  })
  code!: string;

  @ApiProperty({ description: 'Section display name.', minLength: 1, maxLength: 200 })
  @IsString()
  @Length(1, 200)
  name!: string;

  @ApiProperty({
    description: 'Maximum seats in the section.',
    minimum: 1,
    example: 60,
  })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  capacity!: number;

  @ApiPropertyOptional({
    description: 'Currently enrolled student count (defaults to 0).',
    minimum: 0,
    default: 0,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(0)
  enrolledCount?: number;

  @ApiPropertyOptional({
    description: 'User UUID of the class representative (student).',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  classRepUserId?: string;

  @ApiPropertyOptional({
    description: 'Faculty UUID of the class advisor.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  classAdvisorFacultyId?: string;

  @ApiPropertyOptional({
    description: 'Free-text room hint (e.g. "Block C - 204").',
    maxLength: 200,
  })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  roomHint?: string;

  @ApiPropertyOptional({ enum: SectionStatus, default: SectionStatus.PLANNED })
  @IsOptional()
  @IsEnum(SectionStatus)
  status?: SectionStatus;

  @ApiPropertyOptional({
    description: 'Free-form metadata bag.',
    type: 'object',
    additionalProperties: true,
  })
  @IsOptional()
  @IsObject()
  metadata?: Record<string, unknown>;
}
