import { OmitType, PartialType } from '@nestjs/swagger';
import { CreateFacultyDto } from './create-faculty.dto';

/**
 * UpdateFacultyDto
 *
 * All fields optional except `instituteId` and `userId`, which are immutable
 * after creation (parity with StudentsModule).
 */
export class UpdateFacultyDto extends PartialType(
  OmitType(CreateFacultyDto, ['instituteId', 'userId'] as const),
) {}
