import { ApiProperty } from '@nestjs/swagger';
import { AuthRoleDto, AuthUserDto } from './auth-response.dto';

export class MeResponseDto {
  @ApiProperty({ type: AuthUserDto }) user!: AuthUserDto;
  @ApiProperty({ type: [AuthRoleDto] }) roles!: AuthRoleDto[];
  @ApiProperty({ type: [String] }) permissions!: string[];
  @ApiProperty({ nullable: true }) primaryRole!: string | null;
}
