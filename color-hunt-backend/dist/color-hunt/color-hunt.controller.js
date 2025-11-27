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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ColorHuntController = void 0;
const common_1 = require("@nestjs/common");
const color_hunt_service_1 = require("./color-hunt.service");
let ColorHuntController = class ColorHuntController {
    service;
    constructor(service) {
        this.service = service;
    }
    async getLevels() {
        return this.service.getLevels();
    }
    async postEvent(payload) {
        await this.service.postEvent(payload);
        return { ok: true };
    }
    async getLeaderboard(limit = '10') {
        return this.service.getLeaderboard(parseInt(limit, 10) || 10);
    }
};
exports.ColorHuntController = ColorHuntController;
__decorate([
    (0, common_1.Get)('levels'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], ColorHuntController.prototype, "getLevels", null);
__decorate([
    (0, common_1.Post)('events'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], ColorHuntController.prototype, "postEvent", null);
__decorate([
    (0, common_1.Get)('leaderboard'),
    __param(0, (0, common_1.Query)('limit')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], ColorHuntController.prototype, "getLeaderboard", null);
exports.ColorHuntController = ColorHuntController = __decorate([
    (0, common_1.Controller)('color-hunt'),
    __metadata("design:paramtypes", [color_hunt_service_1.ColorHuntService])
], ColorHuntController);
//# sourceMappingURL=color-hunt.controller.js.map