"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.queueConfig = void 0;
exports.queueConfig = {
    redis: {
        host: process.env.REDIS_HOST || 'localhost',
        port: parseInt(process.env.REDIS_PORT || '6379', 10),
    },
};
