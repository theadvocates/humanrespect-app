/**
 * The plates: one engraved illustration per experience, drawn by code.
 *
 * There are no image files. A plate is a small drawing program run against a
 * canvas: a few shapes, then hatching, cross-hatching and stippling laid over
 * them the way an engraver works, with a little wobble from a seeded random
 * so the lines are never mechanically straight. The ochre goes down as a
 * second colour, slightly out of register, like a two-colour letterpress job.
 *
 * Everything is drawn in plate units, 100 wide by 125 tall, and scaled to
 * whatever size the canvas is. Ink, spot colour and paper come from CSS
 * custom properties, so the same plate prints in light ink on the dark
 * opening screens. <Plate> is the component that runs this.
 */

/* Engraving engine. A plate is 100 units wide and 125 tall; everything is
   drawn in those units and scaled to the canvas. Shapes are Path2D; the
   engraver's marks (hatching, cross-hatching, stippling) are laid over them
   with a little wobble from a seeded random, so a plate is the same every
   time it is printed but never mechanically perfect. */
export const W = 100, H = 125
const lerp = (a, b, t) => a + (b - a) * t
function makeRand(seed) {
  let s = seed >>> 0
  return () => { s = (s * 1664525 + 1013904223) >>> 0; return s / 4294967296 }
}

function engine(ctx, colors, rand) {
  const E = { ink: colors.ink, spot: colors.spot, paper: colors.paper, rand, ctx, W, H }

  E.ellipse = (cx, cy, rx, ry, rot = 0) => { const p = new Path2D(); p.ellipse(cx, cy, rx, ry, rot, 0, Math.PI * 2); return p }
  E.circle = (cx, cy, r) => E.ellipse(cx, cy, r, r)
  E.rect = (x, y, w, h, r = 0) => { const p = new Path2D(); if (r) p.roundRect(x, y, w, h, r); else p.rect(x, y, w, h); return p }
  E.poly = (pts, close = true) => { const p = new Path2D(); pts.forEach(([x, y], i) => (i ? p.lineTo(x, y) : p.moveTo(x, y))); if (close) p.closePath(); return p }
  // A smooth curve through points (Catmull-Rom as cubic Béziers).
  E.curve = (pts, close = true, t = 1) => {
    const p = new Path2D(), n = pts.length
    const P = (i) => pts[close ? ((i % n) + n) % n : Math.max(0, Math.min(n - 1, i))]
    p.moveTo(pts[0][0], pts[0][1])
    const segs = close ? n : n - 1
    for (let i = 0; i < segs; i++) {
      const [x0, y0] = P(i - 1), [x1, y1] = P(i), [x2, y2] = P(i + 1), [x3, y3] = P(i + 2)
      p.bezierCurveTo(x1 + (x2 - x0) / 6 * t, y1 + (y2 - y0) / 6 * t, x2 - (x3 - x1) / 6 * t, y2 - (y3 - y1) / 6 * t, x2, y2)
    }
    if (close) p.closePath()
    return p
  }
  E.union = (...paths) => { const p = new Path2D(); paths.forEach((q) => p.addPath(q)); return p }
  // A cylinder standing on its base: top ellipse, straight sides, and the
  // visible lower arc. Returns the pieces so they can be shaded separately.
  E.cylinder = (cx, top, rx, ry, h) => {
    const side = new Path2D()
    side.moveTo(cx + rx, top); side.lineTo(cx + rx, top + h)
    side.ellipse(cx, top + h, rx, ry, 0, 0, Math.PI, false)
    side.lineTo(cx - rx, top); side.ellipse(cx, top, rx, ry, 0, Math.PI, 0, true)
    side.closePath()
    return { side, top: E.ellipse(cx, top, rx, ry), bottomArc: (() => { const a = new Path2D(); a.ellipse(cx, top + h, rx, ry, 0, 0, Math.PI, false); return a })() }
  }

  E.stroke = (p, o = {}) => {
    const { w = 0.7, color = E.ink, alpha = 1, dash } = o
    ctx.save(); ctx.strokeStyle = color; ctx.globalAlpha = alpha; ctx.lineWidth = w
    if (dash) ctx.setLineDash(dash)
    ctx.stroke(p); ctx.restore()
  }
  E.fill = (p, color = E.ink, alpha = 1, rule = 'nonzero') => { ctx.save(); ctx.fillStyle = color; ctx.globalAlpha = alpha; ctx.fill(p, rule); ctx.restore() }
  E.clip = (p, fn, rule = 'nonzero') => { ctx.save(); ctx.clip(p, rule); fn(); ctx.restore() }
  E.rotated = (cx, cy, deg, fn) => { ctx.save(); ctx.translate(cx, cy); ctx.rotate(deg * Math.PI / 180); ctx.translate(-cx, -cy); fn(); ctx.restore() }

  // A hand-drawn line: the path wobbles a little along its length.
  E.line = (x1, y1, x2, y2, o = {}) => {
    const { w = 0.7, color = E.ink, alpha = 1, jitter = 0.14 } = o
    const p = new Path2D(), segs = 6
    for (let s = 0; s <= segs; s++) {
      const t = s / segs, j = (s === 0 || s === segs) ? 0 : (rand() - 0.5) * 2 * jitter
      const x = lerp(x1, x2, t), y = lerp(y1, y2, t)
      const nx = -(y2 - y1), ny = x2 - x1, len = Math.hypot(nx, ny) || 1
      s ? p.lineTo(x + nx / len * j, y + ny / len * j) : p.moveTo(x, y)
    }
    E.stroke(p, { w, color, alpha })
  }
  // A double line: two parallel strokes, for legs, posts, cords.
  E.double = (x1, y1, x2, y2, o = {}) => {
    const { w = 1.8, color = E.ink } = o
    E.line(x1, y1, x2, y2, { w, color, jitter: 0.08 })
    E.line(x1, y1, x2, y2, { w: w - 1.1, color: E.paper, jitter: 0.08 })
  }

  /* Hatching. Parallel lines at `angle`, `gap` apart, clipped to the shape.
     `grad` = [gapAtStart, gapAtEnd] multiplies the gap across the region's
     normal axis, which is how a plane gets darker toward its shadow side.
     `bend` bows every line, which turns a flat hatch into a rounded one. */
  E.hatch = (p, o = {}) => {
    const { angle = -45, gap = 1.5, w = 0.42, color = E.ink, alpha = 1, grad = null, region = [0, 0, W, H], bend = 0, jitter = 0.12, rule = 'nonzero' } = o
    ctx.save(); ctx.clip(p, rule); ctx.strokeStyle = color; ctx.globalAlpha = alpha; ctx.lineWidth = w
    const a = angle * Math.PI / 180, dx = Math.cos(a), dy = Math.sin(a), nx = -dy, ny = dx
    const [rx, ry, rw, rh] = region, cx = rx + rw / 2, cy = ry + rh / 2
    const R = Math.hypot(rw, rh) / 2, segs = 10
    for (let d = -R; d <= R;) {
      const t = (d + R) / (2 * R)
      ctx.beginPath()
      for (let s = 0; s <= segs; s++) {
        const u = -R + 2 * R * s / segs
        const j = (rand() - 0.5) * 2 * jitter + bend * Math.sin(Math.PI * s / segs)
        const x = cx + nx * (d + j) + dx * u, y = cy + ny * (d + j) + dy * u
        s ? ctx.lineTo(x, y) : ctx.moveTo(x, y)
      }
      ctx.stroke()
      d += grad ? gap * lerp(grad[0], grad[1], t) : gap
    }
    ctx.restore()
  }
  E.cross = (p, o = {}) => { E.hatch(p, o); E.hatch(p, { ...o, angle: (o.angle ?? -45) + 65 }) }

  // Stippling: dots scattered inside the shape. `density(x, y)` in 0..1 thins
  // them out where the paper should show through.
  E.stipple = (p, o = {}) => {
    const { n = 500, r = 0.32, color = E.ink, alpha = 0.9, region = [0, 0, W, H], density = null, rule = 'nonzero' } = o
    ctx.save(); ctx.clip(p, rule); ctx.fillStyle = color; ctx.globalAlpha = alpha
    const [rx, ry, rw, rh] = region
    for (let i = 0; i < n; i++) {
      const x = rx + rand() * rw, y = ry + rand() * rh
      if (density && rand() > density(x, y)) continue
      ctx.beginPath(); ctx.arc(x, y, r * (0.7 + rand() * 0.6), 0, Math.PI * 2); ctx.fill()
    }
    ctx.restore()
  }
  // The second colour, laid down slightly out of register.
  E.tint = (p, o = {}) => {
    const { color = E.spot, alpha = 0.3, offset = [0.55, 0.4], rule = 'nonzero' } = o
    ctx.save(); ctx.translate(offset[0], offset[1]); ctx.fillStyle = color; ctx.globalAlpha = alpha; ctx.fill(p, rule); ctx.restore()
  }
  // A soft cast shadow on the ground under an object.
  E.shadow = (cx, cy, rx, ry, o = {}) => {
    const s = E.ellipse(cx, cy, rx, ry)
    E.hatch(s, { angle: 0, gap: 1.1, w: 0.35, alpha: 0.55, grad: [0.8, 1.6], region: [cx - rx, cy - ry, rx * 2, ry * 2], ...o })
  }
  return E
}


