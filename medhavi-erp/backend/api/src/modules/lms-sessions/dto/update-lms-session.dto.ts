import { OmitType, PartialType } from '@nestjs/swagger';
import { CreateLmsSessionDto } from './create-lms-session.dto';

/**
 * UpdateLmsSessionDto
 *
 * All fields optional except `instituteId` and `moduleId`, which are
 * immutable after creation (a session cannot migrate between institutes
 * or modules).
 */
export class UpdateLmsSessionDto extends PartialType(
  OmitType(CreateLmsSessionDto, ['instituteId', 'moduleId'] as const),
) {}
