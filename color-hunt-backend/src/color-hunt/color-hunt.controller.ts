import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { ColorHuntService } from './color-hunt.service';

@Controller('color-hunt')
export class ColorHuntController {
  constructor(private readonly service: ColorHuntService) {}

  @Get('levels')
  async getLevels() {
    return this.service.getLevels();
  }

  @Post('events')
  async postEvent(@Body() payload: any) {
    await this.service.postEvent(payload);
    return { ok: true };
  }

  @Get('leaderboard')
  async getLeaderboard(@Query('limit') limit = '10') {
    return this.service.getLeaderboard(parseInt(limit, 10) || 10);
  }
}