const PLATES = {}
/* ── The plates ─────────────────────────────────────────────────────────── */

// A push-button on its housing. Shared by "The button" and "The loophole".
function pushButton(E, cx, base, o = {}) {
  const { rx = 14, ry = 5, h = 8, cap = 9, capH = 6 } = o
  const housing = E.cylinder(cx, base - h, rx, ry, h)
  E.fill(housing.side, E.paper); E.fill(housing.top, E.paper)
  E.hatch(housing.side, { angle: 90, gap: 1.25, grad: [1.8, 0.75], bend: 0.6, region: [cx - rx, base - h - ry, rx * 2, h + ry * 2] })
  E.hatch(housing.top, { angle: -10, gap: 1.6, alpha: 0.45, region: [cx - rx, base - h - ry, rx * 2, ry * 2] })
  E.stroke(housing.side, { w: 0.7 }); E.stroke(housing.top, { w: 0.7 })
  const capRy = ry * cap / rx
  const capc = E.cylinder(cx, base - h - capH, cap, capRy, capH)
  E.fill(capc.side, E.paper); E.fill(capc.top, E.paper)
  E.tint(capc.side, { alpha: 0.42 }); E.tint(capc.top, { alpha: 0.3 })
  E.hatch(capc.side, { angle: 90, gap: 1.1, grad: [2.2, 0.7], bend: 0.5, color: E.spot, alpha: 0.9, region: [cx - cap, base - h - capH - capRy, cap * 2, capH + capRy * 2] })
  E.hatch(capc.top, { angle: -30, gap: 1.5, alpha: 0.5, color: E.spot, grad: [2.2, 0.9], region: [cx - cap, base - h - capH - capRy, cap * 2, capRy * 2] })
  E.stroke(capc.side, { w: 0.65 }); E.stroke(capc.top, { w: 0.65 })
}

PLATES.button = (E) => {
  // The pedestal, and the shadow it throws.
  E.shadow(56, 108, 44, 5)
  const base = E.cylinder(50, 100, 36, 7, 6)
  E.fill(base.side, E.paper)
  E.hatch(base.side, { angle: 90, gap: 1.2, grad: [1.9, 0.7], bend: 0.5, region: [14, 93, 72, 20] })
  E.fill(base.top, E.paper)
  E.hatch(base.top, { angle: -6, gap: 1.7, alpha: 0.4, region: [14, 93, 72, 14] })
  E.stroke(base.side); E.stroke(base.top)
  // The button under the glass.
  E.shadow(57, 100, 17, 4, { alpha: 0.5, gap: 0.95 })
  pushButton(E, 50, 100)
  // The bell jar: an outline, a few reflections on the left, a breath of
  // shadow on the right, and a knob on top.
  const dome = new Path2D()
  dome.moveTo(20, 100); dome.lineTo(20, 52); dome.ellipse(50, 52, 30, 26, 0, Math.PI, Math.PI * 2, false); dome.lineTo(80, 100); dome.closePath()
  E.hatch(dome, { angle: 90, gap: 2.6, w: 0.32, alpha: 0.32, bend: 1.2, grad: [3.2, 0.9], region: [58, 26, 24, 74] })
  E.clip(E.rect(20, 26, 22, 74), () => {
    for (const k of [0.9, 0.82]) {
      E.ctx.save(); E.ctx.translate(50, 76); E.ctx.scale(k, k); E.ctx.translate(-50, -76)
      E.stroke(dome, { w: 0.45 / k, alpha: 0.5 })
      E.ctx.restore()
    }
  })
  E.stroke(dome, { w: 0.8 })
  E.stroke(E.ellipse(50, 100, 30, 6), { w: 0.6, alpha: 0.8 })
  E.line(48, 27.5, 52, 27.5, { w: 0.6 })
  const knob = E.circle(50, 24, 3.4)
  E.fill(knob, E.paper); E.hatch(knob, { angle: 45, gap: 0.9, grad: [3, 0.6], region: [46.6, 20.6, 6.8, 6.8] }); E.stroke(knob, { w: 0.6 })
}

