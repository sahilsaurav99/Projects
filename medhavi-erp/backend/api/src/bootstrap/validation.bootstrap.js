"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.applyValidation = applyValidation;
var common_1 = require("@nestjs/common");
function applyValidation(app) {
    app.useGlobalPipes(new common_1.ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
        transformOptions: {
            enableImplicitConversion: true,
        },
    }));
}
