"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const app_controller_1 = require("./app.controller");
const app_service_1 = require("./app.service");
const config_1 = require("@nestjs/config");
const typeorm_1 = require("@nestjs/typeorm");
const color_hunt_module_1 = require("./color-hunt/color-hunt.module");
const color_hunt_level_entity_1 = require("./entities/mysql/color-hunt-level.entity");
const event_entity_1 = require("./entities/postgres/event.entity");
const leaderboard_entity_1 = require("./entities/postgres/leaderboard.entity");
const ad_metric_entity_1 = require("./entities/postgres/ad-metric.entity");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot({ isGlobal: true }),
            ...(() => {
                const modules = [];
                const mysqlUrl = process.env.MYSQL_URL;
                const pgUrl = process.env.POSTGRES_URL;
                if (mysqlUrl) {
                    modules.push(typeorm_1.TypeOrmModule.forRoot({
                        name: 'mysql',
                        type: 'mysql',
                        url: mysqlUrl,
                        entities: [color_hunt_level_entity_1.ColorHuntLevel],
                        synchronize: false,
                        timezone: 'Z',
                    }));
                }
                if (pgUrl) {
                    modules.push(typeorm_1.TypeOrmModule.forRoot({
                        name: 'postgres',
                        type: 'postgres',
                        url: pgUrl,
                        entities: [event_entity_1.Event, leaderboard_entity_1.Leaderboard, ad_metric_entity_1.AdMetric],
                        synchronize: false,
                    }));
                }
                return modules;
            })(),
            color_hunt_module_1.ColorHuntModule,
        ],
        controllers: [app_controller_1.AppController],
        providers: [app_service_1.AppService],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map