PLATES.cord = (E) => {
  E.shadow(52, 105, 32, 4.5)
  const base = E.cylinder(46, 98, 26, 5.5, 5)
  E.fill(base.side, E.paper)
  E.hatch(base.side, { angle: 90, gap: 1.2, grad: [1.9, 0.7], bend: 0.4, region: [20, 92.5, 52, 16] })
  E.fill(base.top, E.paper); E.hatch(base.top, { angle: -6, gap: 1.7, alpha: 0.4, region: [20, 92.5, 52, 11] })
  E.stroke(base.side); E.stroke(base.top)
  pushButton(E, 46, 98, { rx: 15, ry: 5.2, h: 9, cap: 9.5, capH: 6.5 })
  // The cord leaves the housing and runs out of the picture.
  const pts = [[60, 95], [74, 104], [90, 92], [88, 76], [86, 62], [70, 66], [74, 54], [78, 42], [96, 46], [106, 36]]
  const cord = new Path2D()
  cord.moveTo(...pts[0])
  for (let i = 1; i < pts.length; i += 3) cord.bezierCurveTo(...pts[i], ...pts[i + 1], ...pts[i + 2])
  E.stroke(cord, { w: 2.1 }); E.stroke(cord, { w: 0.9, color: E.paper })
  // A twist every so often.
  for (let t = 0.06; t < 0.98; t += 0.07) {
    const P = bezPt(pts, t)
    E.line(P[0] - 0.9, P[1] - 0.9, P[0] + 0.9, P[1] + 0.9, { w: 0.5, alpha: 0.9 })
  }
}
// A point on a chain of cubic Béziers, for decorating the cord.
function bezPt(pts, t) {
  const segs = (pts.length - 1) / 3, i = Math.min(Math.floor(t * segs), segs - 1), u = t * segs - i
  const [p0, p1, p2, p3] = pts.slice(i * 3, i * 3 + 4)
  const f = (k) => (1 - u) ** 3 * p0[k] + 3 * (1 - u) ** 2 * u * p1[k] + 3 * (1 - u) * u * u * p2[k] + u ** 3 * p3[k]
  return [f(0), f(1)]
}

PLATES.chairs = (E) => {
  // The scene is small at its natural size; print it a little larger.
  E.ctx.translate(50, 104); E.ctx.scale(1.22, 1.22); E.ctx.translate(-50, -104)
  const floor = 100
  E.line(8, floor, 92, floor, { w: 0.5, alpha: 0.7 })
  E.stipple(E.rect(8, floor + 1, 84, 6), { n: 260, r: 0.28, alpha: 0.5, density: (x, y) => 1 - (y - floor) / 7 })
  function chair(x, dir) {
    // dir = 1 faces right, -1 faces left. Side view: back post, seat, legs.
    const bx = x, sx = x + dir * 18
    E.double(bx, 50, bx, floor, { w: 2 })
    E.line(bx - dir * 1.2, 50, bx + dir * 1.2, 50, { w: 1.2 })
    const seat = E.poly([[bx, 76], [sx, 76], [sx, 78.4], [bx, 78.4]])
    E.fill(seat, E.paper); E.tint(seat, { alpha: 0.35 }); E.hatch(seat, { angle: -40, gap: 0.9, alpha: 0.7, region: [Math.min(bx, sx), 76, 18, 2.4] }); E.stroke(seat, { w: 0.6 })
    E.double(sx - dir * 1, 78.4, sx - dir * 1, floor, { w: 1.8 })
    E.line(bx + dir * 2, 90, sx - dir * 1, 90, { w: 0.6, alpha: 0.8 })
    // Back rails.
    E.line(bx, 56, bx - dir * 0.2, 56, { w: 0.5 })
    for (const y of [58, 66]) E.line(bx - dir * 2.2, y, bx + dir * 0.2, y, { w: 0.8, alpha: 0.9 })
  }
  chair(16, 1); chair(84, -1)
  // The table, and two cups on it.
  const top = E.poly([[38, 70], [62, 70], [62, 72.4], [38, 72.4]])
  E.fill(top, E.paper); E.hatch(top, { angle: -40, gap: 0.9, alpha: 0.6, region: [38, 70, 24, 2.4] }); E.stroke(top, { w: 0.65 })
  E.double(41, 72.4, 41, floor, { w: 1.9 }); E.double(59, 72.4, 59, floor, { w: 1.9 })
  E.line(41, 88, 59, 88, { w: 0.6, alpha: 0.8 })
  for (const cx of [45.5, 54.5]) {
    const cup = E.rect(cx - 2.6, 65, 5.2, 5, 0.8)
    E.fill(cup, E.paper); E.tint(cup, { alpha: 0.45 }); E.hatch(cup, { angle: 90, gap: 0.8, grad: [2.2, 0.7], color: E.spot, region: [cx - 2.6, 65, 5.2, 5] }); E.stroke(cup, { w: 0.55 })
    const h = new Path2D(); h.arc(cx + 2.6, 67.4, 1.5, -Math.PI / 2, Math.PI / 2); E.stroke(h, { w: 0.55 })
    E.stroke(E.ellipse(cx, 65, 2.6, 0.8), { w: 0.45 })
  }
}

PLATES.tomato = (E) => {
  E.shadow(54, 100, 27, 4.2)
  const pts = []
  for (let k = 0; k < 14; k++) {
    const a = (k / 14) * Math.PI * 2, r = 26 + 1.7 * Math.cos(3 * a + 0.4)
    pts.push([50 + r * Math.cos(a), 72 + r * Math.sin(a) * 0.9])
  }
  const body = E.curve(pts, true, 1)
  const gloss = E.ellipse(40, 59, 7.5, 4.6, -0.55)
  const shaded = E.union(body, gloss)
  E.fill(body, E.paper)
  E.tint(body, { alpha: 0.3 })
  E.hatch(shaded, { angle: -52, gap: 1.35, grad: [2.3, 0.85], bend: 1.4, region: [24, 46, 52, 50], rule: 'evenodd' })
  E.clip(body, () => E.hatch(E.ellipse(60, 82, 21, 15, 0.5), { angle: 25, gap: 1.2, w: 0.4, grad: [2.4, 0.9], bend: 1, region: [39, 67, 42, 30] }))
  E.stroke(body, { w: 0.8 })
  // Calyx and stem.
  for (let k = 0; k < 5; k++) {
    const a = -Math.PI / 2 + (k - 2) * 0.62, L = 11 + (k % 2) * 2
    const c = [50, 48], tip = [c[0] + L * Math.cos(a), c[1] + L * Math.sin(a) * 0.75 + 3]
    const mx = (c[0] + tip[0]) / 2, my = (c[1] + tip[1]) / 2, nx = -Math.sin(a) * 2.1, ny = Math.cos(a) * 2.1
    const leaf = E.curve([c, [mx + nx, my + ny], tip, [mx - nx, my - ny]], true, 1)
    E.fill(leaf, E.paper); E.hatch(leaf, { angle: a * 180 / Math.PI + 70, gap: 0.8, alpha: 0.55, region: [Math.min(c[0], tip[0]) - 3, Math.min(c[1], tip[1]) - 3, 20, 20] }); E.stroke(leaf, { w: 0.55 })
  }
  const stem = new Path2D(); stem.moveTo(50, 49); stem.bezierCurveTo(50, 45, 52, 43, 51.5, 39)
  E.stroke(stem, { w: 2 }); E.stroke(stem, { w: 0.8, color: E.paper })
}

