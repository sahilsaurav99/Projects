import { OmitType, PartialType } from '@nestjs/swagger';
import { CreateSectionDto } from './create-section.dto';

/**
 * UpdateSectionDto
 *
 * All fields optional except `instituteId`, which is immutable after creation
 * (parity with TermsModule). `batchId` and `termId` may be reassigned within
 * the same institute and are re-validated in the service.
 */
export class UpdateSectionDto extends PartialType(
  OmitType(CreateSectionDto, ['instituteId'] as const),
) {}
