<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">What honesty requires</p>
    <h2 class="display-medium">What the philosophy can't claim.</h2>
    <Divider />

    <p class="body-text-large">A philosophy that only gives you the strong parts of its argument and hides the difficult parts isn't trustworthy. So here's what intellectual honesty requires us to say.</p>

    <ContentBlock variant="concession" label="The honest concession">
      <p v-html="obj.concession"></p>
    </ContentBlock>

    <p class="body-text" style="margin-top: 1.5rem;">Does this honesty make the philosophy more or less credible to you?</p>

    <div class="credibility-options">
      <button
        v-for="opt in credibilityOptions"
        :key="opt.id"
        class="cred-btn"
        :class="{ selected: credibility === opt.id }"
        @click="chooseCredibility(opt.id)"
      >{{ opt.label }}</button>
    </div>

    <p v-if="credibility" class="body-text" style="margin-top: 1rem; font-style: italic; color: var(--ink-faint);">
      <template v-if="credibility === 'more'">Most people find that honesty about limits builds more trust than confident claims of perfection.</template>
      <template v-else-if="credibility === 'less'">That's a legitimate response. If the gap between what the philosophy promises and what it can deliver is too wide, the principle may not be worth the risk.</template>
      <template v-else>Fair enough. The concession doesn't change the core argument — it just marks its boundaries.</template>
    </p>

    <NavBar :can-go-back="true" :disable-continue="!credibility" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const journey = useJourneyStore()
const el = ref(null)
const credibility = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const obj = computed(() => objections[journey.exp02?.chosenObjection] || objections['doesnt-scale'])

const credibilityOptions = [
  { id: 'more', label: 'More credible — honesty matters' },
  { id: 'less', label: 'Less credible — the gap is too big' },
  { id: 'same', label: 'Doesn\'t change my view' },
]

function chooseCredibility(id) {
  credibility.value = id
  trackChoice('exp02', 'concession-credibility', id)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.credibility-options { margin: 1rem 0; display: flex; flex-wrap: wrap; gap: 0.4rem; }
.cred-btn { padding: 0.55rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: 100px; font-family: var(--sans); font-size: 0.82rem; color: var(--ink-muted); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.cred-btn:hover { border-color: var(--ochre); }
.cred-btn.selected { border-color: var(--ochre); background: var(--ochre-faint); color: var(--ink); font-weight: 500; }
</style>
