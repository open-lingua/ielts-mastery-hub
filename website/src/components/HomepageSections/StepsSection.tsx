import React from 'react';
import { useRevealOnScroll } from '@site/src/hooks/useRevealOnScroll';
import styles from './StepsSection.module.css';

export interface StepsSectionProps {}

const STEPS = [
  {
    n: '01',
    title: 'Download',
    body: 'Grab the latest release for your OS from the GitHub releases page. macOS, Windows, and Linux builds are available.',
    code: '$ brew install ielts-mastery-hub',
  },
  {
    n: '02',
    title: 'Configure',
    body: 'Drop in your Anthropic API key and you\'re ready for AI-graded writing feedback. Everything else works offline.',
    code: 'ANTHROPIC_API_KEY=sk-ant-…',
  },
  {
    n: '03',
    title: 'Practice',
    body: 'Work through real IELTS tasks, get instant AI feedback on your writing, and watch your band score rise week by week.',
    code: null,
  },
];

export default function StepsSection(_props: StepsSectionProps): React.ReactElement {
  const headRef = useRevealOnScroll<HTMLDivElement>();

  return (
    <section className={styles.section} id="steps">
      <div className={styles.wrap}>
        <div className={styles.head} ref={headRef}>
          <span className={styles.eyebrow}>Get started</span>
          <h2>Up and running in two minutes</h2>
          <p>Three steps from download to your first band-score estimate.</p>
        </div>
        <div className={styles.grid}>
          {STEPS.map((step, i) => (
            <StepCard key={step.n} {...step} delay={i} />
          ))}
        </div>
      </div>
    </section>
  );
}

function StepCard({
  n,
  title,
  body,
  code,
  delay,
}: (typeof STEPS)[0] & { delay: number }): React.ReactElement {
  const ref = useRevealOnScroll<HTMLDivElement>();
  return (
    <div className={`${styles.step} d${delay + 1}`} ref={ref}>
      <div className={styles.n}>{n}</div>
      <div className={styles.rule} aria-hidden="true" />
      <h3>{title}</h3>
      <p>{body}</p>
      {code && <code className={styles.code}>{code}</code>}
    </div>
  );
}
