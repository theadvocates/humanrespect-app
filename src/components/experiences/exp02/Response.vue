<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The response</p>
    <h2 class="display-medium">Here's what the philosophy says back.</h2>
    <Divider />

    <div class="response-flow">
      <div v-for="(para, idx) in obj.response" :key="idx" class="response-block" :class="{ visible: idx <= currentPara }">
        <div class="response-para" v-html="para"></div>

        <div v-if="idx === currentPara && idx < obj.response.length - 1" class="reaction-row">
          <p class="reaction-prompt">Does this address your concern?</p>
          <div class="reaction-options">
            <button
              v-for="r in reactions"
              :key="r.id"
              class="reaction-btn"
              :class="{ selected: paraReactions[idx] === r.id }"
              @click="react(idx, r.id)"
            >{{ r.label }}</button>
          </div>
        </div>

        <div v-if="idx === currentPara && idx === obj.response.length - 1" class="reaction-row">
          <p class="reaction-prompt">Having read the full response:</p>
          <div class="reaction-options">
            <button
              v-for="r in reactions"
              :key="r.id"
              class="reaction-btn"
              :class="{ selected: paraReactions[idx] === r.id }"
              @click="react(idx, r.id)"
            >{{ r.label }}</button>
          </div>
        </div>
      </div>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!allReacted"
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
import { useAnalytics } from '@/composables/useAnalytics'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const journey = useJourneyStore()
const el = ref(null)
const currentPara = ref(0)
const paraReactions = ref({})
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const obj = computed(() => objections[journey.exp02?.chosenObjection] || objections['doesnt-scale'])

const reactions = [
  { id: 'yes', label: 'Yes, that helps' },
  { id: 'partially', label: 'Partially' },
  { id: 'no', label: 'No, that misses the point' },
]

const allReacted = computed(() => {
  return Object.keys(paraReactions.value).length >= obj.value.response.length
})

function react(idx, reactionId) {
  paraReactions.value[idx] = reactionId
  trackChoice('exp02', `response-para-${idx}`, reactionId)

  if (idx < obj.value.response.length - 1) {
    nextTick(() => {
      currentPara.value = idx + 1
      setTimeout(() => {
        const blocks = document.querySelectorAll('.response-block')
        const nextBlock = blocks[idx + 1]
        if (nextBlock) nextBlock.scrollIntoView({ behavior: 'smooth', block: 'start' })
      }, 100)
    })
  }
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.response-flow { margin: 1.5rem 0; }
.response-block { margin-bottom: 1.5rem; opacity: 0; transform: translateY(8px); transition: opacity 0.4s ease, transform 0.4s ease; }
.response-block.visible { opacity: 1; transform: translateY(0); }
.response-para { font-size: 0.92rem; line-height: 1.75; color: var(--ink-muted); padding: 1rem 1.25rem; background: var(--cream); border-radius: var(--radius); border: 1px solid var(--border-subtle); }
.response-para :deep(em) { color: var(--ink); font-style: italic; }

.reaction-row { margin-top: 0.75rem; }
.reaction-prompt { font-size: 0.78rem; color: var(--ink-faint); margin-bottom: 0.4rem; }
.reaction-options { display: flex; flex-wrap: wrap; gap: 0.35rem; }
.reaction-btn { padding: 0.4rem 0.85rem; background: var(--paper); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.75rem; color: var(--ink-faint); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.reaction-btn:hover { border-color: var(--ochre); }
.reaction-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }
</style>
