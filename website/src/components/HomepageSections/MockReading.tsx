import React from 'react';
import styles from './ShowcaseSection.module.css';

export default function MockReading(): React.ReactElement {
  return (
    <div className={styles.win}>
      <div className={styles.winBar}>
        <div className={styles.dots}>
          <i /><i /><i />
        </div>
        <span className={styles.winTitle}>
          <b>Reading Test</b> — Part 1 of 3
        </span>
      </div>
      <div className={styles.mockRead}>
        <div className={styles.rtTop}>
          <span className={styles.part}>Academic Reading · Section 1</span>
          <span className={styles.rtClock}>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" aria-hidden="true" style={{width:13,height:13}}>
              <circle cx="12" cy="12" r="10" />
              <path d="M12 6v6l4 2" />
            </svg>
            58:42
          </span>
        </div>
        <div className={styles.rtBody}>
          <div className={styles.mockLines}>
            <span style={{width:'40%',background:'var(--imh-accent-tint-2)',height:10}} />
            <span /><span /><span /><span /><span /><span />
          </div>
          <div className={styles.mockQ}>
            {[
              { n: '1', on: true, text: 'Questions 1–7: Choose the correct letter.' },
              { n: '2', on: false, text: 'The author argues that…' },
              { n: '3', on: true, text: 'Which paragraph contains the main claim?' },
            ].map((q) => (
              <div key={q.n} className={styles.qitem}>
                <span className={styles.qnum}>{q.n}</span>
                <span className={`${styles.opt} ${q.on ? styles.on : ''}`} />
                <span>{q.text}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
