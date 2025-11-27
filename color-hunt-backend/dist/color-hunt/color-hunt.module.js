"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ColorHuntModule = void 0;
const common_1 = require("@nestjs/common");
const color_hunt_controller_1 = require("./color-hunt.controller");
const color_hunt_service_1 = require("./color-hunt.service");
let ColorHuntModule = class ColorHuntModule {
};
exports.ColorHuntModule = ColorHuntModule;
exports.ColorHuntModule = ColorHuntModule = __decorate([
    (0, common_1.Module)({
        controllers: [color_hunt_controller_1.ColorHuntController],
        providers: [color_hunt_service_1.ColorHuntService],
    })
], ColorHuntModule);
//# sourceMappingURL=color-hunt.module.js.map