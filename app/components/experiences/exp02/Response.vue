<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="3" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The response</p>
    <h2 class="display-medium">Here's what the philosophy says back.</h2>
    <Divider />

    <div class="response-flow">
      <!-- Only the paragraphs read so far are in the layout; hidden ones would
           hold their height and leave a blank gap above the nav. -->
      <div v-for="(para, idx) in obj.response.slice(0, currentPara + 1)" :key="idx" class="response-block">
        <!-- eslint-disable-next-line vue/no-v-html -- content is authored in a local data file, never user input. Revisit if it ever comes from a CMS. -->
        <div class="response-para" v-html="para"/>

        <div v-if="idx === currentPara && idx < obj.response.length - 1" class="reveal-row">
          <button class="reveal-btn" @click="reveal(idx + 1)">Keep reading →</button>
        </div>
      </div>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!allRead"
      @back="$emit('back')"
      @continue="$emit('advance')"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const el = ref(null)
const currentPara = ref(0)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const obj = computed(() => objections[journey.exp02?.chosenObjection] || objections['doesnt-scale'])

const allRead = computed(() => currentPara.value >= obj.value.response.length - 1)

function reveal(idx) {
  if (idx >= obj.value.response.length) return
  nextTick(() => {
    currentPara.value = idx
    setTimeout(() => {
      const blocks = document.querySelectorAll('.response-block')
      const nextBlock = blocks[idx]
      // scroll-behavior in CSS does not govern scrollIntoView's own
      // behavior option, so the preference has to be read here too.
      const still = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches
      if (nextBlock) nextBlock.scrollIntoView({ behavior: still ? 'auto' : 'smooth', block: 'start' })
    }, 100)
  })
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.response-flow { margin: 1.5rem 0; }
.response-block { margin-bottom: 1.5rem; animation: block-in 0.4s ease both; }
@keyframes block-in {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}
@media (prefers-reduced-motion: reduce) { .response-block { animation: none; } }
.response-para { font-size: 0.92rem; line-height: 1.75; color: var(--ink-muted); padding: 1rem 1.25rem; background: var(--cream); border-radius: var(--radius); border: 1px solid var(--border-subtle); }
.response-para :deep(em) { color: var(--ink); font-style: italic; }

.reveal-row { margin-top: 0.75rem; }
.reveal-btn { padding: 0.4rem 0.85rem; background: var(--paper); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.75rem; color: var(--ink-faint); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.reveal-btn:hover { border-color: var(--ochre); color: var(--ink); }
</style>
