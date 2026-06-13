"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mongoConfig = void 0;
exports.mongoConfig = {
    uri: process.env.MONGODB_URI || 'mongodb://localhost:27017/medhavi_logs',
};