PLATES.hourglass = (E) => {
  // Glass first, so the frame's posts can sit in front of it.
  const glass = new Path2D()
  glass.moveTo(31, 24); glass.lineTo(69, 24); glass.bezierCurveTo(70, 46, 52, 55, 52, 61); glass.lineTo(52, 65)
  glass.bezierCurveTo(52, 71, 70, 80, 69, 102); glass.lineTo(31, 102); glass.bezierCurveTo(30, 80, 48, 71, 48, 65); glass.lineTo(48, 61)
  glass.bezierCurveTo(48, 55, 30, 46, 31, 24); glass.closePath()
  E.hatch(glass, { angle: 90, gap: 2.2, w: 0.3, alpha: 0.3, bend: 0.8, grad: [3.4, 0.9], region: [52, 24, 18, 78] })
  // Sand: what has run through, what is left, and the thread between.
  const heap = new Path2D(); heap.moveTo(32, 101); heap.bezierCurveTo(40, 101, 46, 85, 50, 84.5); heap.bezierCurveTo(54, 85, 60, 101, 68, 101); heap.closePath()
  E.tint(heap, { alpha: 0.35 }); E.stipple(heap, { n: 1400, r: 0.3, alpha: 0.8, region: [32, 84, 36, 18], density: (x, y) => 0.35 + (y - 84) / 20 })
  const left = new Path2D(); left.moveTo(40.5, 44); left.bezierCurveTo(44, 50, 56, 50, 59.5, 44); left.bezierCurveTo(57, 52, 52.5, 56, 52, 61); left.lineTo(48, 61); left.bezierCurveTo(47.5, 56, 43, 52, 40.5, 44); left.closePath()
  E.tint(left, { alpha: 0.35 }); E.stipple(left, { n: 600, r: 0.28, alpha: 0.8, region: [40, 44, 20, 18] })
  E.stipple(E.rect(49.3, 61, 1.4, 25), { n: 260, r: 0.22, alpha: 0.75, region: [49.3, 61, 1.4, 25] })
  E.stroke(glass, { w: 0.75 })
  // Reflections.
  E.clip(E.rect(31, 24, 12, 78), () => {
    E.ctx.save(); E.ctx.translate(50, 63); E.ctx.scale(0.86, 0.9); E.ctx.translate(-50, -63); E.stroke(glass, { w: 0.5, alpha: 0.45 }); E.ctx.restore()
  })
  // The frame: two plates and three turned posts.
  for (const y of [18, 103]) {
    const plate = E.cylinder(50, y, 24, 3.2, 4.5)
    E.fill(plate.side, E.paper); E.fill(plate.top, E.paper)
    E.hatch(plate.side, { angle: 90, gap: 1, grad: [1.9, 0.7], bend: 0.4, region: [26, y - 3.2, 48, 11] })
    E.hatch(plate.top, { angle: -6, gap: 1.4, alpha: 0.45, region: [26, y - 3.2, 48, 6.4] })
    E.stroke(plate.side, { w: 0.65 }); E.stroke(plate.top, { w: 0.65 })
  }
  E.double(50, 22.5, 50, 103, { w: 1.6 })
  for (const x of [29.5, 70.5]) { E.double(x, 22.5, x, 103, { w: 2.2 }); for (const y of [40, 63, 86]) E.stroke(E.ellipse(x, y, 1.6, 0.9), { w: 0.5 }) }
  E.shadow(54, 111, 30, 3.2)
}

PLATES.beehive = (E) => {
  E.shadow(54, 103, 40, 3.6)
  const board = E.rect(14, 96, 72, 3)
  E.fill(board, E.paper); E.hatch(board, { angle: 0, gap: 0.9, alpha: 0.6, region: [14, 96, 72, 3] }); E.stroke(board, { w: 0.6 })
  const rings = [[89, 31], [76, 30], [63, 27], [50, 22], [38, 15]]
  for (const [y, rx] of rings) {
    const ring = E.rect(50 - rx, y - 7, rx * 2, 14, 7)
    E.fill(ring, E.paper); E.tint(ring, { alpha: 0.16 })
    E.hatch(ring, { angle: 90, gap: 1.25, grad: [2, 0.7], bend: 1.2, region: [50 - rx, y - 7, rx * 2, 14] })
    E.hatch(ring, { angle: 0, gap: 3.4, w: 0.3, alpha: 0.45, region: [50 - rx, y - 7, rx * 2, 14] })
    E.stroke(ring, { w: 0.7 })
  }
  const knob = E.rect(46, 26, 8, 8, 4)
  E.fill(knob, E.paper); E.hatch(knob, { angle: 45, gap: 0.9, grad: [3, 0.6], region: [46, 26, 8, 8] }); E.stroke(knob, { w: 0.6 })
  const door = new Path2D(); door.moveTo(45, 96); door.lineTo(45, 89); door.arc(50, 89, 5, Math.PI, 0); door.lineTo(55, 96); door.closePath()
  E.fill(door, E.paper); E.cross(door, { angle: -45, gap: 0.8, w: 0.45 }); E.stroke(door, { w: 0.6 })
  // Bees, and where they have been.
  for (const [x, y, a] of [[80, 42, -0.4], [22, 58, 0.5], [76, 72, 0.2]]) {
    const flight = new Path2D(); flight.moveTo(x - 12 * Math.cos(a), y + 14); flight.quadraticCurveTo(x - 6, y + 2, x - 1.5, y + 0.5)
    E.stroke(flight, { w: 0.35, alpha: 0.6, dash: [0.8, 1.2] })
    E.rotated(x, y, a * 57, () => {
      const b = E.ellipse(x, y, 2.3, 1.4)
      E.fill(b, E.paper); E.tint(b, { alpha: 0.5, offset: [0.2, 0.15] }); E.stroke(b, { w: 0.5 })
      for (const dx of [-0.8, 0.4]) E.line(x + dx, y - 1.3, x + dx, y + 1.3, { w: 0.55 })
      E.stroke(E.ellipse(x - 0.6, y - 2.2, 1.6, 0.9, -0.5), { w: 0.4 }); E.stroke(E.ellipse(x + 0.8, y - 2.2, 1.6, 0.9, 0.5), { w: 0.4 })
    })
  }
}

