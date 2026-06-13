import { INestApplication } from '@nestjs/common';
import compression from 'compression';

export function applyCompression(app: INestApplication): void {
  app.use(compression());
}
