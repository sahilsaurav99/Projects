import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigType } from '@nestjs/config';
import { Inject } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import authConfig from './config/auth.config';

@Injectable()
export class PasswordService {
  constructor(
    @Inject(authConfig.KEY) private readonly cfg: ConfigType<typeof authConfig>,
  ) {}

  hash(plain: string): Promise<string> {
    return bcrypt.hash(plain, this.cfg.bcryptRounds);
  }

  async verify(plain: string, hash: string): Promise<boolean> {
    try {
      return await bcrypt.compare(plain, hash);
    } catch {
      return false;
    }
  }

  assertPolicy(plain: string): void {
    if (plain.length < 8 || plain.length > 128) {
      throw new UnauthorizedException('Password does not meet length policy');
    }
  }
}
