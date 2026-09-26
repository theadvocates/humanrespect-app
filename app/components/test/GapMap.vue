<template>
  <figure class="gm" :class="`phase-${phase}`">
    <svg
      class="gm-svg"
      :viewBox="`0 0 ${W} ${H}`"
      role="img"
      :aria-label="`A map with your own hands across and through others up. You are at ${directly} across and ${others} up. ${gap > 0 ? `The dot sits ${gap} points below the line of one standard.` : 'The dot sits on the line of one standard.'}`"
    >
      <defs>
        <clipPath :id="clipId"><rect :x="L" :y="T" :width="S" :height="S" /></clipPath>
      </defs>

      <!-- Plot ground and the four results, from classify(): consistent is
           both at or above 70; loophole is directly at or above 70 with
           others below; force is both at or below 30. The rest is weighing. -->
      <rect class="ground" :x="L" :y="T" :width="S" :height="S" />
      <rect class="zone zone-consistent" :x="x(70)" :y="y(100)" :width="x(100) - x(70)" :height="y(70) - y(100)" />
      <rect class="zone zone-loophole" :x="x(70)" :y="y(70)" :width="x(100) - x(70)" :height="y(0) - y(70)" />
      <rect class="zone zone-force" :x="x(0)" :y="y(30)" :width="x(30) - x(0)" :height="y(0) - y(30)" />

      <g class="grid">
        <template v-for="v in [10, 20, 30, 40, 50, 60, 70, 80, 90]" :key="v">
          <line :x1="x(v)" :y1="T" :x2="x(v)" :y2="T + S" />
          <line :x1="L" :y1="y(v)" :x2="L + S" :y2="y(v)" />
        </template>
      </g>

      <text class="zone-label" :x="x(85)" :y="y(100) + 18" text-anchor="middle">
        <tspan :x="x(85)" dy="0">Persuasion,</tspan>
        <tspan :x="x(85)" dy="13">all the way through</tspan>
      </text>
      <text class="zone-label" :x="x(85)" :y="y(0) - 12" text-anchor="middle">The loophole</text>
      <text class="zone-label" :x="x(15)" :y="y(0) - 12" text-anchor="middle">Force on the table</text>
      <text class="zone-label" :x="x(32)" :y="y(62)" text-anchor="middle">Still weighing it</text>

      <!-- One standard both ways -->
      <line class="diagonal" :x1="x(0)" :y1="y(0)" :x2="x(100)" :y2="y(100)" />
      <text class="diagonal-label" :transform="`translate(${x(50) - 10} ${y(50) - 12}) rotate(-45)`" text-anchor="middle">same standard both ways</text>

      <!-- Everyone else, once there are enough of them to show -->
      <g v-if="crowd?.length" class="crowd" :clip-path="`url(#${clipId})`">
        <circle
          v-for="c in crowd"
          :key="`${c.directly}-${c.others}`"
          :cx="x(c.directly)"
          :cy="y(c.others)"
          :r="crowdRadius(c.visitors)"
        />
      </g>

      <line class="axis" :x1="L" :y1="T + S" :x2="L + S" :y2="T + S" />
      <line class="axis" :x1="L" :y1="T" :x2="L" :y2="T + S" />
      <g class="ticks">
        <text v-for="v in [0, 50, 100]" :key="`x${v}`" :x="x(v)" :y="T + S + 26" text-anchor="middle">{{ v }}</text>
        <text v-for="v in [0, 50, 100]" :key="`y${v}`" :x="L - 20" :y="y(v) + 4" text-anchor="end">{{ v }}</text>
      </g>
      <text class="axis-label" :x="L" :y="H - 8">Force</text>
      <text class="axis-label" :x="L + S" :y="H - 8" text-anchor="end">Persuade</text>
      <text class="axis-label" :x="L + S / 2" :y="H - 8" text-anchor="middle">Your own hands</text>
      <g :transform="`translate(16 ${T + S / 2}) rotate(-90)`">
        <text class="axis-label" :x="-S / 2" y="0">Force</text>
        <text class="axis-label" :x="S / 2" y="0" text-anchor="end">Persuade</text>
        <text class="axis-label" x="0" y="0" text-anchor="middle">Through others</text>
      </g>

      <!-- Where you would be with one standard, and the drop from there -->
      <g class="anchor" :style="{ transform: `translate(${x(directly)}px, ${y(directly)}px)` }">
        <circle r="4" />
      </g>
      <line
        class="gap-line"
        :x1="x(directly)"
        :y1="y(directly) + 6"
        :x2="x(directly)"
        :y2="dotY - 12"
        :style="{ opacity: gap > 0 ? 1 : 0 }"
      />
      <text
        v-if="gap > 0"
        class="gap-label"
        :x="labelLeft ? x(directly) - 10 : x(directly) + 10"
        :y="(y(directly) + dotY) / 2 + 4"
        :text-anchor="labelLeft ? 'end' : 'start'"
      >gap {{ gap }}</text>

      <g class="you" :style="{ transform: `translate(${x(directly)}px, ${dotY}px)` }">
        <circle class="you-halo" r="16" />
        <circle class="you-dot" r="9" />
        <text class="you-label" :x="labelLeft ? -18 : 18" y="7" :text-anchor="labelLeft ? 'end' : 'start'">You</text>
      </g>
    </svg>
  </figure>
