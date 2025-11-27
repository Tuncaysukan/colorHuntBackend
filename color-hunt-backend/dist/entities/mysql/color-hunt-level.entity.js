"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ColorHuntLevel = void 0;
const typeorm_1 = require("typeorm");
let ColorHuntLevel = class ColorHuntLevel {
    id;
    speed;
    colorsCount;
    paletteJson;
};
exports.ColorHuntLevel = ColorHuntLevel;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], ColorHuntLevel.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'int' }),
    __metadata("design:type", Number)
], ColorHuntLevel.prototype, "speed", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'int', name: 'colors_count' }),
    __metadata("design:type", Number)
], ColorHuntLevel.prototype, "colorsCount", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'text', name: 'palette_json' }),
    __metadata("design:type", String)
], ColorHuntLevel.prototype, "paletteJson", void 0);
exports.ColorHuntLevel = ColorHuntLevel = __decorate([
    (0, typeorm_1.Entity)({ name: 'levels_color_hunt' })
], ColorHuntLevel);
//# sourceMappingURL=color-hunt-level.entity.js.map