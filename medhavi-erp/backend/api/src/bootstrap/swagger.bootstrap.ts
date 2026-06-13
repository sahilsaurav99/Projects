import { INestApplication } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';

export function applySwagger(app: INestApplication): void {
  const config = new DocumentBuilder()
    .setTitle('Medhavi ERP API')
    .setDescription('Enterprise Resource Planning API')
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/v1/docs', app, document);
}
