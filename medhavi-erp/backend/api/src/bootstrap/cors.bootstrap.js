"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.applyCors = applyCors;
function applyCors(app) {
    app.enableCors({
        origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
        credentials: true,
    });
}
