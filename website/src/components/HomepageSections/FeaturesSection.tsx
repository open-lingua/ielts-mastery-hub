import React from 'react';
import { useRevealOnScroll } from '@site/src/hooks/useRevealOnScroll';
import styles from './FeaturesSection.module.css';

export interface FeaturesSectionProps {}

const FEATURES = [
  {
    tag: 'Reading & Listening',
    title: 'Timed Tests',
    body: 'Practice exactly as you will on exam day — authentic passages, real timing, and the same question types.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
        <circle cx="12" cy="12" r="10" />
        <polyline points="12 6 12 12 16 14" />
      </svg>
    ),
  },
  {
    tag: 'Writing',
    title: 'AI Writing Feedback',
    body: 'Claude grades Task 1 & 2 using the four real IELTS criteria: Task Achievement, Coherence, Lexical Resource, Grammar.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
        <path d="M12 20h9" />
        <path d="M16.5 3.5a2.121 2.121 0 013 3L7 19l-4 1 1-4L16.5 3.5z" />
      </svg>
    ),
  },
  {
    tag: 'Simulations',
    title: 'Realistic Exam Mode',
    body: 'Full exam simulations with authentic timing and distraction-free UI — so test day feels familiar, not frightening.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
        <rect x="2" y="3" width="20" height="14" rx="2" />
        <path d="M8 21h8M12 17v4" />
      </svg>
    ),
  },
  {
    tag: 'Analytics',
    title: 'Progress Tracking',
    body: 'Watch your band score improve test by test. Drill into exactly which question type or skill is holding you back.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
        <line x1="18" y1="20" x2="18" y2="10" />
        <line x1="12" y1="20" x2="12" y2="4" />
        <line x1="6" y1="20" x2="6" y2="14" />
      </svg>
    ),
  },
  {
    tag: 'Privacy',
    title: 'Offline First',
    body: 'No internet needed for reading and listening tests. Writing AI grading goes out once — then the results stay local.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
        <path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z" />
      </svg>
    ),
  },
  {
    tag: 'Open Source',
    title: 'MIT Licensed',
    body: 'Built in the open. Read the code, fork it, contribute — or just trust that there\'s nothing hidden in what you install.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
        <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 00-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0020 4.77 5.07 5.07 0 0019.91 1S18.73.65 16 2.48a13.38 13.38 0 00-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 005 4.77a5.44 5.44 0 00-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 009 18.13V22" />
      </svg>
    ),
  },
];

export default function FeaturesSection(_props: FeaturesSectionProps): React.ReactElement {
  const headRef = useRevealOnScroll<HTMLDivElement>();

  return (
    <section className={styles.section} id="features">
      <div className={styles.wrap}>
        <div className={`${styles.head} ${styles.center}`} ref={headRef}>
          <span className={styles.eyebrow}>Features</span>
          <h2>Everything the exam demands</h2>
          <p>Six modules, one app — no subscription, no cloud lock-in.</p>
        </div>
        <div className={styles.grid}>
          {FEATURES.map((feat, i) => (
            <FeatureCard key={feat.title} {...feat} delay={i % 3} />
          ))}
        </div>
      </div>
    </section>
  );
}

function FeatureCard({
  tag,
  title,
  body,
  icon,
  delay,
}: (typeof FEATURES)[0] & { delay: number }): React.ReactElement {
  const ref = useRevealOnScroll<HTMLDivElement>();
  return (
    <div className={`${styles.feat} d${delay + 1}`} ref={ref}>
      <div className={styles.fi} aria-hidden="true">{icon}</div>
      <div className={styles.tag}>{tag}</div>
      <h3>{title}</h3>
      <p>{body}</p>
    </div>
  );
}
