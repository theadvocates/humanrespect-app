#!/bin/bash
# Fix: Pillar E — allow exploring other issues from closing screen
# Run from humanrespect-app/ root

set -e

# ── Update page orchestrator to support restart ──
cat > src/pages/PillarE.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="screenKey"
          @advance="advance"
          @back="goBack"
          @set-issue="handleIssue"
          @restart-with="restartWith"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'

import Opening from '@/components/experiences/pillarE/Opening.vue'
import TheEvidence from '@/components/experiences/pillarE/TheEvidence.vue'
import WhyItWorks from '@/components/experiences/pillarE/WhyItWorks.vue'
import DesignYourOwn from '@/components/experiences/pillarE/DesignYourOwn.vue'
import VoluntaryAlternatives from '@/components/experiences/pillarE/VoluntaryAlternatives.vue'
import TheQuestion from '@/components/experiences/pillarE/TheQuestion.vue'

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])
const chosenIssue = ref(null)

provide('chosenIssue', chosenIssue)

const screenComponents = [
  Opening, TheEvidence, WhyItWorks, DesignYourOwn, VoluntaryAlternatives, TheQuestion
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${chosenIssue.value}`)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) {
    currentScreen.value++
    history.value.push(currentScreen.value)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function goBack() {
  if (history.value.length > 1) {
    history.value.pop()
    currentScreen.value = history.value[history.value.length - 1]
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function handleIssue(id) { chosenIssue.value = id }

function restartWith(id) {
  chosenIssue.value = id
  currentScreen.value = 3 // jump to DesignYourOwn
  history.value = [0, 1, 2, 3]
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<style scoped>
.exp-app {
  width: 100%;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem 1.5rem;
  transition: background 0.6s ease, color 0.6s ease;
  background: var(--paper);
}
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF

echo "  ✓ PillarE.vue updated with restart support"

# ── Update TheQuestion to show other issues ──
cat > src/components/experiences/pillarE/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What else might be possible?</h2>
    <Divider />

    <p class="body-text-large">Voluntary cooperation built the world's largest encyclopedia, the infrastructure that runs the internet, and disaster response networks that outperform government agencies. It resolves billions in disputes, funds hundreds of billions in charitable giving, and sustains communities across the globe.</p>

    <ContentBlock variant="principle">
      <p>If voluntary cooperation can do all of this — what else might it be capable of that we've never tried, because we assumed force was the only option?</p>
    </ContentBlock>

    <p class="body-text">Every social problem that seems to "require" government force was once solved — or is currently being solved — by people who chose to cooperate. The question isn't whether voluntary solutions are possible. It's whether we'll give them the space to grow.</p>

    <ContentBlock variant="insight">
      <p>The Philosophy of Human Respect doesn't claim that voluntary cooperation will solve every problem overnight. It claims that the <em>trajectory</em> of cooperation points toward greater flourishing, while the trajectory of coercion points toward conflict, stagnation, and the slow erosion of human dignity. And it asks: given the evidence, which trajectory do you want to be on?</p>
    </ContentBlock>

    <!-- Other issues to explore -->
    <div v-if="otherIssues.length" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore another issue</p>
      <PathCard
        v-for="issue in otherIssues"
        :key="issue.id"
        href="#"
        @click.prevent="$emit('restart-with', issue.id)"
      >
        <template #title>{{ issue.label }}</template>
        <template #desc>See voluntary alternatives for {{ issue.label.toLowerCase() }}.</template>
      </PathCard>
    </div>

    <div style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>Why time is the most fundamental human resource — and what coercion really costs.</template>
      </PathCard>
      <PathCard :to="{ name: 'pillarD' }">
        <template #title>The Method Is the Message</template>
        <template #desc>The question isn't what you value — it's how you propose to advance it.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>The Original Question</template>
        <template #desc>Where it all started — the thought experiment that reveals the gap.</template>
      </PathCard>
    </div>

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">
      The Philosophy of Human Respect — articulated by Chris J. Rufer
    </p>
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
import { appliedIssues } from './examplesData.js'

defineEmits(['restart-with'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const chosenIssue = inject('chosenIssue', ref(null))
const otherIssues = computed(() =>
  appliedIssues.filter(i => i.id !== chosenIssue.value)
)
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ TheQuestion.vue updated with other issues"

echo ""
echo "✅ Fix applied."
echo "Push with: git add . && git commit -m 'pillar E: explore other issues from closing' && git push"
