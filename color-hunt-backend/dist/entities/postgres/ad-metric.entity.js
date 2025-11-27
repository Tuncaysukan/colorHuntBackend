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
exports.AdMetric = void 0;
const typeorm_1 = require("typeorm");
let AdMetric = class AdMetric {
    id;
    sessionId;
    adUnit;
    type;
    count;
    ts;
};
exports.AdMetric = AdMetric;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], AdMetric.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'session_id' }),
    __metadata("design:type", String)
], AdMetric.prototype, "sessionId", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'ad_unit' }),
    __metadata("design:type", String)
], AdMetric.prototype, "adUnit", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'type' }),
    __metadata("design:type", String)
], AdMetric.prototype, "type", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'int' }),
    __metadata("design:type", Number)
], AdMetric.prototype, "count", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'timestamptz' }),
    __metadata("design:type", Date)
], AdMetric.prototype, "ts", void 0);
exports.AdMetric = AdMetric = __decorate([
    (0, typeorm_1.Entity)({ name: 'ad_metrics' })
], AdMetric);
//# sourceMappingURL=ad-metric.entity.js.map