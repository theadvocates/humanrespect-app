/**
 * Generates a social card per page.
 *
 * Every URL on this site previously shared the same generic image. That
 * matters more here than for most sites: this is designed to be handed to
 * someone who disagrees with you, so a link lands in an argument — a group
 * chat, a reply, a forwarded email — where a branded card reads as
 * propaganda and gets scrolled past. A card carrying the question itself
 * reads as an argument someone is making.
 *
 * Run manually (`npm run og`) and commit the output. Deliberately not part of
 * the build: generation needs to fetch fonts, and a build that depends on the
 * network is a build that fails for reasons unrelated to the code.
 *
 *   node scripts/generate-og.mjs
 */
import { writeFile, mkdir, readFile } from 'node:fs/promises'
import { existsSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { dirname, join } from 'node:path'
import satori from 'satori'
import { Resvg } from '@resvg/resvg-js'
import { EXPERIENCES } from '../app/utils/experiences.js'
import { pageMeta } from '../app/utils/seo.js'

const HERE = dirname(fileURLToPath(import.meta.url))
const ROOT = join(HERE, '..')
const OUT = join(ROOT, 'public', 'og')
const FONTS = join(ROOT, '.fonts')

const INK = '#1E1C19'
const INK_MUTED = '#6E6A62'
const PAPER = '#F4F0EA'
const OCHRE = '#9A7B4F'

/** Satori needs real font data — it does not fall back to system fonts. */
async function font(family, weight, file) {
  const path = join(FONTS, file)
  if (!existsSync(path)) {
    await mkdir(FONTS, { recursive: true })
    // The CSS endpoint returns woff2 for modern UAs; an old UA string gets
    // TTF, which is what satori accepts.
    const css = await fetch(
      `https://fonts.googleapis.com/css2?family=${family}:wght@${weight}`,
      { headers: { 'User-Agent': 'Mozilla/4.0' } }
    ).then((r) => r.text())
    const url = css.match(/src:\s*url\(([^)]+)\)/)?.[1]
    if (!url) throw new Error(`no font URL found for ${family} ${weight}`)
    const buf = Buffer.from(await fetch(url).then((r) => r.arrayBuffer()))
    await writeFile(path, buf)
    console.log(`  fetched ${file} (${(buf.length / 1024).toFixed(0)} KB)`)
  }
  return readFile(path)
}

/**
 * The card. Deliberately close to the site: paper ground, ochre rule, the
 * question in Cormorant. It should look like the page it links to.
 */
function card({ eyebrow, headline, meta }) {
  return {
    type: 'div',
    props: {
      style: {
        width: '1200px', height: '630px', display: 'flex', flexDirection: 'column',
        justifyContent: 'center', backgroundColor: PAPER, padding: '80px 90px'
      },
      children: [
        { type: 'div', props: { style: { width: '54px', height: '3px', backgroundColor: OCHRE, marginBottom: '46px' } } },
        {
          type: 'div',
          props: {
            style: {
              fontFamily: 'Karla', fontSize: '20px', letterSpacing: '4px',
              textTransform: 'uppercase', color: OCHRE, marginBottom: '34px'
            },
            children: eyebrow
          }
        },
        {
          type: 'div',
          props: {
            style: {
              fontFamily: 'Cormorant', fontSize: headline.length > 78 ? '58px' : '70px',
              lineHeight: 1.16, color: INK, letterSpacing: '-1px',
              // Satori has no text-wrap: balance; the width does the work.
              maxWidth: '1000px', display: 'flex'
            },
            children: headline
          }
        },
        ...(meta
          ? [{
              type: 'div',
              props: {
                style: { fontFamily: 'Karla', fontSize: '24px', color: INK_MUTED, marginTop: '44px' },
                children: meta
              }
            }]
          : [])
      ]
    }
  }
}

async function render(node, fonts, file) {
  const svg = await satori(node, { width: 1200, height: 630, fonts })
  const png = new Resvg(svg, { fitTo: { mode: 'width', value: 1200 } }).render().asPng()
  await writeFile(join(OUT, file), png)
  return png.length
}

// Pages that get a hand-written line rather than their page title, because
// the title alone is a poor social card.
const OVERRIDES = {
  home: {
    headline: 'Think of someone you know who is wrong about something that matters.',
    meta: 'One minute · humanrespect.app'
  },
  about: { headline: 'Why this exists.', meta: 'humanrespect.app' },
  'your-journey': { headline: 'Fifteen experiences. None of them required.', meta: 'humanrespect.app' }
}

const MINUTES = Object.fromEntries(EXPERIENCES.map((e) => [e.id, e.minutes]))

async function main() {
  await mkdir(OUT, { recursive: true })
  const fonts = [
    { name: 'Cormorant', data: await font('Cormorant', 400, 'cormorant-400.ttf'), weight: 400, style: 'normal' },
    { name: 'Karla', data: await font('Karla', 400, 'karla-400.ttf'), weight: 400, style: 'normal' }
  ]

  let total = 0
  let n = 0

  // Driven by pageMeta so a new page cannot be added without a card — a
  // missing card is a 404 in the preview, which is worse than a generic one.
  for (const [key, meta] of Object.entries(pageMeta)) {
    const override = OVERRIDES[key] || {}
    const minutes = MINUTES[key]
    total += await render(card({
      eyebrow: 'Human Respect',
      headline: override.headline || meta.title,
      meta: override.meta || (minutes ? `${minutes} minutes` : 'humanrespect.app')
    }), fonts, `${key}.png`)
    n += 1
    console.log(`  ${key}.png — ${(override.headline || meta.title).slice(0, 54)}`)
  }

  // Fallback for anything without its own card.
  total += await render(card({
    eyebrow: 'Human Respect',
    headline: 'You live by a moral code you have never put into words.',
    meta: 'A one-minute question'
  }), fonts, 'default.png')
  n += 1

  console.log(`\n  ${n} cards, ${(total / 1024).toFixed(0)} KB total`)
}

main().catch((e) => { console.error(e); process.exit(1) })
