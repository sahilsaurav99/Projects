import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ModuleStatus } from '@prisma/client';
import {
  IsDateString,
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Min,
} from 'class-validator';

/**
 * CreateCourseModuleDto
 *
 * Fields mirror the Prisma `CourseModule` model exactly:
 *   instituteId, courseId, parentId?, title, description?,
 *   orderIndex, status?, unlocksAt?, locksAt?
 *
 * Hierarchy validation (parent belongs to same course/institute) and
 * uniqueness invariants (`orderIndex` unique within parent) are enforced
 * in the service.
 */
export class CreateCourseModuleDto {
  @ApiProperty({ description: 'Parent institute UUID.', format: 'uuid' })
  @IsUUID()
  instituteId!: string;

  @ApiProperty({ description: 'Owning Course UUID.', format: 'uuid' })
  @IsUUID()
  courseId!: string;

  @ApiPropertyOptional({
    description:
      'Optional parent CourseModule UUID. When omitted, this module is a root-level module within the course.',
    format: 'uuid',
  })
  @IsOptional()
  @IsUUID()
  parentId?: string;

  @ApiProperty({ description: 'Module title.', maxLength: 255 })
  @IsString()
  @Length(1, 255)
  title!: string;

  @ApiPropertyOptional({ description: 'Long-form module description.' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({
    description:
      'Zero-based ordering index within the parent module (or within the course when parentId is null). Unique within parent among non-deleted modules.',
    minimum: 0,
    example: 0,
  })
  @IsInt()
  @Min(0)
  orderIndex!: number;

  @ApiPropertyOptional({ enum: ModuleStatus, default: ModuleStatus.DRAFT })
  @IsOptional()
  @IsEnum(ModuleStatus)
  status?: ModuleStatus;

  @ApiPropertyOptional({
    description: 'Datetime when this module becomes available (ISO-8601).',
  })
  @IsOptional()
  @IsDateString()
  unlocksAt?: string;

  @ApiPropertyOptional({
    description: 'Datetime when this module locks (ISO-8601).',
  })
  @IsOptional()
  @IsDateString()
  locksAt?: string;
}
