"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.applySwagger = applySwagger;
var swagger_1 = require("@nestjs/swagger");
function applySwagger(app) {
    var config = new swagger_1.DocumentBuilder()
        .setTitle('Medhavi ERP API')
        .setDescription('Enterprise Resource Planning API')
        .setVersion('1.0')
        .addBearerAuth()
        .build();
    var document = swagger_1.SwaggerModule.createDocument(app, config);
    swagger_1.SwaggerModule.setup('api/v1/docs', app, document);
}
