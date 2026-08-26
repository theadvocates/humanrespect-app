/**
 * Reading time for an essay.
 *
 * Derived rather than stored. When each essay carried a hand-written
 * `minutes`, all fifteen were wrong in the same direction — every one
 * overstated by a minute or two, because the number was set once while
 * drafting and never checked against what got written. It is shown to the
 * reader before they commit, which is the one place a wrong number does
 * damage.
 *
 * 220 words per minute is the usual figure for adult prose. Rounded to the
 * nearest minute, floored at two, since "1 minute read" reads as a claim
 * about how slight the thing is rather than how quick.
 */
const WORDS_PER_MINUTE = 220

export function essayWords(essay) {
  return essay.sections
    .flatMap((s) => s.body)
    .join(' ')
    .split(/\s+/)
    .filter(Boolean).length
}

export function readingMinutes(essay) {
  return Math.max(2, Math.round(essayWords(essay) / WORDS_PER_MINUTE))
}