PLATES.balance = (E) => {
  E.shadow(54, 106, 20, 3)
  const foot = E.poly([[36, 103], [64, 103], [60, 97], [40, 97]])
  E.fill(foot, E.paper); E.hatch(foot, { angle: -45, gap: 1.1, grad: [1.8, 0.8], region: [36, 97, 28, 6] }); E.stroke(foot, { w: 0.65 })
  E.double(50, 97, 50, 48, { w: 2.6 })
  for (const y of [58, 80]) E.stroke(E.ellipse(50, y, 1.9, 0.9), { w: 0.5 })
  // The beam, tipped a little: the left pan carries the weight.
  const tilt = -6
  E.rotated(50, 46, tilt, () => {
    const beam = E.rect(18, 44.6, 64, 2.6, 1.2)
    E.fill(beam, E.paper); E.hatch(beam, { angle: 0, gap: 0.8, alpha: 0.6, region: [18, 44.6, 64, 2.6] }); E.stroke(beam, { w: 0.6 })
    for (const x of [19, 81]) E.stroke(E.circle(x, 46, 1.4), { w: 0.55 })
  })
  const c = Math.cos(tilt * Math.PI / 180), s = Math.sin(tilt * Math.PI / 180)
  const end = (x) => [50 + (x - 50) * c, 46 + (x - 50) * s]
  E.line(50, 46, 50, 38, { w: 0.9 }); E.line(47, 38, 53, 38, { w: 0.7 })
  E.fill(E.circle(50, 46, 1.8), E.ink)
  const pan = (cx, cy, load) => {
    const [ex, ey] = end(cx < 50 ? 19 : 81)
    for (const dx of [-13, 13]) E.line(ex, ey, cx + dx, cy, { w: 0.45, alpha: 0.85 })
    const dish = new Path2D(); dish.moveTo(cx - 14, cy); dish.quadraticCurveTo(cx, cy + 9, cx + 14, cy); dish.closePath()
    E.fill(dish, E.paper); E.hatch(dish, { angle: 0, gap: 0.9, grad: [0.8, 1.8], bend: 0.3, region: [cx - 14, cy, 28, 5] }); E.stroke(dish, { w: 0.7 })
    E.stroke(E.ellipse(cx, cy, 14, 2.2), { w: 0.55 })
    if (load) for (let i = 0; i < 3; i++) {
      const coin = E.ellipse(cx + i * 0.6, cy - 1.6 - i * 1.7, 5, 1.6)
      E.fill(coin, E.paper); E.tint(coin, { alpha: 0.5 }); E.stroke(coin, { w: 0.5 })
    }
  }
  const [lx, ly] = end(19), [rx, ry] = end(81)
  pan(lx, ly + 26, true); pan(rx, ry + 26, false)
}

PLATES.seedling = (E) => {
  E.shadow(54, 107, 22, 3.4)
  const pot = E.poly([[35, 79], [65, 79], [61, 104], [39, 104]])
  E.fill(pot, E.paper); E.tint(pot, { alpha: 0.3 })
  E.hatch(pot, { angle: 90, gap: 1.2, grad: [2, 0.7], bend: 0.8, region: [35, 79, 30, 25] }); E.stroke(pot, { w: 0.7 })
  const rim = E.cylinder(50, 75, 17, 2.8, 4.5)
  E.fill(rim.side, E.paper); E.tint(rim.side, { alpha: 0.3 }); E.hatch(rim.side, { angle: 90, gap: 1.1, grad: [2, 0.7], bend: 0.5, region: [33, 72, 34, 10] }); E.stroke(rim.side, { w: 0.7 })
  E.fill(rim.top, E.paper); E.stroke(rim.top, { w: 0.6 })
  E.stipple(E.ellipse(50, 75, 15.5, 2.2), { n: 500, r: 0.28, alpha: 0.85, region: [34, 72.5, 32, 5] })
  const stem = new Path2D(); stem.moveTo(50, 75); stem.bezierCurveTo(49, 66, 49.5, 58, 50, 52); stem.bezierCurveTo(50.5, 46, 52, 42, 52, 38)
  E.stroke(stem, { w: 1.5 }); E.stroke(stem, { w: 0.5, color: E.paper })
  const leaf = (pts, angle) => {
    const p = E.curve(pts, true, 1)
    E.fill(p, E.paper); E.hatch(p, { angle, gap: 0.85, alpha: 0.6, grad: [1.6, 0.8], region: [Math.min(...pts.map((q) => q[0])), Math.min(...pts.map((q) => q[1])), 20, 14] }); E.stroke(p, { w: 0.6 })
    E.line(pts[0][0], pts[0][1], pts[2][0], pts[2][1], { w: 0.4, alpha: 0.7 })
  }
  leaf([[49.6, 60], [40, 55], [33, 60], [40, 65]], 20)
  leaf([[50.2, 58], [59, 52], [67, 56], [60, 62]], -20)
  leaf([[52, 40], [56, 31], [63, 33], [58, 43]], -40)
}

PLATES.crown = (E) => {
  // The cushion, with a tassel at each corner.
  const cushion = E.curve([[50, 68], [86, 82], [50, 98], [14, 82]], true, 1)
  E.fill(cushion, E.paper); E.tint(cushion, { alpha: 0.22 })
  E.hatch(cushion, { angle: 15, gap: 1.3, grad: [1.5, 0.9], bend: 0.6, region: [14, 68, 72, 30] })
  E.stroke(cushion, { w: 0.7 })
  for (const [x, y] of [[50, 68], [86, 82], [50, 98], [14, 82]]) for (let k = -1; k <= 1; k++) E.line(x, y, x + k * 1.6, y + 3.2, { w: 0.5 })
  // The crown: a band, five points, a rim to show it is round.
  const band = E.rect(28, 58, 44, 11)
  E.fill(band, E.paper); E.cross(band, { angle: -45, gap: 1.05, w: 0.4, alpha: 0.9, region: [28, 58, 44, 11] })
  E.stroke(band, { w: 0.7 })
  E.stroke(E.ellipse(50, 69, 22, 3.6), { w: 0.55, alpha: 0.9 })
  for (const [x, top] of [[30, 43], [40, 39], [50, 34], [60, 39], [70, 43]]) {
    const pt = E.poly([[x - 5.5, 58.4], [x, top], [x + 5.5, 58.4]])
    E.fill(pt, E.paper); E.hatch(pt, { angle: -65, gap: 1, grad: [2.2, 0.8], region: [x - 5.5, top, 11, 25] }); E.stroke(pt, { w: 0.65 })
    const orb = E.circle(x, top - 1.6, 1.7)
    E.fill(orb, E.paper); E.tint(orb, { alpha: 0.55, offset: [0.25, 0.2] }); E.stroke(orb, { w: 0.5 })
  }
  for (const x of [37, 50, 63]) {
    const jewel = E.ellipse(x, 63.5, 2.4, 2.9)
    E.fill(jewel, E.paper); E.tint(jewel, { alpha: 0.6, offset: [0.3, 0.25] }); E.stroke(jewel, { w: 0.55 })
    E.line(x - 1, 62.2, x - 0.2, 61.5, { w: 0.45, color: E.paper })
  }
}

