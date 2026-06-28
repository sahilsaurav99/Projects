import { ApiPropertyOptional } from '@nestjs/swagger';
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
 * UpdateResourceDto
 *
 * Partial update of a Resource. `instituteId` is intentionally immutable
 * (mirrors courses / course-modules conventions) and is not exposed here;
 * tenancy moves require a delete + recreate.
 *
 * `courseId`, `moduleId`, `sessionId`, `fileObjectId`, `createdById`,
 * `url`, `mimeType`, `sizeBytes`, `description` accept `null` semantics via
 * explicit empty-string / null handling in the service.
 */
export class UpdateResourceDto {
  @ApiPropertyOptional({
    description: 'Owning Course UUID (or null to detach).',
    format: 'uuid',
    nullable: true,
  })
  @IsOptional()
  @IsUUID()
  courseId?: string | null;

  @ApiPropertyOptional({
    description: 'Owning CourseModule UUID (or null to detach).',
    format: 'uuid',
    nullable: true,
  })
  @IsOptional()
  @IsUUID()
  moduleId?: string | null;

  @ApiPropertyOptional({
    description: 'Owning LmsSession UUID (or null to detach).',
    format: 'uuid',
    nullable: true,
  })
  @IsOptional()
  @IsUUID()
  sessionId?: string | null;

  @ApiPropertyOptional({ description: 'Resource title.', maxLength: 255 })
  @IsOptional()
  @IsString()
  @Length(1, 255)
  title?: string;

  @ApiPropertyOptional({ enum: ResourceType })
  @IsOptional()
  @IsEnum(ResourceType)
  type?: ResourceType;

  @ApiPropertyOptional({ description: 'External URL.', nullable: true })
  @IsOptional()
  @IsString()
  @MaxLength(2048)
  @IsUrl({ require_protocol: true })
  url?: string | null;

  @ApiPropertyOptional({
    description: 'Backing FileObject UUID (or null to detach).',
    format: 'uuid',
    nullable: true,
  })
  @IsOptional()
  @IsUUID()
  fileObjectId?: string | null;

  @ApiPropertyOptional({
    description: 'Size in bytes (BigInt-as-string).',
    nullable: true,
  })
  @IsOptional()
  @IsNumberString({ no_symbols: true })
  sizeBytes?: string | null;

  @ApiPropertyOptional({ description: 'MIME type.', nullable: true })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  mimeType?: string | null;

  @ApiPropertyOptional({ description: 'Description.', nullable: true })
  @IsOptional()
  @IsString()
  description?: string | null;

  @ApiPropertyOptional({ description: 'Whether downloadable.' })
  @IsOptional()
  @IsBoolean()
  isDownloadable?: boolean;

  @ApiPropertyOptional({ description: 'Ordering index.', minimum: 0 })
  @IsOptional()
  @IsInt()
  @Min(0)
  orderIndex?: number;

  @ApiPropertyOptional({
    description: 'Creator User UUID (or null to detach).',
    format: 'uuid',
    nullable: true,
  })
  @IsOptional()
  @IsUUID()
  createdById?: string | null;
}
