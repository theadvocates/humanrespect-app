/**
 * Turns a WebVTT captions file into transcript paragraphs.
 *
 * The captions are the narration, one phrase per cue, timed to the spoken
 * word by the video tool. Read in order they are the whole script, so the
 * transcript on a video page comes from the same file the player uses and
 * cannot drift from it.
 *
 * Paragraphs break where the narration pauses, or at the end of a sentence
 * once a paragraph has grown long enough to be hard to read as one block.
 */

const PAUSE = 1.2 // seconds of silence that always starts a new paragraph
const LONG = 55 // words after which the next sentence end starts one

function seconds(stamp) {
  const [h, m, s] = stamp.split(':')
  return Number(h) * 3600 + Number(m) * 60 + Number(s)
}

/** @returns {{ t: number, text: string }[]} start time and text per paragraph */
export function parseTranscript(vtt) {
  const cues = []
  const re = /(\d\d:\d\d:\d\d\.\d+) --> (\d\d:\d\d:\d\d\.\d+)[^\n]*\n([\s\S]*?)(?:\n\n|\n*$)/g
  let m
  while ((m = re.exec(vtt))) {
    const text = m[3].replace(/<[^>]+>/g, '').replace(/\s+/g, ' ').trim()
    if (text) cues.push({ start: seconds(m[1]), end: seconds(m[2]), text })
  }

  const paragraphs = []
  let current = null
  let prevEnd = null
  for (const cue of cues) {
    const gap = prevEnd === null ? 0 : cue.start - prevEnd
    const words = current ? current.text.split(' ').length : 0
    const sentenceEnded = current ? /[.!?]["']?$/.test(current.text) : true
    if (!current || gap >= PAUSE || (words >= LONG && sentenceEnded)) {
      current = { t: Math.floor(cue.start * 10) / 10, text: cue.text }
      paragraphs.push(current)
    } else {
      current.text += ' ' + cue.text
    }
    prevEnd = cue.end
  }
  return paragraphs
}

/** m:ss for a timestamp label. */
export function clock(t) {
  const m = Math.floor(t / 60)
  const s = Math.floor(t % 60)
  return `${m}:${String(s).padStart(2, '0')}`
}
