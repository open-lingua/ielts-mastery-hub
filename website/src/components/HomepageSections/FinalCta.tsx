import React from 'react';
import Link from '@docusaurus/Link';
import { useRevealOnScroll } from '@site/src/hooks/useRevealOnScroll';
import styles from './FinalCta.module.css';

export interface FinalCtaProps {}

export default function FinalCta(_props: FinalCtaProps): React.ReactElement {
  const ref = useRevealOnScroll<HTMLDivElement>();

  return (
    <section className={styles.cta}>
      <div className={styles.box} ref={ref}>
        <span className={styles.eyebrow}>Free &amp; open source</span>
        <h2>Ready to push your band score?</h2>
        <p>
          Download IELTS Mastery Hub and start your first timed test in under
          two minutes.
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
          <Link
            href="https://github.com/open-lingua/ielts-mastery-hub"
            className={styles.btnGhost}
            aria-label="View IELTS Mastery Hub on GitHub"
          >
            View on GitHub
          </Link>
        </div>
        <p className={styles.fine}>macOS 13+ · Windows 10+ · Linux · MIT License</p>
      </div>
    </section>
  );
}
