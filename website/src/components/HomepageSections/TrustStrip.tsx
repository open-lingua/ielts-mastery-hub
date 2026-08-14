import React from 'react';
import styles from './TrustStrip.module.css';

export interface TrustStripProps {}

const ITEMS = [
  { text: 'IELTS Band 1–9 aligned' },
  { text: 'AI-graded Task 1 & 2' },
  { text: 'Offline, no cloud required' },
  { text: 'Open source on GitHub' },
  { text: 'macOS · Windows · Linux' },
];

function CheckIcon(): React.ReactElement {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" aria-hidden="true">
      <polyline points="20 6 9 17 4 12" />
    </svg>
  );
}

export default function TrustStrip(_props: TrustStripProps): React.ReactElement {
  return (
    <div className={styles.trust}>
      <div className={styles.inner}>
        {ITEMS.map((item) => (
          <span key={item.text} className={styles.item}>
            <CheckIcon />
            {item.text}
          </span>
        ))}
      </div>
    </div>
  );
}
