/**
 * Official IELTS Listening Band Score mapping (raw score out of 40).
 */
export function calculateListeningBandScore(rawScore: number): number {
  if (rawScore >= 39) return 9.0;
  if (rawScore >= 37) return 8.5;
  if (rawScore >= 35) return 8.0;
  if (rawScore >= 32) return 7.5;
  if (rawScore >= 30) return 7.0;
  if (rawScore >= 26) return 6.5;
  if (rawScore >= 23) return 6.0;
  if (rawScore >= 18) return 5.5;
  if (rawScore >= 16) return 5.0;
  if (rawScore >= 13) return 4.5;
  if (rawScore >= 10) return 4.0;
  if (rawScore >= 8) return 3.5;
  if (rawScore >= 6) return 3.0;
  if (rawScore >= 4) return 2.5;
  if (rawScore >= 2) return 2.0;
  if (rawScore >= 1) return 1.0;
  return 0.0;
}

/**
 * Compare a user answer against the correct answer (and optional accepted alternatives).
 * Trims whitespace and ignores case.
 */
export function isAnswerCorrect(
  userAnswer: string | undefined,
  correctAnswer: string,
  acceptedAnswers?: string[]
): boolean {
  const clean = (s: string) => s.trim().toLowerCase();
  const user = clean(userAnswer ?? "");
  if (!user) return false;

  if (user === clean(correctAnswer)) return true;
  if (acceptedAnswers?.some((a) => clean(a) === user)) return true;

  return false;
}
