/**
 * The narrated series, in one place: the parts that are finished, in the
 * order the series runs (explainer-videos, series/humanrespect.yaml).
 *
 * Each part has its own page at /watch/<slug>, with the video as the main
 * content and the narration as a transcript, so a search engine can treat
 * it as a video page and read what the video says. The Watch index lists
 * the parts and links to them. Add a row when a part goes live.
 *
 * `seconds` is the length of the file, read with ffprobe; `uploadDate` is
 * the day the file went on the site. Both go into the VideoObject markup.
 */

export const VIDEOS = [
  {
    n: 1,
    slug: 'the-question',
    title: 'The Question',
    file: 'exp-the-question',
    path: '/experience/the-question',
    minutes: 3,
    seconds: 177,
    uploadDate: '2026-10-03',
    description:
      'You already use a moral principle you have never said out loud: you do not force the people you know to do it your way. Why we abandon it at scale, and what that costs.'
  },
  {
    n: 2,
    slug: 'the-objection',
    title: 'The Objection',
    file: 'exp-the-objection',
    path: '/experience/the-objection',
    minutes: 4,
    seconds: 267,
    uploadDate: '2026-10-05',
    description:
      'A country is millions of strangers, and some of them steal. Is law and order what keeps you safe? Test that against your own day, and find what actually protects you.'
  },
  {
    n: 3,
    slug: 'flourishing',
    title: 'What Flourishing Actually Means',
    file: 'exp-flourishing',
    path: '/experience/flourishing',
    minutes: 5,
    seconds: 305,
    uploadDate: '2026-10-07',
    description:
      'Think of the best stretch of your life, then the hardest. What was true each time? The evidence that safety, what you keep, your own time and chosen company are what a good life runs on.'
  },
  {
    n: 4,
    slug: 'human-agency',
    title: 'Human Agency',
    file: 'exp-human-agency',
    path: '/experience/human-agency',
    minutes: 5,
    seconds: 300,
    uploadDate: '2026-10-07',
    description:
      'You do not rob or threaten your neighbors. But have you ever asked someone else to do it for you? A vote is a signature, and a co-signer stays responsible for what the borrower does.'
  },
  {
    // Video only: there is no interactive experience to work through.
    n: 5,
    slug: 'now-do-crime',
    title: 'Now Do Crime',
    file: 'exp-now-do-crime',
    path: null,
    minutes: 6,
    seconds: 357,
    uploadDate: '2026-10-08',
    description:
      'Of every hundred thefts in the United States, about four end with anyone held to account. What the force-based system delivers for crime, measured, and what restitution and a face-to-face conference deliver at the scale of a country.'
  }
]

/** The part being made next, named on the index and at the end of the last page. */
export const NEXT_PART = 'The Method Is the Message'

export function videoBySlug(slug) {
  return VIDEOS.find((v) => v.slug === slug) || null
}

/** ISO 8601 duration for schema.org, e.g. 357 → PT5M57S. */
export function isoDuration(seconds) {
  const m = Math.floor(seconds / 60)
  const s = seconds % 60
  return `PT${m}M${s}S`
}
