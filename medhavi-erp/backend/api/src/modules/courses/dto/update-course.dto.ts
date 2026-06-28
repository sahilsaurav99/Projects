import { OmitType, PartialType } from '@nestjs/swagger';
import { CreateCourseDto } from './create-course.dto';

/**
 * UpdateCourseDto
 *
 * All fields optional except `instituteId`, which is immutable after creation
 * (parity with SubjectOfferingsModule). Other parent references
 * (subjectOffering, term, ownerFaculty) may be re-pointed within the same
 * institute and are re-validated in the service.
 */
export class UpdateCourseDto extends PartialType(
  OmitType(CreateCourseDto, ['instituteId'] as const),
) {}
