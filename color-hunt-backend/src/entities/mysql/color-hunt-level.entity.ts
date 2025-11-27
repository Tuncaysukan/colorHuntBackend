import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'levels_color_hunt' })
export class ColorHuntLevel {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'int' })
  speed: number;

  @Column({ type: 'int', name: 'colors_count' })
  colorsCount: number;

  @Column({ type: 'text', name: 'palette_json' })
  paletteJson: string;
}

