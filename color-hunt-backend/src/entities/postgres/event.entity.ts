import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'events' })
export class Event {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'session_id' })
  sessionId: string;

  @Column({ name: 'anonymous_id' })
  anonymousId: string;

  @Column({ name: 'game_id' })
  gameId: string;

  @Column({ name: 'event_type' })
  eventType: string;

  @Column({ type: 'jsonb' })
  payload: any;

  @Column({ type: 'timestamptz' })
  ts: Date;
}

