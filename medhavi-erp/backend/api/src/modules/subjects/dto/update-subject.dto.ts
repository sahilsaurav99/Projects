import { OmitType, PartialType } from '@nestjs/swagger';
import { CreateSubjectDto } from './create-subject.dto';

/**
 * UpdateSubjectDto
 *
 * All fields optional except `instituteId`, which is immutable after creation
 * (parity with FacultyModule). `departmentId` and `programId` may be moved
 * within the same institute and are re-validated in the service.
 */
export class UpdateSubjectDto extends PartialType(
  OmitType(CreateSubjectDto, ['instituteId'] as const),
) {}