PLATES.door = (E) => {
  const arch = (x0, y0, x1, ry) => {
    const p = new Path2D(), cx = (x0 + x1) / 2, rx = (x1 - x0) / 2
    p.moveTo(x0, 104); p.lineTo(x0, y0); p.ellipse(cx, y0, rx, ry, 0, Math.PI, Math.PI * 2, false); p.lineTo(x1, 104); p.closePath()
    return p
  }
  // The wall around it, stippled so the door is the only clean thing.
  const wall = E.rect(10, 22, 80, 82), outer = arch(27, 52, 73, 22)
  E.stipple(E.union(wall, outer), { n: 2600, r: 0.26, alpha: 0.55, region: [10, 22, 80, 82], rule: 'evenodd', density: (x, y) => 0.25 + Math.abs(x - 50) / 80 + (y - 22) / 240 })
  // Frame and door.
  const frame = arch(27, 52, 73, 22), door = arch(30.5, 53, 69.5, 19.5)
  E.fill(frame, E.paper); E.hatch(frame, { angle: 90, gap: 0.9, grad: [1.4, 1.4], alpha: 0.7, region: [27, 30, 46, 74] }); E.stroke(frame, { w: 0.8 })
  E.fill(door, E.paper); E.tint(door, { alpha: 0.2 })
  E.hatch(door, { angle: 90, gap: 1.6, w: 0.35, alpha: 0.5, grad: [1.6, 0.9], region: [30.5, 33.5, 39, 70.5] })
  E.clip(door, () => { for (let x = 37; x < 69; x += 6.5) E.line(x, 30, x, 104, { w: 0.6, alpha: 0.85 }) })
  E.stroke(door, { w: 0.75 })
  for (const y of [60, 84]) {
    const ledge = E.rect(31, y, 38, 3.4)
    E.fill(ledge, E.paper); E.tint(ledge, { alpha: 0.45 }); E.hatch(ledge, { angle: 0, gap: 0.8, alpha: 0.6, color: E.spot, region: [31, y, 38, 3.4] }); E.stroke(ledge, { w: 0.6 })
    for (const x of [34, 50, 66]) E.fill(E.circle(x, y + 1.7, 0.55), E.ink)
  }
  // The knocker: you knock, you do not break in.
  E.fill(E.circle(50, 71.5, 1.9), E.ink)
  const ring = E.circle(50, 76, 4.4)
  E.stroke(ring, { w: 1.7 }); E.stroke(ring, { w: 0.5, color: E.paper, alpha: 0.8 })
  // Keyhole plate.
  const plate = E.rect(58.5, 88, 4.4, 7.5, 1.2)
  E.fill(plate, E.paper); E.tint(plate, { alpha: 0.4 }); E.stroke(plate, { w: 0.5 })
  E.fill(E.circle(60.7, 90.6, 1.05), E.ink); E.fill(E.poly([[60, 91], [61.4, 91], [61.9, 94], [59.5, 94]]), E.ink)
  const step = E.rect(23, 104, 54, 4)
  E.fill(step, E.paper); E.hatch(step, { angle: 0, gap: 0.9, alpha: 0.6, grad: [0.9, 1.6], region: [23, 104, 54, 4] }); E.stroke(step, { w: 0.65 })
}

PLATES.chair = (E) => {
  E.stipple(E.ellipse(50, 106, 30, 3.4), { n: 500, r: 0.28, alpha: 0.5, region: [20, 102, 60, 8] })
  // Back: posts, rails, spindles.
  E.double(35.5, 30, 34.5, 78, { w: 2.2 }); E.double(64.5, 30, 65.5, 78, { w: 2.2 })
  for (const x of [35.5, 64.5]) { const f = E.circle(x, 29, 1.6); E.fill(f, E.paper); E.stroke(f, { w: 0.55 }) }
  const rail = E.rect(35, 33, 30, 3.4, 0.8)
  E.fill(rail, E.paper); E.tint(rail, { alpha: 0.32 }); E.hatch(rail, { angle: 0, gap: 0.85, alpha: 0.6, region: [35, 33, 30, 3.4] }); E.stroke(rail, { w: 0.6 })
  for (const x of [43, 50, 57]) E.double(x, 36.4, x, 61, { w: 1.7 })
  const rail2 = E.rect(35, 61, 30, 2.6, 0.6)
  E.fill(rail2, E.paper); E.hatch(rail2, { angle: 0, gap: 0.8, alpha: 0.6, region: [35, 61, 30, 2.6] }); E.stroke(rail2, { w: 0.6 })
  // Seat, slightly wider at the front.
  const seat = E.poly([[32, 70], [68, 70], [72, 79], [28, 79]])
  E.fill(seat, E.paper); E.tint(seat, { alpha: 0.35 })
  E.hatch(seat, { angle: -12, gap: 1.05, grad: [1.7, 0.8], region: [28, 70, 44, 9] }); E.stroke(seat, { w: 0.7 })
  E.hatch(E.rect(28, 79, 44, 2.6), { angle: 90, gap: 0.9, alpha: 0.8, region: [28, 79, 44, 2.6] }); E.stroke(E.rect(28, 79, 44, 2.6), { w: 0.6 })
  // Legs and stretchers.
  E.double(30, 81.6, 28.5, 104, { w: 2.3 }); E.double(70, 81.6, 71.5, 104, { w: 2.3 })
  E.double(37, 81, 37.5, 99, { w: 1.9 }); E.double(63, 81, 62.5, 99, { w: 1.9 })
  E.line(29.4, 93, 70.6, 93, { w: 0.9 }); E.line(37.2, 91, 62.8, 91, { w: 0.6, alpha: 0.7 })
}

