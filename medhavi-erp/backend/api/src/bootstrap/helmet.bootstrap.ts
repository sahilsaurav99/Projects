import { INestApplication } from '@nestjs/common';
import helmet from 'helmet';

export function applyHelmet(app: INestApplication): void {
  app.use(helmet());
}
