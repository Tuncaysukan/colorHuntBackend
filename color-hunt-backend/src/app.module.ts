import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ColorHuntModule } from './color-hunt/color-hunt.module';
import { ColorHuntLevel } from './entities/mysql/color-hunt-level.entity';
import { Event } from './entities/postgres/event.entity';
import { Leaderboard } from './entities/postgres/leaderboard.entity';
import { AdMetric } from './entities/postgres/ad-metric.entity';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    ...(() => {
      const modules = [] as any[];
      const mysqlUrl = process.env.MYSQL_URL;
      const pgUrl = process.env.POSTGRES_URL;
      if (mysqlUrl) {
        modules.push(
          TypeOrmModule.forRoot({
            name: 'mysql',
            type: 'mysql',
            url: mysqlUrl,
            entities: [ColorHuntLevel],
            synchronize: false,
            timezone: 'Z',
          }),
        );
      }
      if (pgUrl) {
        modules.push(
          TypeOrmModule.forRoot({
            name: 'postgres',
            type: 'postgres',
            url: pgUrl,
            entities: [Event, Leaderboard, AdMetric],
            synchronize: false,
          }),
        );
      }
      return modules;
    })(),
    ColorHuntModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