PLATES.quillgavel = (E) => {
  // The quill: a shaft, and barbs laid along it one stroke at a time.
  const sx = 24, sy = 106, ex = 47, ey = 22
  const dx = ex - sx, dy = ey - sy, L = Math.hypot(dx, dy), ux = dx / L, uy = dy / L, nx = -uy, ny = ux
  for (let t = 0.3; t < 0.985; t += 0.028) {
    const px = sx + dx * t, py = sy + dy * t, taper = Math.sin((t - 0.3) / 0.7 * Math.PI) ** 0.5
    const lenL = (7 + 2 * E.rand()) * (0.35 + taper), lenR = (3.5 + 1.2 * E.rand()) * (0.35 + taper)
    const barb = (side, len) => {
      const p = new Path2D(); p.moveTo(px, py)
      const cx = px + side * nx * len * 0.5 + ux * len * 0.55, cy = py + side * ny * len * 0.5 + uy * len * 0.55
      p.quadraticCurveTo(cx, cy, px + side * nx * len + ux * len * 0.8, py + side * ny * len + uy * len * 0.8)
      E.stroke(p, { w: 0.42, alpha: 0.85 })
    }
    barb(1, lenL); barb(-1, lenR)
  }
  E.line(sx, sy, ex, ey, { w: 1.5 }); E.line(sx, sy, ex, ey, { w: 0.5, color: E.paper })
  E.line(sx, sy, sx + ux * 5 + nx * 0.4, sy + uy * 5 + ny * 0.4, { w: 0.5 })
  // The gavel: head across the top, handle running down beside the quill.
  E.rotated(70, 42, -16, () => {
    const head = E.rect(56, 36, 28, 12, 3.2)
    E.fill(head, E.paper); E.tint(head, { alpha: 0.42 })
    E.hatch(head, { angle: 0, gap: 1.15, grad: [1.9, 0.7], bend: 0.8, color: E.spot, alpha: 0.95, region: [56, 36, 28, 12] })
    E.stroke(head, { w: 0.75 })
    for (const x of [59.5, 80.5]) E.line(x, 36.5, x, 47.5, { w: 0.5, alpha: 0.8 })
    E.stroke(E.ellipse(56.3, 42, 1.4, 5.6), { w: 0.5, alpha: 0.7 })
  })
  const hx0 = 70 + Math.sin(16 * Math.PI / 180) * 6, hy0 = 42 + Math.cos(16 * Math.PI / 180) * 6
  E.line(hx0, hy0, 78, 104, { w: 3.4 }); E.line(hx0, hy0, 78, 104, { w: 2, color: E.paper })
  E.hatch(E.poly([[hx0 - 1.7, hy0], [hx0 + 1.7, hy0], [79.7, 104], [76.3, 104]]), { angle: 82, gap: 1, grad: [2.4, 0.8], region: [hx0 - 2, hy0, 12, 62], alpha: 0.85 })
  E.stroke(E.ellipse(78, 104, 1.9, 1), { w: 0.6 })
  E.shadow(56, 110, 36, 3, { alpha: 0.4 })
}

PLATES.ballot = (E) => {
  E.shadow(60, 104, 34, 4)
  const front = E.rect(24, 58, 50, 42), side = E.poly([[74, 58], [86, 47], [86, 89], [74, 100]]), top = E.poly([[24, 58], [74, 58], [86, 47], [36, 47]])
  E.fill(front, E.paper); E.hatch(front, { angle: -45, gap: 1.6, w: 0.38, alpha: 0.55, grad: [1.9, 0.9], region: [24, 58, 50, 42] }); E.stroke(front, { w: 0.75 })
  E.fill(side, E.paper); E.hatch(side, { angle: 90, gap: 1, grad: [1.2, 0.7], region: [74, 47, 12, 53] }); E.stroke(side, { w: 0.75 })
  E.fill(top, E.paper); E.hatch(top, { angle: -42, gap: 2.4, w: 0.32, alpha: 0.4, region: [24, 47, 62, 11] }); E.stroke(top, { w: 0.75 })
  E.fill(E.poly([[46, 54.5], [60, 54.5], [64, 50.5], [50, 50.5]]), E.ink)
  // The ballot, half in.
  const paper = E.poly([[49, 26], [66, 22], [67, 51], [50, 54]])
  E.fill(paper, E.paper); E.tint(paper, { alpha: 0.3 }); E.stroke(paper, { w: 0.65 })
  for (let y = 31; y < 48; y += 3.6) E.line(52, y, 62, y - 1.2, { w: 0.45, alpha: 0.75 })
  E.fill(E.rect(53, 41.6, 2.2, 2.2), E.ink)
  // Padlock.
  const body = E.rect(45, 79, 9, 8, 1.2)
  const shackle = new Path2D(); shackle.moveTo(46.8, 79); shackle.lineTo(46.8, 76); shackle.arc(49.5, 76, 2.7, Math.PI, 0); shackle.lineTo(52.2, 79)
  E.stroke(shackle, { w: 1.4 }); E.stroke(shackle, { w: 0.4, color: E.paper })
  E.fill(body, E.paper); E.cross(body, { angle: -45, gap: 0.85, w: 0.4, region: [45, 79, 9, 8] }); E.stroke(body, { w: 0.65 })
  E.fill(E.circle(49.5, 82.4, 0.9), E.paper); E.fill(E.rect(49.1, 82.6, 0.8, 2.4), E.paper)
}

PLATES.letter = (E) => {
  E.shadow(52, 96, 34, 3.2)
  E.rotated(50, 70, -5, () => {
    const env = E.rect(22, 51, 56, 38)
    E.fill(env, E.paper); E.hatch(env, { angle: 0, gap: 2.6, w: 0.3, alpha: 0.35, grad: [1.2, 1.8], region: [22, 51, 56, 38] }); E.stroke(env, { w: 0.75 })
    // The flap, its shadow, and the folds beneath.
    const flap = E.poly([[22, 51], [50, 74], [78, 51]])
    E.fill(flap, E.paper); E.hatch(flap, { angle: -45, gap: 1.3, w: 0.36, alpha: 0.55, grad: [2.2, 0.8], region: [22, 51, 56, 23] }); E.stroke(flap, { w: 0.7 })
    E.line(22, 89, 44, 71, { w: 0.55, alpha: 0.8 }); E.line(78, 89, 56, 71, { w: 0.55, alpha: 0.8 })
    E.hatch(E.poly([[22, 51], [50, 74], [78, 51], [78, 54], [50, 77], [22, 54]]), { angle: 0, gap: 0.7, w: 0.35, alpha: 0.5, region: [22, 51, 56, 27] })
    // The seal.
    const seal = E.circle(50, 73, 5.6)
    E.fill(seal, E.paper); E.tint(seal, { alpha: 0.75, offset: [0.35, 0.3] })
    E.cross(seal, { angle: -45, gap: 1.1, w: 0.35, color: E.spot, alpha: 0.9, region: [44, 67, 12, 12] })
    E.stroke(seal, { w: 0.8 }); E.stroke(E.circle(50, 73, 3.6), { w: 0.5, alpha: 0.85 })
    E.stroke(E.circle(50, 73, 6.3), { w: 0.45, dash: [0.6, 1.1], alpha: 0.8 })
  })
}

