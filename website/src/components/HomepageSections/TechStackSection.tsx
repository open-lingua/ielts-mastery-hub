import React, { useEffect, useRef, useState } from 'react';
import ExecutionEnvironment from '@docusaurus/ExecutionEnvironment';
import { useRevealOnScroll } from '@site/src/hooks/useRevealOnScroll';
import styles from './TechStackSection.module.css';

export interface TechStackSectionProps {}

const STACK = [
  { lang: 'TypeScript', pct: 68, color: 'var(--imh-accent)' },
  { lang: 'Rust', pct: 32, color: 'var(--brand-navy)' },
];

const BULLETS = [
  { name: 'Tauri 2', desc: 'native desktop shell — tiny binary, no Electron overhead' },
  { name: 'React 19', desc: 'reactive UI with concurrent features' },
  { name: 'Claude API', desc: 'AI grading of Task 1 & 2 using real IELTS criteria' },
  { name: 'SQLite', desc: 'local persistence, all data stays on your machine' },
  { name: 'Vite', desc: 'fast development tooling and HMR' },
];

function CheckIcon(): React.ReactElement {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
      <polyline points="20 6 9 17 4 12" />
    </svg>
  );
}

export default function TechStackSection(_props: TechStackSectionProps): React.ReactElement {
  const headRef = useRevealOnScroll<HTMLDivElement>();
  const [triggered, setTriggered] = useState(false);
  const stackRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!ExecutionEnvironment.canUseDOM) return;
    const el = stackRef.current;
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
    <section className={styles.section} id="tech">
      <div className={styles.wrap}>
        <div className={styles.head} ref={headRef}>
          <span className={styles.eyebrow}>Built with</span>
          <h2>Modern stack, boring foundations</h2>
          <p>Chosen for correctness and maintainability, not hype.</p>
        </div>
        <div className={styles.grid}>
          <div className={styles.stack} ref={stackRef}>
            {STACK.map((row) => (
              <div key={row.lang} className={styles.stackrow}>
                <span className={styles.lang}>{row.lang}</span>
                <span className={styles.pct}>{row.pct}%</span>
                <div className={styles.meter}>
                  <span style={{ width: triggered ? `${row.pct}%` : '0%', background: row.color }} />
                </div>
              </div>
            ))}
          </div>
          <ul className={styles.list}>
            {BULLETS.map((b) => (
              <li key={b.name}>
                <CheckIcon />
                <span><b>{b.name}</b> — {b.desc}</span>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </section>
  );
}
