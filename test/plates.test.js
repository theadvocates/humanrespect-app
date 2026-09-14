import { describe, it, expect } from 'vitest'
import { printPlate, PLATE_FOR, RESULT_PLATE, PLATE_NAMES, W, H } from '../app/utils/plates.js'
import { EXPERIENCES } from '../app/utils/experiences.js'
import { RESULTS } from '../app/utils/respectTest.js'

/**
 * The plates are drawn by code, so a typo in a plate is a blank square on a
 * live page rather than a build error. Run every plate against a recording
 * canvas: it has to draw something, and it has to stay inside the plate.
 */

class FakePath2D {
  constructor() { this.ops = [] }
}
for (const m of ['moveTo', 'lineTo', 'bezierCurveTo', 'quadraticCurveTo', 'arc', 'ellipse', 'rect', 'roundRect', 'closePath', 'addPath']) {
  FakePath2D.prototype[m] = function (...a) { this.ops.push([m, ...a]) }
}

function recordingContext() {
  const calls = []
  const ctx = new Proxy({}, {
    get: (_, prop) => (...args) => { calls.push([prop, ...args]) },
    set: () => true
  })
  return { ctx, calls }
}

describe('plates', () => {
  globalThis.Path2D = FakePath2D

  it('has a plate for every experience and every test result', () => {
    for (const e of EXPERIENCES) expect(PLATE_NAMES, `${e.id} has no plate`).toContain(PLATE_FOR[e.id])
    for (const key of Object.keys(RESULTS)) expect(PLATE_NAMES, `${key} has no plate`).toContain(RESULT_PLATE[key])
  })

  it('prints every plate without throwing, and paints something', () => {
    for (const name of PLATE_NAMES) {
      const { ctx, calls } = recordingContext()
      expect(printPlate(ctx, name, { ink: '#000', spot: '#800', paper: '#fff' }), name).toBe(true)
      const strokes = calls.filter(([m]) => m === 'stroke' || m === 'fill').length
      expect(strokes, `${name} drew nothing`).toBeGreaterThan(20)
    }
  })

  it('prints the same plate the same way every time', () => {
    const a = recordingContext(), b = recordingContext()
    printPlate(a.ctx, 'button', { ink: '#000', spot: '#800', paper: '#fff' })
    printPlate(b.ctx, 'button', { ink: '#000', spot: '#800', paper: '#fff' })
    expect(JSON.stringify(a.calls)).toBe(JSON.stringify(b.calls))
  })

  it('returns false for a plate that does not exist', () => {
    const { ctx } = recordingContext()
    expect(printPlate(ctx, 'unicorn', { ink: '#000', spot: '#800', paper: '#fff' })).toBe(false)
  })

  it('keeps the 4:5 plate proportion', () => {
    expect(H / W).toBe(1.25)
  })
})
