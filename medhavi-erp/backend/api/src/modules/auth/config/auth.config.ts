import { registerAs } from '@nestjs/config';

export interface AuthConfig {
  accessSecret: string;
  refreshSecret: string;
  accessTtl: string;
  refreshTtl: string;
  issuer: string;
  audience: string;
  bcryptRounds: number;
  lockoutThreshold: number;
  lockoutWindowMin: number;
  lockoutDurationMin: number;
  resetTokenTtlMin: number;
}

export default registerAs<AuthConfig>('auth', () => ({
  accessSecret: process.env.JWT_ACCESS_SECRET ?? (() => { throw new Error('JWT_ACCESS_SECRET missing'); })(),
  refreshSecret: process.env.JWT_REFRESH_SECRET ?? (() => { throw new Error('JWT_REFRESH_SECRET missing'); })(),
  accessTtl: process.env.JWT_ACCESS_TTL ?? '15m',
  refreshTtl: process.env.JWT_REFRESH_TTL ?? '30d',
  issuer: process.env.JWT_ISSUER ?? 'erp',
  audience: process.env.JWT_AUDIENCE ?? 'erp-clients',
  bcryptRounds: parseInt(process.env.AUTH_BCRYPT_ROUNDS ?? '12', 10),
  lockoutThreshold: parseInt(process.env.AUTH_LOCKOUT_THRESHOLD ?? '5', 10),
  lockoutWindowMin: parseInt(process.env.AUTH_LOCKOUT_WINDOW_MIN ?? '15', 10),
  lockoutDurationMin: parseInt(process.env.AUTH_LOCKOUT_DURATION_MIN ?? '15', 10),
  resetTokenTtlMin: parseInt(process.env.AUTH_RESET_TOKEN_TTL_MIN ?? '60', 10),
}));
