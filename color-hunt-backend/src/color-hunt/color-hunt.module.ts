import { Module, Optional } from '@nestjs/common';
import { ColorHuntController } from './color-hunt.controller';
import { ColorHuntService } from './color-hunt.service';

@Module({
  controllers: [ColorHuntController],
  providers: [ColorHuntService],
})
export class ColorHuntModule {}

