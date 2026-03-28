<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="7" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The foundation is complete</p>
    <h2 class="display-medium">Three discoveries, from your own reasoning.</h2>
    <Divider />

    <div class="foundation-summary">
      <div class="foundation-item">
        <span class="foundation-number">01</span>
        <div>
          <div class="foundation-title">The method</div>
          <p class="foundation-desc">You already choose persuasion over force in your closest relationships — because you know what force does to people.</p>
        </div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">02</span>
        <div>
          <div class="foundation-title">The evidence</div>
          <p class="foundation-desc">Your own flourishing confirmed it: safety, autonomy, and opportunity are the conditions. Violations of body, resources, and time are what destroys them.</p>
        </div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">03</span>
        <div>
          <div class="foundation-title">The stress test</div>
          <p class="foundation-desc">You chose your strongest objection and saw it engaged with honestly — including the limits of the response.</p>
        </div>
      </div>
    </div>

    <p class="body-text">You can explore another objection, or continue deeper into the philosophy.</p>

    <div v-if="otherObjections.length > 0" class="other-objections">
      <p class="caption" style="margin-bottom: 0.75rem;">Try a different objection</p>
      <div class="other-list">
        <button
          v-for="key in otherObjections"
          :key="key"
          class="other-btn"
          @click="$emit('restart-with', key)"
        >{{ allObjections[key].title }}</button>
      </div>
    </div>

    <PathCard :to="{ name: 'milestone' }" :recommended="true">
      <template #title>See your foundation summary</template>
      <template #desc>A personalized summary of what you discovered, and where the philosophy goes from here.</template>
    </PathCard>

    <JourneyNav current="exp02" next-label="Continue your journey" />

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import PathCard from '@/components/shared/PathCard.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections as allObjections } from './objectionData.js'

defineEmits(['restart-with'])
const journey = useJourneyStore()
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const otherObjections = computed(() =>
  Object.keys(allObjections).filter(k => k !== journey.exp02?.chosenObjection)
)
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.foundation-summary { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }
.foundation-item { display: flex; gap: 1rem; align-items: flex-start; }
.foundation-number { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.foundation-title { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.15rem; }
.foundation-desc { font-size: 0.85rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }

.other-objections { margin: 2rem 0; }
.other-list { display: flex; flex-direction: column; gap: 0.4rem; margin-bottom: 1.5rem; }
.other-btn { width: 100%; text-align: left; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--serif); font-size: 0.88rem; color: var(--ink); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.other-btn:hover { border-color: var(--ochre); background: var(--ochre-faint); }
</style>
