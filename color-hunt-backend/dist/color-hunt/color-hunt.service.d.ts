import { OnModuleInit } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { ColorHuntLevel } from '../entities/mysql/color-hunt-level.entity';
import { Leaderboard } from '../entities/postgres/leaderboard.entity';
export declare class ColorHuntService implements OnModuleInit {
    private readonly mysql?;
    private readonly pg?;
    constructor(mysql?: DataSource | undefined, pg?: DataSource | undefined);
    onModuleInit(): Promise<void>;
    getLevels(): Promise<ColorHuntLevel[]>;
    postEvent(payload: any): Promise<void>;
    getLeaderboard(limit: number): Promise<Leaderboard[]>;
}
