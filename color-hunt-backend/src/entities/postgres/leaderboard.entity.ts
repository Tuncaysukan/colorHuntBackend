import { Column, Entity, PrimaryGeneratedColumn, Index } from 'typeorm';

@Entity({ name: 'leaderboards' })
export class Leaderboard {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'game_id' })
  gameId: string;

  @Column({ name: 'anonymous_id' })
  anonymousId: string;

  @Column({ type: 'int' })
  score: number;

  @Column({ type: 'int', nullable: true })
  duration: number | null;

  @Column({ type: 'timestamptz' })
  ts: Date;
}

