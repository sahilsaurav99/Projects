"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.redisConfig = void 0;
exports.redisConfig = {
    url: process.env.REDIS_URL || 'redis://localhost:6379',
};
