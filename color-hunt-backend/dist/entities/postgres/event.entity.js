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
exports.Event = void 0;
const typeorm_1 = require("typeorm");
let Event = class Event {
    id;
    sessionId;
    anonymousId;
    gameId;
    eventType;
    payload;
    ts;
};
exports.Event = Event;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)('uuid'),
    __metadata("design:type", String)
], Event.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'session_id' }),
    __metadata("design:type", String)
], Event.prototype, "sessionId", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'anonymous_id' }),
    __metadata("design:type", String)
], Event.prototype, "anonymousId", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'game_id' }),
    __metadata("design:type", String)
], Event.prototype, "gameId", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'event_type' }),
    __metadata("design:type", String)
], Event.prototype, "eventType", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'jsonb' }),
    __metadata("design:type", Object)
], Event.prototype, "payload", void 0);
__decorate([
    (0, typeorm_1.Column)({ type: 'timestamptz' }),
    __metadata("design:type", Date)
], Event.prototype, "ts", void 0);
exports.Event = Event = __decorate([
    (0, typeorm_1.Entity)({ name: 'events' })
], Event);
//# sourceMappingURL=event.entity.js.map