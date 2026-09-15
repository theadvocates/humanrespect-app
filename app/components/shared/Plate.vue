<template>
  <!-- An engraved plate: cream paper, a debossed plate mark, the drawing, and
       a caption. The drawing is printed by app/utils/plates.js at mount and
       again whenever the plate changes size, so it is always crisp. -->
  <figure class="plate" :class="{ 'on-dark': dark, bare }">
    <div class="plate-paper">
      <div class="plate-mark">
        <canvas ref="canvas" role="img" :aria-label="alt" />
      </div>
    </div>
    <figcaption v-if="$slots.default" class="plate-cap"><slot /></figcaption>
  </figure>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from 'vue'
import { printPlate, W, H } from '@/utils/plates.js'

const props = defineProps({
  name: { type: String, required: true },
  alt: { type: String, default: '' },
  dark: { type: Boolean, default: false },
  // No paper or plate mark: just the drawing, for small catalog tiles.
  bare: { type: Boolean, default: false }
})

const canvas = ref(null)
let observer = null
let printed = ''

function print() {
  const el = canvas.value
  if (!el) return
  const width = el.clientWidth
  const ctx = width && el.getContext && el.getContext('2d')
  if (!ctx) return
  const cs = getComputedStyle(el)
  const colors = {
    ink: cs.getPropertyValue('--plate-ink').trim(),
    spot: cs.getPropertyValue('--plate-spot').trim(),
    paper: cs.getPropertyValue('--plate-paper').trim()
  }
  const key = `${props.name}|${width}|${colors.ink}`
  if (key === printed) return
  printed = key
  const dpr = Math.min(window.devicePixelRatio || 1, 2.5)
  el.width = Math.round(width * dpr)
  el.height = Math.round(width * dpr * H / W)
  el.style.height = `${width * H / W}px`
  ctx.setTransform(width * dpr / W, 0, 0, width * dpr / W, 0, 0)
  printPlate(ctx, props.name, colors)
}

// A plate is printed onto a canvas, so a theme change needs a reprint.
function reprint() { printed = ''; print() }

onMounted(() => {
  print()
  window.addEventListener('themechange', reprint)
  if (typeof ResizeObserver !== 'undefined') {
    observer = new ResizeObserver(() => requestAnimationFrame(print))
    observer.observe(canvas.value)
  }
})
onBeforeUnmount(() => {
  observer?.disconnect()
  window.removeEventListener('themechange', reprint)
})
watch(() => [props.name, props.dark], () => { printed = ''; print() })
</script>
