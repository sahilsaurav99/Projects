import { OmitType, PartialType } from '@nestjs/swagger';
import { CreateTermDto } from './create-term.dto';

/**
 * UpdateTermDto
 *
 * All fields optional except `instituteId`, which is immutable after creation
 * (parity with SubjectsModule). `academicYearId` may be moved within the same
 * institute and is re-validated in the service.
 */
export class UpdateTermDto extends PartialType(
  OmitType(CreateTermDto, ['instituteId'] as const),
) {}
