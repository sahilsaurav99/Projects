import { OmitType, PartialType } from '@nestjs/swagger';
import { CreateCampusDto } from './create-campus.dto';

/**
 * UpdateCampusDto
 *
 * All CreateCampusDto fields become optional EXCEPT `instituteId`,
 * which is immutable after creation (campuses cannot be re-parented).
 */
export class UpdateCampusDto extends PartialType(
  OmitType(CreateCampusDto, ['instituteId'] as const),
) {}
