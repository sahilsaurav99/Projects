"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.applyHelmet = applyHelmet;
var helmet_1 = require("helmet");
function applyHelmet(app) {
    app.use((0, helmet_1.default)());
}
