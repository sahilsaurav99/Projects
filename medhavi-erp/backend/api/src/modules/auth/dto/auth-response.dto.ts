import { ApiProperty } from '@nestjs/swagger';

export class AuthUserDto {
  @ApiProperty() id!: string;
  @ApiProperty({ nullable: true }) instituteId!: string | null;
  @ApiProperty() email!: string;
  @ApiProperty() firstName!: string;
  @ApiProperty({ nullable: true }) lastName!: string | null;
  @ApiProperty({ nullable: true }) displayName!: string | null;
  @ApiProperty() status!: string;
  @ApiProperty() mfaEnabled!: boolean;
  @ApiProperty() mustChangePassword!: boolean;
}

export class AuthRoleDto {
  @ApiProperty() key!: string;
  @ApiProperty() name!: string;
  @ApiProperty() scopeType!: string;
  @ApiProperty({ nullable: true }) scopeId!: string | null;
  @ApiProperty() isPrimary!: boolean;
}

export class AuthResponseDto {
  @ApiProperty() accessToken!: string;
  @ApiProperty() refreshToken!: string;
  @ApiProperty() tokenType!: 'Bearer';
  @ApiProperty() expiresIn!: number;
  @ApiProperty({ type: AuthUserDto }) user!: AuthUserDto;
  @ApiProperty({ type: [AuthRoleDto] }) roles!: AuthRoleDto[];
  @ApiProperty({ type: [String], description: 'Resolved permission keys' })
  permissions!: string[];
}

export class TokenPairDto {
  @ApiProperty() accessToken!: string;
  @ApiProperty() refreshToken!: string;
  @ApiProperty() tokenType!: 'Bearer';
  @ApiProperty() expiresIn!: number;
}
