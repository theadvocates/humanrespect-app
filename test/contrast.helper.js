import { readFileSync } from 'node:fs'

const css = readFileSync('app/styles/tokens.css', 'utf8')

/**
 * Reads a custom property out of one rule block of tokens.css.
 *
 * Anchored to the start of a line, because a naive indexOf('.dark-mode {')
 * matches inside `body.dark-mode {` — a different block, four lines earlier,
 * that declares no custom properties at all.
 */
export function token(name, scope = ':root') {
  const marker = `\n${scope} {`
  const start = css.startsWith(`${scope} {`) ? 0 : css.indexOf(marker)
  if (start === -1) throw new Error(`no ${scope} block in tokens.css`)

  const block = css.slice(start, css.indexOf('}', start))
  const value = block.match(new RegExp(`${name}:\\s*([^;]+);`))?.[1].trim()
  if (!value) throw new Error(`${name} not found in ${scope}`)

  // A remapped token points at another one, which is defined on :root.
  return value.startsWith('var(') ? token(value.slice(4, -1).trim(), ':root') : value
}

/** WCAG 2.1 relative-luminance contrast ratio. */
export function ratio(fg, bg) {
  const channels = (h) => h.replace('#', '').match(/../g).map((x) => parseInt(x, 16) / 255)
  const linear = (c) => (c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4)
  const lum = (h) => {
    const [r, g, b] = channels(h).map(linear)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b
  }
  const [a, b] = [lum(fg), lum(bg)]
  return (Math.max(a, b) + 0.05) / (Math.min(a, b) + 0.05)
}
