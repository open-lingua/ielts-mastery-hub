import React, { useEffect, useRef, useState } from 'react';
import ExecutionEnvironment from '@docusaurus/ExecutionEnvironment';
import { useCountUp } from '@site/src/hooks/useCountUp';
import styles from './ScoreReportCard.module.css';

export interface ScoreReportCardProps {
  overallBand?: number;
  target?: number;
  delta?: string;
  modules?: { name: string; score: number }[];
}

const DEFAULT_MODULES = [
  { name: 'Listening', score: 8.0 },
  { name: 'Reading', score: 7.5 },
  { name: 'Writing', score: 7.0 },
  { name: 'Speaking', score: 7.5 },
];

export default function ScoreReportCard({
  overallBand = 7.5,
  target = 8.0,
  delta = '+1.5 vs last month',
  modules = DEFAULT_MODULES,
}: ScoreReportCardProps): React.ReactElement {
  const [triggered, setTriggered] = useState(false);
  const cardRef = useRef<HTMLDivElement>(null);
  const band = useCountUp(overallBand, 1400, triggered);

  useEffect(() => {
    if (!ExecutionEnvironment.canUseDOM) return;
    const el = cardRef.current;
    if (!el) return;
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting) {
          setTriggered(true);
          observer.disconnect();
        }
      },
      { threshold: 0.3 }
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  const fillPct = triggered ? (overallBand / 9) * 100 : 0;
  const targetPct = (target / 9) * 100;

  return (
    <div className={styles.report} ref={cardRef} aria-label="IELTS Score Report Card">
      <div className={styles.head}>
        <span className={styles.lbl}>IELTS Score Report</span>
        <span className={styles.chip}>
          <span className={styles.live} aria-hidden="true" />
          Live Preview
        </span>
      </div>

      <div className={styles.main}>
        <div className={styles.overall}>
          <div className={styles.k}>Overall Band</div>
          <div className={styles.band}>{band.toFixed(1)}</div>
          <div className={styles.delta}>↑ {delta}</div>
        </div>

        <div className={styles.scale} aria-label={`Band score scale, current ${overallBand} of 9`}>
          <div className={styles.scaleTicks}>
            {[9, 8, 7, 6, 5].map((n) => (
              <span key={n}>{n}</span>
            ))}
          </div>
          <div className={styles.scaleTrack}>
            <div
              className={styles.scaleFill}
              style={{ height: `${fillPct}%` }}
            />
            <div
              className={styles.scaleTarget}
              style={{ bottom: `${targetPct}%` }}
              aria-label={`Target: ${target}`}
            />
          </div>
        </div>
      </div>

      <div className={styles.modules}>
        {modules.map((mod) => (
          <div key={mod.name} className={styles.mod}>
            <span className={styles.modName}>{mod.name}</span>
            <div className={styles.bar} role="progressbar" aria-valuenow={mod.score} aria-valuemin={0} aria-valuemax={9}>
              <span style={{ width: triggered ? `${(mod.score / 9) * 100}%` : '0%' }} />
            </div>
            <span className={styles.val}>{mod.score.toFixed(1)}</span>
          </div>
        ))}
      </div>

      <div className={styles.foot}>
        <span>Test taken 14 days ago</span>
        <span className={styles.timer}>
          <svg className={styles.clock} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
            <circle cx="12" cy="12" r="10" />
            <path d="M12 6v6l4 2" />
          </svg>
          47:23
        </span>
      </div>
    </div>
  );
}
