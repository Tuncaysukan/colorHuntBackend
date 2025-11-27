import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'ad_metrics' })
export class AdMetric {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'session_id' })
  sessionId: string;

  @Column({ name: 'ad_unit' })
  adUnit: string;

  @Column({ name: 'type' })
  type: string;

  @Column({ type: 'int' })
  count: number;

  @Column({ type: 'timestamptz' })
  ts: Date;
}

