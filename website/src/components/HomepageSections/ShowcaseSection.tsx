import React from 'react';
import { useRevealOnScroll } from '@site/src/hooks/useRevealOnScroll';
import MockReading from './MockReading';
import MockWriting from './MockWriting';
import MockProgress from './MockProgress';
import styles from './ShowcaseSection.module.css';

export interface ShowcaseSectionProps {}

export default function ShowcaseSection(_props: ShowcaseSectionProps): React.ReactElement {
  const headRef = useRevealOnScroll<HTMLDivElement>();

  return (
    <section className={styles.section} id="showcase">
      <div className={styles.wrap}>
        <div className={`${styles.head} ${styles.center}`} ref={headRef}>
          <span className={styles.eyebrow}>Inside the app</span>
          <h2>See it before you install it</h2>
          <p>Real UI from the desktop app — timed tests, AI feedback, and progress at a glance.</p>
        </div>
        <div className={styles.showcaseGrid}>
          <div className={styles.col}>
            <MockReading />
            <MockWriting />
          </div>
          <div className={styles.col}>
            <MockProgress />
          </div>
        </div>
      </div>
    </section>
  );
}
