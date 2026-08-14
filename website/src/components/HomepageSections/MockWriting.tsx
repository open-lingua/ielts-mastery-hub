import React from 'react';
import styles from './ShowcaseSection.module.css';

export default function MockWriting(): React.ReactElement {
  return (
    <div className={styles.win}>
      <div className={styles.winBar}>
        <div className={styles.dots}>
          <i /><i /><i />
        </div>
        <span className={styles.winTitle}><b>Writing Feedback</b> — Task 2</span>
      </div>
      <div className={styles.mockWrite}>
        <p className={styles.para}>
          The{' '}
          <span className={styles.hl}>rapid urbanisation</span> of developing
          nations has led to significant infrastructure challenges that
          governments must address through{' '}
          <span className={styles.hl}>coordinated policy</span>.
        </p>
        <div className={styles.note}>
          <div className={styles.ntag}>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{width:12,height:12}} aria-hidden="true">
              <path d="M12 20h9" />
              <path d="M16.5 3.5a2.121 2.121 0 013 3L7 19l-4 1 1-4L16.5 3.5z" />
            </svg>
            AI Suggestion
          </div>
          <p>Consider elaborating on <em>specific</em> policy examples to strengthen your Task Achievement score.</p>
        </div>
        <div className={styles.crit}>
          {[
            { label: 'Task Achievement', value: '7.0' },
            { label: 'Coherence', value: '7.5' },
            { label: 'Lexical', value: '6.5' },
            { label: 'Grammar', value: '7.0' },
          ].map((c) => (
            <div key={c.label} className={styles.c}>
              <div className={styles.cl}>{c.label}</div>
              <div className={styles.cv}>{c.value}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
