import React from 'react';
import Link from '@docusaurus/Link';
import { useRevealOnScroll } from '@site/src/hooks/useRevealOnScroll';
import ScoreReportCard from './ScoreReportCard';
import styles from './Hero.module.css';

export interface HeroProps {}

export default function Hero(_props: HeroProps): React.ReactElement {
  const copyRef = useRevealOnScroll<HTMLDivElement>();
  const cardRef = useRevealOnScroll<HTMLDivElement>();

  return (
    <section className={styles.hero} id="hero">
      <div className={styles.wrap}>
        <div className={styles.grid}>
          <div className={styles.copy} ref={copyRef}>
            <span className={styles.eyebrow}>Desktop IELTS Trainer</span>
            <h1 className={styles.h1}>
              Prepare the way{' '}
              <em className={styles.em}>you'll sit it</em>
            </h1>
            <p className={styles.sub}>
              A native desktop trainer for IELTS: timed reading and listening,
              AI-graded writing, realistic exam simulations, and progress you
              can actually see.
            </p>
            <div className={styles.actions}>
              <Link
                href="https://github.com/open-lingua/ielts-mastery-hub/releases"
                className={styles.btnGold}
                aria-label="Download IELTS Mastery Hub"
              >
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true">
                  <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4" />
                  <polyline points="7 10 12 15 17 10" />
                  <line x1="12" y1="15" x2="12" y2="3" />
                </svg>
                Download for macOS
              </Link>
              <Link to="/docs/intro" className={styles.btnGhost}>
                Read the docs
              </Link>
            </div>
            <div className={styles.meta}>
              <span className={styles.dot} aria-hidden="true" />
              <span><strong>Free</strong></span>
              <span className={styles.dot} aria-hidden="true" />
              <span>macOS</span>
              <span className={styles.dot} aria-hidden="true" />
              <span>Windows</span>
              <span className={styles.dot} aria-hidden="true" />
              <span>Linux</span>
            </div>
          </div>

          <div ref={cardRef} className={`${styles.cardWrap} d1`}>
            <ScoreReportCard />
          </div>
        </div>
      </div>
    </section>
  );
}
