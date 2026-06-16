import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, MaxLength } from 'class-validator';

export class ForgotPasswordDto {
  @ApiProperty({ example: 'student@example.edu' })
  @IsEmail()
  @MaxLength(255)
  email!: string;
}
