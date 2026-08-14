import React from 'react';
import Link from '@docusaurus/Link';
import { useRevealOnScroll } from '@site/src/hooks/useRevealOnScroll';
import styles from './AudienceSection.module.css';

export interface AudienceSectionProps {}

const CARDS = [
  {
    role: 'Students',
    title: 'Aiming for Band 7 or higher',
    body: 'Practice under real exam conditions at home. Get AI feedback on your writing the moment you finish — not days later.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
        <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
        <path d="M6 12v5c3 3 9 3 12 0v-5" />
      </svg>
    ),
  },
  {
    role: 'Teachers',
    title: 'Teaching IELTS or English',
    body: 'Assign realistic practice tests and see exactly where each student needs the most work. No marking pile at the end of the week.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
        <rect x="2" y="3" width="20" height="14" rx="2" />
        <path d="M8 21h8M12 17v4" />
      </svg>
    ),
  },
  {
    role: 'Developers',
    title: 'Contributing to open source',
    body: 'Built with Tauri, React 19, and the Claude API. Dive into a real-world desktop app with a modern Rust backend.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
        <polyline points="16 18 22 12 16 6" />
        <polyline points="8 6 2 12 8 18" />
      </svg>
    ),
  },
];

export default function AudienceSection(_props: AudienceSectionProps): React.ReactElement {
  const headRef = useRevealOnScroll<HTMLDivElement>();

  return (
    <section className={styles.section} id="audience">
      <div className={styles.wrap}>
        <div className={styles.head} ref={headRef}>
          <span className={styles.eyebrow}>Who it&apos;s for</span>
          <h2>Built for every IELTS journey</h2>
          <p>Whether you&apos;re sitting the exam, teaching it, or building the next feature — there&apos;s a place for you here.</p>
        </div>
        <div className={styles.grid}>
          {CARDS.map((card, i) => (
            <AudienceCard key={card.role} {...card} delay={i} />
          ))}
        </div>
      </div>
    </section>
  );
}

function AudienceCard({
  role,
  title,
  body,
  icon,
  delay,
}: (typeof CARDS)[0] & { delay: number }): React.ReactElement {
  const ref = useRevealOnScroll<HTMLDivElement>();
  return (
    <div className={`${styles.card} d${delay + 1}`} ref={ref}>
      <div className={styles.ico} aria-hidden="true">{icon}</div>
      <div className={styles.role}>{role}</div>
      <h3>{title}</h3>
      <p>{body}</p>
      <Link to="/docs/intro" className={styles.more} aria-label={`Learn more about ${role}`}>
        Learn more
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
          <path d="M5 12h14M12 5l7 7-7 7" />
        </svg>
      </Link>
    </div>
  );
}