PLATES.tally = (E) => {
  E.shadow(54, 108, 34, 3)
  // A slate in a wooden frame; the marks are scratched through to the paper.
  const frame = E.rect(18, 30, 64, 68, 2.5), slate = E.rect(23, 35, 54, 53, 1.5)
  E.fill(frame, E.paper); E.tint(frame, { alpha: 0.35 })
  E.hatch(E.union(frame, slate), { angle: 90, gap: 1, grad: [1.2, 1.2], alpha: 0.75, region: [18, 30, 64, 68], rule: 'evenodd' })
  E.stroke(frame, { w: 0.8 })
  E.fill(slate, E.paper)
  E.cross(slate, { angle: -45, gap: 0.9, w: 0.5, alpha: 0.95, region: [23, 35, 54, 53] })
  E.hatch(slate, { angle: 20, gap: 1.5, w: 0.4, alpha: 0.7, region: [23, 35, 54, 53] })
  E.stroke(slate, { w: 0.6 })
  const mark = (x1, y1, x2, y2) => E.line(x1, y1, x2, y2, { w: 1.3, color: E.paper, jitter: 0.25 })
  for (const x of [33, 38.5, 44, 49.5]) mark(x, 50, x + 0.4, 68)
  mark(30, 66, 53, 52)
  for (const x of [60, 65.5]) mark(x, 50, x + 0.4, 68)
  // Chalk on the ledge.
  const ledge = E.rect(16, 98, 68, 3.2)
  E.fill(ledge, E.paper); E.tint(ledge, { alpha: 0.35 }); E.hatch(ledge, { angle: 0, gap: 0.8, alpha: 0.6, region: [16, 98, 68, 3.2] }); E.stroke(ledge, { w: 0.65 })
  const chalk = E.rect(62, 95, 9, 2.6, 1)
  E.fill(chalk, E.paper); E.stroke(chalk, { w: 0.5 }); E.stroke(E.ellipse(71, 96.3, 0.5, 1.3), { w: 0.4 })
}

PLATES.well = (E) => {
  E.shadow(56, 106, 32, 3.6)
  // The roof, then the posts, then the well itself.
  const roof = E.poly([[18, 44], [50, 22], [82, 44], [78, 44], [50, 26.5], [22, 44]])
  E.fill(roof, E.paper); E.tint(roof, { alpha: 0.28 })
  E.hatch(roof, { angle: -34, gap: 1, grad: [1.6, 0.9], region: [18, 22, 64, 22] })
  E.hatch(roof, { angle: 34, gap: 1, grad: [0.9, 1.6], region: [50, 22, 32, 22] })
  E.stroke(roof, { w: 0.7 })
  E.double(30, 44, 30, 80, { w: 2.4 }); E.double(70, 44, 70, 80, { w: 2.4 })
  E.line(30, 50, 70, 50, { w: 1.3 }); E.line(30, 50, 70, 50, { w: 0.4, color: E.paper })
  E.line(70, 50, 77, 50, { w: 1.1 }); E.line(77, 50, 77, 57, { w: 1.1 }); E.fill(E.circle(77, 57.5, 1.1), E.ink)
  const drum = E.rect(44, 47.6, 12, 4.8, 1)
  E.fill(drum, E.paper); E.hatch(drum, { angle: 90, gap: 0.8, alpha: 0.8, region: [44, 47.6, 12, 4.8] }); E.stroke(drum, { w: 0.55 })
  E.line(50, 52.4, 50, 63, { w: 0.6 })
  const bucket = E.poly([[44, 64], [56, 64], [55, 74], [45, 74]])
  E.fill(bucket, E.paper); E.tint(bucket, { alpha: 0.45 })
  E.hatch(bucket, { angle: 90, gap: 1, grad: [2, 0.7], bend: 0.5, region: [44, 64, 12, 10] }); E.stroke(bucket, { w: 0.65 })
  const handle = new Path2D(); handle.moveTo(44, 64); handle.quadraticCurveTo(50, 57, 56, 64); E.stroke(handle, { w: 0.6 })
  E.stroke(E.ellipse(50, 64, 6, 1.4), { w: 0.5 })
  // Stone.
  const wall = E.cylinder(50, 80, 25, 7, 22)
  E.fill(wall.side, E.paper)
  E.hatch(wall.side, { angle: 90, gap: 1.4, w: 0.36, alpha: 0.6, grad: [2.2, 0.7], bend: 1, region: [25, 73, 50, 36] })
  E.clip(wall.side, () => {
    for (const y of [87, 94, 101]) { const c = new Path2D(); c.ellipse(50, y, 25, 7, 0, 0, Math.PI, false); E.stroke(c, { w: 0.55, alpha: 0.85 }) }
    for (let i = 0; i < 12; i++) { const x = 27 + i * 4.2 + (i % 2) * 2; const y0 = i % 2 ? 87 : 80; E.line(x, y0 + 7 * Math.sqrt(Math.max(0, 1 - ((x - 50) / 25) ** 2)), x, y0 + 7 + 7 * Math.sqrt(Math.max(0, 1 - ((x - 50) / 25) ** 2)), { w: 0.5, alpha: 0.75 }) }
  })
  E.stroke(wall.side, { w: 0.75 })
  E.fill(wall.top, E.paper); E.stroke(wall.top, { w: 0.7 })
  E.fill(E.ellipse(50, 80, 20, 5.2), E.ink, 0.92)
  E.stroke(E.ellipse(50, 80, 20, 5.2), { w: 0.5 })
}


/** Which plate belongs to which experience. */
export const PLATE_FOR = {
  exp01: 'button', exp02: 'balance', exp03: 'seedling', exp04: 'crown', exp05: 'cord',
  pillarA: 'door', pillarB: 'hourglass', pillarC: 'chair', pillarD: 'quillgavel', pillarE: 'beehive',
  practice01: 'ballot', practice02: 'letter', practice03: 'chairs', practice04: 'tally', practice05: 'well'
}

/** The short test's four results, drawn from the same set. */
export const RESULT_PLATE = { consistent: 'chairs', loophole: 'cord', weighing: 'balance', force: 'quillgavel' }

export const PLATE_NAMES = Object.keys(PLATES)

/** How each plate is named in its caption. */
export const PLATE_TITLE = {
  button: 'The button', balance: 'The balance', seedling: 'A seedling', crown: 'The crown', cord: 'The cord',
  door: 'The door', hourglass: 'The hourglass', chair: 'A chair', quillgavel: 'Quill and gavel', beehive: 'The hive',
  ballot: 'The ballot box', letter: 'A letter', chairs: 'Two chairs', tally: 'The slate', well: 'The well', tomato: 'A tomato'
}

/** Plates are numbered in curriculum order, I to XV. */
export function plateNumeral(id) {
  const n = Object.keys(PLATE_FOR).indexOf(id) + 1
  if (n < 1) return ''
  const R = [[10, 'X'], [9, 'IX'], [5, 'V'], [4, 'IV'], [1, 'I']]
  let out = '', k = n
  for (const [v, s] of R) while (k >= v) { out += s; k -= v }
  return out
}

const plateSeed = (name) => [...name].reduce((a, c) => (a * 31 + c.charCodeAt(0)) >>> 0, 7)

/**
 * Print `name` onto a canvas context that is already scaled so that one plate
 * unit is one canvas unit. Returns false for a name we have no plate for.
 */
export function printPlate(ctx, name, colors) {
  const fn = PLATES[name]
  if (!fn) return false
  ctx.lineCap = 'round'; ctx.lineJoin = 'round'
  ctx.fillStyle = colors.paper; ctx.fillRect(0, 0, W, H)
  fn(engine(ctx, colors, makeRand(plateSeed(name))))
  return true
}
