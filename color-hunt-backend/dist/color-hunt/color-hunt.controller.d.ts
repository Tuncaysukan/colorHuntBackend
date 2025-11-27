import { ColorHuntService } from './color-hunt.service';
export declare class ColorHuntController {
    private readonly service;
    constructor(service: ColorHuntService);
    getLevels(): Promise<import("../entities/mysql/color-hunt-level.entity").ColorHuntLevel[]>;
    postEvent(payload: any): Promise<{
        ok: boolean;
    }>;
    getLeaderboard(limit?: string): Promise<import("../entities/postgres/leaderboard.entity").Leaderboard[]>;
}
