import { plainToInstance } from 'class-transformer';
import { IsString, IsNumber, validateSync } from 'class-validator';

class EnvironmentVariables {
  @IsString()
  NODE_ENV: string;

  @IsNumber()
  API_PORT: number;

  @IsString()
  DATABASE_URL: string;

  @IsString()
  REDIS_URL: string;

  @IsString()
  MONGODB_URI: string;

  @IsString()
  JWT_ACCESS_SECRET: string;

  @IsString()
  JWT_REFRESH_SECRET: string;
}

export function validateEnv(config: Record<string, unknown>) {
  const validatedConfig = plainToInstance(EnvironmentVariables, config, {
    enableImplicitConversion: true,
  });
  const errors = validateSync(validatedConfig, { skipMissingProperties: false });

  if (errors.length > 0) {
    throw new Error(errors.toString());
  }
  return validatedConfig;
}
