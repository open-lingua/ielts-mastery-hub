import React, { useEffect, useRef, useState } from 'react';
import ExecutionEnvironment from '@docusaurus/ExecutionEnvironment';
import styles from './ShowcaseSection.module.css';

const BARS = [
  { label: 'W1', value: 5.5, height: 48 },
  { label: 'W2', value: 6.0, height: 58 },
  { label: 'W3', value: 6.5, height: 68 },
  { label: 'W4', value: 7.0, height: 80 },
  { label: 'W5', value: 7.5, height: 92 },
  { label: 'Now', value: 8.0, height: 112, current: true },
];

export default function MockProgress(): React.ReactElement {
  const [triggered, setTriggered] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!ExecutionEnvironment.canUseDOM) return;
    const el = ref.current;
    if (!el) return;
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting) { setTriggered(true); observer.disconnect(); }
      },
      { threshold: 0.3 }
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  return (
    <div className={styles.win} ref={ref}>
      <div className={styles.winBar}>
        <div className={styles.dots}><i /><i /><i /></div>
        <span className={styles.winTitle}><b>Progress</b> — Last 6 weeks</span>
      </div>
      <div className={styles.mockProg}>
        <div className={styles.ph}>
          <div>
            <span className={styles.big}>
              7.5 <em>overall</em>
            </span>
          </div>
          <span style={{fontFamily:'"IBM Plex Mono",monospace',fontSize:'.7rem',color:'var(--imh-ink-3)'}}>↑ +2.0 this month</span>
        </div>
        <div className={styles.chart}>
          {BARS.map((bar) => (
            <div
              key={bar.label}
              className={`${styles.cb} ${bar.current ? styles.cbCurrent : ''}`}
              style={{ height: triggered ? bar.height : 0 }}
              data-v={bar.value.toFixed(1)}
              role="img"
              aria-label={`Week ${bar.label}: ${bar.value}`}
            />
          ))}
        </div>
        <div className={styles.axis}>
          {BARS.map((bar) => (
            <span key={bar.label}>{bar.label}</span>
          ))}
        </div>
      </div>
    </div>
  );
}
