import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ResourceType } from '@prisma/client';
import {
  IsBoolean,
  IsEnum,
  IsInt,
  IsNumberString,
  IsOptional,
  IsString,
  IsUrl,
  IsUUID,
  Length,
  MaxLength,
  Min,
} from 'class-validator';

/**
 * CreateResourceDto
 *
 * Fields mirror the Prisma `Resource` model exactly:
 *   instituteId, courseId?, moduleId?, sessionId?, title, type,
 *   url?, fileObjectId?, sizeBytes?, mimeType?, description?,
 *   isDownloadable?, orderIndex?, createdById?
 *
 * Hierarchy validation (course/module/session belong to same institute,
 * module belongs to course, session belongs to module) and existence
 * checks for fileObjectId / createdById are enforced in the service.
 *
 * `sizeBytes` is BigInt in Prisma — accepted as a numeric string to
 * preserve precision across the wire and coerced server-side.
 */
export class CreateResourceDto {
  @ApiProperty({ description: 'Parent institute UUID.', format: 'uuid' })
  @IsUUID()
  instituteId!: string;

  @ApiPropertyOptional({
    description: 'Optional owning Course UUID.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  courseId?: string;

  @ApiPropertyOptional({
    description:
      'Optional owning CourseModule UUID. When provided together with courseId, the module must belong to that course.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  moduleId?: string;

  @ApiPropertyOptional({
    description:
      'Optional owning LmsSession UUID. When provided together with moduleId, the session must belong to that module.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  sessionId?: string;

  @ApiProperty({ description: 'Resource title.', maxLength: 255 })
  @IsString()
  @Length(1, 255)
  title!: string;

  @ApiProperty({ enum: ResourceType, description: 'Resource type.' })
  @IsEnum(ResourceType)
  type!: ResourceType;

  @ApiPropertyOptional({
    description:
      'External URL for LINK-type resources or hosted media. Mutually informative with fileObjectId.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(2048)
  @IsUrl({ require_protocol: true })
  url?: string;

  @ApiPropertyOptional({
    description: 'Optional FileObject UUID backing this resource.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  fileObjectId?: string;

  @ApiPropertyOptional({
    description:
      'Size of the underlying asset in bytes (BigInt). Provide as a numeric string to preserve precision.',
    example: '10485760',
  })
  @IsOptional()
  @IsNumberString({ no_symbols: true })
  sizeBytes?: string;

  @ApiPropertyOptional({
    description: 'MIME type of the underlying asset.',
    example: 'application/pdf',
  })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  mimeType?: string;

  @ApiPropertyOptional({ description: 'Long-form resource description.' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({
    description: 'Whether the resource may be downloaded by learners.',
    default: true,
  })
  @IsOptional()
  @IsBoolean()
  isDownloadable?: boolean;

  @ApiPropertyOptional({
    description:
      'Zero-based ordering index within the parent context (course/module/session).',
    minimum: 0,
    default: 0,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  orderIndex?: number;

  @ApiPropertyOptional({
    description: 'Optional UUID of the User who created this resource.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  createdById?: string;
}