</template>

<script setup>
/**
 * Two scores on one square. "Your own hands" runs across, "through others"
 * runs up, and the diagonal is one standard both ways. The gap is the drop
 * from the diagonal to the dot, so it reads as a distance instead of a
 * subtraction.
 *
 * `phase` runs the reveal: 0 nothing, 1 the dot on the diagonal at your own
 * score, 2 the dot dropped to where you are, 3 everything. The parent owns
 * the timing so the words can arrive after the picture.
 */
const props = defineProps({
  directly: { type: Number, required: true },
  others: { type: Number, required: true },
  phase: { type: Number, default: 3 },
  /** [{ directly, others, visitors }] for everyone else, or null. */
  crowd: { type: Array, default: null }
})

// Plot geometry: a square of S, with room for tick numbers on the left and
// the axis titles below and beside. Tick numbers sit 26px below and 20px
// left of the plot so the "You" dot and its 16px halo clear them at a corner.
const L = 62
const T = 18
const S = 340
const W = L + S + 14
const H = T + S + 48

const x = (v) => L + (v / 100) * S
const y = (v) => T + S - (v / 100) * S

const gap = computed(() => props.directly - props.others)
const dotY = computed(() => (props.phase >= 2 ? y(props.others) : y(props.directly)))
// Near the right edge the "You" and gap labels would hang off the plot.
const labelLeft = computed(() => props.directly > 80)

const most = computed(() => Math.max(1, ...(props.crowd || []).map((c) => Number(c.visitors) || 0)))
function crowdRadius(n) {
  return 2 + Math.sqrt((Number(n) || 0) / most.value) * 7
}

const clipId = `gm-clip-${Math.random().toString(36).slice(2, 8)}`
</script>

<style scoped>
.gm { margin: 1rem 0 1.5rem; width: 100%; }
.gm-svg { display: block; width: 100%; max-width: 26rem; height: auto; overflow: visible; }

.ground { fill: var(--paper-warm); }
.zone-consistent { fill: var(--insight-bg); }
.zone-loophole { fill: var(--ochre-faint); }
.zone-force { fill: var(--concede-bg); }
.grid line { stroke: var(--border-subtle); stroke-width: 1; }

text { font-family: var(--sans); }
.zone-label { font-size: 10px; letter-spacing: 0.1em; text-transform: uppercase; fill: var(--ink-muted); }
.diagonal { stroke: var(--ink-muted); stroke-width: 1; stroke-dasharray: 3 4; }
.diagonal-label { font-size: 11px; font-style: italic; fill: var(--ink-faint); }
.crowd circle { fill: var(--ink-muted); opacity: 0.22; }
.axis { stroke: var(--ink-muted); stroke-width: 1; }
.ticks text { font-size: 11px; fill: var(--ink-faint); }
.axis-label { font-size: 10.5px; letter-spacing: 0.12em; text-transform: uppercase; fill: var(--ink-muted); }

.anchor circle { fill: none; stroke: var(--ochre); stroke-width: 2; }
.gap-line { stroke: var(--concede-warm); stroke-width: 2; stroke-dasharray: 2 4; }
.gap-label { font-size: 12px; font-weight: 500; fill: var(--concede-warm); }
.you-halo { fill: none; stroke: var(--ochre); stroke-width: 1; opacity: 0.5; }
.you-dot { fill: var(--ochre); stroke: var(--paper); stroke-width: 2; }
.you-label { font-family: var(--serif); font-size: 22px; fill: var(--ink); }

/* The reveal. The dot starts on the diagonal, where one standard would put
   it, and then drops to where the answers put it, so the gap opens rather
   than simply being drawn. */
.you, .anchor { transition: transform 0.9s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.4s ease; }
.gap-line, .gap-label { transition: opacity 0.5s ease 0.4s; }
.phase-0 .you, .phase-0 .anchor { opacity: 0; }
.phase-1 .anchor, .phase-0 .gap-line, .phase-1 .gap-line, .phase-0 .gap-label, .phase-1 .gap-label { opacity: 0 !important; }

@media (prefers-reduced-motion: reduce) {
  .you, .anchor, .gap-line, .gap-label { transition: none; }
}
</style>
