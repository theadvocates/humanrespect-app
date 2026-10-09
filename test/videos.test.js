import { describe, it, expect } from 'vitest'
import { existsSync, readFileSync } from 'node:fs'
import { VIDEOS, videoBySlug, isoDuration } from '../app/utils/videos.js'
import { parseTranscript, clock } from '../app/utils/transcript.js'

/**
 * Each video has its own page at /watch/<slug>, built from this catalogue
 * and the captions file the player uses. A row that names a file that is not
 * in public/videos is a page with a dead player and an empty transcript, so
 * the files are checked here.
 */

describe('video catalogue', () => {
  it('has the files every page needs', () => {
    for (const v of VIDEOS) {
      for (const ext of ['mp4', 'jpg', 'vtt']) {
        expect(existsSync(`public/videos/${v.file}.${ext}`), `${v.file}.${ext} is missing`).toBe(true)
      }
    }
  })

  it('numbers the parts in order with unique slugs', () => {
    expect(VIDEOS.map((v) => v.n)).toEqual(VIDEOS.map((_, i) => i + 1))
    expect(new Set(VIDEOS.map((v) => v.slug)).size).toBe(VIDEOS.length)
    for (const v of VIDEOS) expect(v.slug).toMatch(/^[a-z0-9-]+$/)
  })

  it('gives each part what the structured data needs', () => {
    for (const v of VIDEOS) {
      expect(v.uploadDate, v.slug).toMatch(/^\d{4}-\d{2}-\d{2}$/)
      expect(v.seconds, v.slug).toBeGreaterThan(60)
      expect(Math.round(v.seconds / 60), `${v.slug} minutes label disagrees with its length`).toBe(v.minutes)
      expect(v.description.length, v.slug).toBeGreaterThan(40)
      expect(v.description.length, v.slug).toBeLessThan(320)
      expect(v.description, `${v.slug} description has an em dash`).not.toMatch(/—/)
    }
  })

  it('links only to experience pages that exist', () => {
    for (const v of VIDEOS) {
      if (!v.path) continue
      const file = `app/pages${v.path}.vue`
      expect(existsSync(file), `${v.slug} points at ${v.path}, which has no page`).toBe(true)
    }
  })

  it('finds a part by slug and nothing else', () => {
    expect(videoBySlug('the-question')?.n).toBe(1)
    expect(videoBySlug('nope')).toBeNull()
  })

  it('writes schema.org durations', () => {
    expect(isoDuration(357)).toBe('PT5M57S')
    expect(isoDuration(300)).toBe('PT5M0S')
  })
})

describe('transcript', () => {
  it('reads every captions file into readable paragraphs', () => {
    for (const v of VIDEOS) {
      const paras = parseTranscript(readFileSync(`public/videos/${v.file}.vtt`, 'utf8'))
      const words = paras.reduce((n, p) => n + p.text.split(' ').length, 0)
      expect(paras.length, `${v.file} has too few paragraphs`).toBeGreaterThan(5)
      expect(words, `${v.file} transcript is short`).toBeGreaterThan(300)
      for (const p of paras) {
        expect(p.text.split(' ').length, `${v.file} paragraph at ${p.t} is a wall`).toBeLessThan(140)
      }
      // In order, and starting near the top of the video.
      expect(paras[0].t).toBeLessThan(10)
      for (let i = 1; i < paras.length; i++) expect(paras[i].t).toBeGreaterThan(paras[i - 1].t)
    }
  })

  it('breaks on a pause and on a sentence end once a paragraph is long', () => {
    const vtt = [
      'WEBVTT', '',
      '1', '00:00:01.000 --> 00:00:02.000', 'One.', '',
      '2', '00:00:02.000 --> 00:00:03.000', 'Two.', '',
      '3', '00:00:05.000 --> 00:00:06.000', 'Three after a pause.', ''
    ].join('\n')
    const paras = parseTranscript(vtt)
    expect(paras.map((p) => p.text)).toEqual(['One. Two.', 'Three after a pause.'])
    expect(paras[1].t).toBe(5)
  })

  it('labels a time as minutes and seconds', () => {
    expect(clock(0)).toBe('0:00')
    expect(clock(65.4)).toBe('1:05')
    expect(clock(357)).toBe('5:57')
  })
})
