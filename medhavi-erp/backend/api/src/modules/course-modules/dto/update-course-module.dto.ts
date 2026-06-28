import { OmitType, PartialType } from '@nestjs/swagger';
import { CreateCourseModuleDto } from './create-course-module.dto';

/**
 * UpdateCourseModuleDto
 *
 * All fields optional except `instituteId` and `courseId`, which are
 * immutable after creation (a module cannot migrate between institutes
 * or courses). `parentId` may be re-pointed within the same course and
 * is re-validated in the service.
 */
export class UpdateCourseModuleDto extends PartialType(
  OmitType(CreateCourseModuleDto, ['instituteId', 'courseId'] as const),
) {}
