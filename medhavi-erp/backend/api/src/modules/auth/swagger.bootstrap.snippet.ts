// Paste these lines into your existing main.ts (or wherever DocumentBuilder is configured)
// so Swagger's "Authorize" button accepts a Bearer token.

import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import type { INestApplication } from '@nestjs/common';

export function setupSwagger(app: INestApplication): void {
  const config = new DocumentBuilder()
    .setTitle('ERP API')
    .setDescription('ERP backend')
    .setVersion('1.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        in: 'header',
      },
      'bearer', // <-- name; match @ApiBearerAuth('bearer') if you pass an arg
    )
    .build();

  const doc = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/v1/docs', app, doc, {
    swaggerOptions: { persistAuthorization: true },
  });
}
