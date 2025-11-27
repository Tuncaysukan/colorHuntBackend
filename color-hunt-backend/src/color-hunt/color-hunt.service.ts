import { Injectable, Optional, Inject, OnModuleInit } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { getDataSourceToken } from '@nestjs/typeorm';
import { ColorHuntLevel } from '../entities/mysql/color-hunt-level.entity';
import { Event } from '../entities/postgres/event.entity';
import { Leaderboard } from '../entities/postgres/leaderboard.entity';

@Injectable()
export class ColorHuntService implements OnModuleInit {
  constructor(
    @Optional() @Inject(getDataSourceToken('mysql')) private readonly mysql?: DataSource,
    @Optional() @Inject(getDataSourceToken('postgres')) private readonly pg?: DataSource,
  ) {}

  async onModuleInit() {
    if (!this.mysql) return;
    const repo = this.mysql.getRepository(ColorHuntLevel);
    const count = await repo.count();
    if (count === 0) {
      const seed = [
        { speed: 1, colorsCount: 3, paletteJson: JSON.stringify(['red','green','blue']) },
        { speed: 2, colorsCount: 4, paletteJson: JSON.stringify(['red','yellow','green','blue']) },
        { speed: 3, colorsCount: 5, paletteJson: JSON.stringify(['red','yellow','green','blue','purple']) },
      ];
      await repo.save(seed.map((s) => repo.create(s)));
    }
  }

  async getLevels() {
    if (this.mysql) {
      const repo = this.mysql.getRepository(ColorHuntLevel);
      const levels = await repo.find({ order: { id: 'ASC' } });
      if (levels.length) return levels;
    }
    return [
      { id: 1, speed: 1, colorsCount: 3, paletteJson: JSON.stringify(['red','green','blue']) },
      { id: 2, speed: 2, colorsCount: 4, paletteJson: JSON.stringify(['red','yellow','green','blue']) },
    ];
  }

  async postEvent(payload: any) {
    if (this.pg) {
      const repo = this.pg.getRepository(Event);
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

  async getLeaderboard(limit: number) {
    if (this.pg) {
      const repo = this.pg.getRepository(Leaderboard);
      const list = await repo.find({ where: { gameId: 'color_hunt' }, order: { score: 'DESC' }, take: limit });
      if (list.length) return list;
    }
    return [
      { id: 'demo-1', gameId: 'color_hunt', anonymousId: 'playerA', score: 120, duration: 30, ts: new Date() },
      { id: 'demo-2', gameId: 'color_hunt', anonymousId: 'playerB', score: 90, duration: 35, ts: new Date() },
    ];
  }
}
