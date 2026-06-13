"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.applyCompression = applyCompression;
var compression_1 = require("compression");
function applyCompression(app) {
    app.use((0, compression_1.default)());
}
