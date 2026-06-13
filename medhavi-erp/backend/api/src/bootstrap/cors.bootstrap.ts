import { INestApplication } from '@nestjs/common';

export function applyCors(app: INestApplication): void {
  app.enableCors({
    origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
    credentials: true,
  });
}
