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
exports.ColorHuntService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("typeorm");
const typeorm_2 = require("@nestjs/typeorm");
const color_hunt_level_entity_1 = require("../entities/mysql/color-hunt-level.entity");
const event_entity_1 = require("../entities/postgres/event.entity");
const leaderboard_entity_1 = require("../entities/postgres/leaderboard.entity");
let ColorHuntService = class ColorHuntService {
    mysql;
    pg;
    constructor(mysql, pg) {
        this.mysql = mysql;
        this.pg = pg;
    }
    async onModuleInit() {
        if (!this.mysql)
            return;
        const repo = this.mysql.getRepository(color_hunt_level_entity_1.ColorHuntLevel);
        const count = await repo.count();
        if (count === 0) {
            const seed = [
                { speed: 1, colorsCount: 3, paletteJson: JSON.stringify(['red', 'green', 'blue']) },
                { speed: 2, colorsCount: 4, paletteJson: JSON.stringify(['red', 'yellow', 'green', 'blue']) },
                { speed: 3, colorsCount: 5, paletteJson: JSON.stringify(['red', 'yellow', 'green', 'blue', 'purple']) },
            ];
            await repo.save(seed.map((s) => repo.create(s)));
        }
    }
    async getLevels() {
        if (this.mysql) {
            const repo = this.mysql.getRepository(color_hunt_level_entity_1.ColorHuntLevel);
            const levels = await repo.find({ order: { id: 'ASC' } });
            if (levels.length)
                return levels;
        }
        return [
            { id: 1, speed: 1, colorsCount: 3, paletteJson: JSON.stringify(['red', 'green', 'blue']) },
            { id: 2, speed: 2, colorsCount: 4, paletteJson: JSON.stringify(['red', 'yellow', 'green', 'blue']) },
        ];
    }
    async postEvent(payload) {
        if (this.pg) {
            const repo = this.pg.getRepository(event_entity_1.Event);
            const ev = repo.create({
                sessionId: payload.sessionId ?? 'unknown',
                anonymousId: payload.anonymousId ?? 'anon',
                gameId: 'color_hunt',
                eventType: payload.eventType ?? 'tap',
                payload: payload.payload ?? {},
                ts: payload.ts ? new Date(payload.ts) : new Date(),
            });
            await repo.save(ev);
        }
    }
    async getLeaderboard(limit) {
        if (this.pg) {
            const repo = this.pg.getRepository(leaderboard_entity_1.Leaderboard);
            const list = await repo.find({ where: { gameId: 'color_hunt' }, order: { score: 'DESC' }, take: limit });
            if (list.length)
                return list;
        }
        return [
            { id: 'demo-1', gameId: 'color_hunt', anonymousId: 'playerA', score: 120, duration: 30, ts: new Date() },
            { id: 'demo-2', gameId: 'color_hunt', anonymousId: 'playerB', score: 90, duration: 35, ts: new Date() },
        ];
    }
};
exports.ColorHuntService = ColorHuntService;
exports.ColorHuntService = ColorHuntService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, common_1.Optional)()),
    __param(0, (0, common_1.Inject)((0, typeorm_2.getDataSourceToken)('mysql'))),
    __param(1, (0, common_1.Optional)()),
    __param(1, (0, common_1.Inject)((0, typeorm_2.getDataSourceToken)('postgres'))),
    __metadata("design:paramtypes", [typeorm_1.DataSource,
        typeorm_1.DataSource])
], ColorHuntService);
//# sourceMappingURL=color-hunt.service.js.map