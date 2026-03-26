#!/bin/bash
# Creates Experience 03: "What Flourishing Actually Means"
# Run from humanrespect-app/ root

set -e

mkdir -p src/components/experiences/exp03

echo "🏗️  Building Experience 03..."

# ══════════════════════════════════════
# ROUTE — add to router
# ══════════════════════════════════════

# We need to add the route. Let's rewrite the router to include exp03.
cat > src/router/index.js << 'JSEOF'
import { createRouter, createWebHistory } from 'vue-router'
import LandingPage from '@/pages/LandingPage.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: LandingPage
  },
  {
    path: '/experience/the-question',
    name: 'exp01',
    component: () => import('@/pages/Experience01.vue')
  },
  {
    path: '/experience/the-objection',
    name: 'exp02',
    component: () => import('@/pages/Experience02.vue')
  },
  {
    path: '/experience/flourishing',
    name: 'exp03',
    component: () => import('@/pages/Experience03.vue')
  },
  {
    path: '/about',
    name: 'about',
    component: () => import('@/pages/AboutPage.vue')
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () => import('@/pages/NotFound.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

export default router
JSEOF

echo "  ✓ Router updated with /experience/flourishing"

# ══════════════════════════════════════
# PAGE ORCHESTRATOR
# ══════════════════════════════════════

cat > src/pages/Experience03.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="currentScreen"
          @advance="advance"
          @back="goBack"
          @select-conditions="handleConditions"
          @select-violations="handleViolations"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted } from 'vue'

import Opening from '@/components/experiences/exp03/Opening.vue'
import BestPeriod from '@/components/experiences/exp03/BestPeriod.vue'
import ThePattern from '@/components/experiences/exp03/ThePattern.vue'
import WorstPeriod from '@/components/experiences/exp03/WorstPeriod.vue'
import ThreeDomains from '@/components/experiences/exp03/ThreeDomains.vue'
import FlourishingPrinciple from '@/components/experiences/exp03/FlourishingPrinciple.vue'
import TheBridge from '@/components/experiences/exp03/TheBridge.vue'

const TOTAL_SCREENS = 7
const currentScreen = ref(0)
const history = ref([0])

// Store the visitor's selections for use in adaptive screens
const selectedConditions = ref([])
const selectedViolations = ref([])

const screenComponents = [
  Opening, BestPeriod, ThePattern, WorstPeriod,
  ThreeDomains, FlourishingPrinciple, TheBridge
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) {
    document.body.classList.add('dark-mode')
  } else {
    document.body.classList.remove('dark-mode')
  }
}, { immediate: true })

onUnmounted(() => {
  document.body.classList.remove('dark-mode')
})

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

function handleConditions(conditions) {
  selectedConditions.value = conditions
}

function handleViolations(violations) {
  selectedViolations.value = violations
}

// Provide selections to child components
import { provide } from 'vue'
provide('selectedConditions', selectedConditions)
provide('selectedViolations', selectedViolations)
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
.exp-app.dark-mode {
  background: var(--bg-dark);
  color: var(--text-inverse);
}
.exp-container {
  max-width: 640px;
  width: 100%;
}
.screen-fade-enter-active,
.screen-fade-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }

@media (max-width: 480px) {
  .exp-app { padding: 1.5rem 1rem; }
}
</style>
VUEEOF

echo "  ✓ Experience03.vue"

# ══════════════════════════════════════
# SCREEN COMPONENTS
# ══════════════════════════════════════

# ── Opening ──
cat > src/components/experiences/exp03/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Experience 03 · The Philosophy of Human Respect</span>
    <h1 class="display-large headline">
      Now let's look at<br><em>what's underneath.</em>
    </h1>
    <Divider :centered="true" />
    <p class="subtitle">
      You've seen the gap between personal and political morality. You've examined
      your strongest objection. Now we need to understand <em>why</em> the principle
      is true — and your own life already holds the answer.
    </p>
    <button class="begin-btn" @click="$emit('advance')">
      Continue <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'

defineEmits(['advance'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.opening { text-align: center; padding: 2rem 0; }
.overline {
  font-size: 0.75rem; letter-spacing: 0.15em; text-transform: uppercase;
  color: var(--ochre-light); margin-bottom: 2rem; display: block;
}
.headline { color: #F0EBE3; font-weight: 500; }
.headline em { color: rgba(240,235,227,0.85); font-weight: 400; font-style: italic; }
.subtitle {
  font-family: var(--sans); font-size: 1rem; line-height: 1.8;
  color: rgba(240,235,227,0.65); max-width: 500px; margin: 0 auto;
}
.subtitle em { color: rgba(240,235,227,0.8); }
.begin-btn {
  display: inline-block; margin-top: 3rem; padding: 1rem 3rem;
  background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light);
  border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500;
  cursor: pointer; transition: all 0.3s ease; letter-spacing: 0.05em;
  -webkit-tap-highlight-color: transparent;
}
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
VUEEOF

echo "  ✓ Opening.vue"

# ── BestPeriod ──
cat > src/components/experiences/exp03/BestPeriod.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your own evidence</p>
    <h2 class="display-medium">Think about the best sustained period of your life.</h2>
    <Divider />
    <p class="body-text-large">Not a single happy moment — a stretch where things were genuinely working. A time when you felt like the version of yourself you were meant to be.</p>
    <p class="body-text">What was present during that time? Select everything that applies.</p>

    <div class="conditions">
      <button
        v-for="c in conditions"
        :key="c.id"
        class="condition-card"
        :class="{ selected: selected.includes(c.id) }"
        @click="toggle(c.id)"
      >
        <span class="condition-check">{{ selected.includes(c.id) ? '✓' : '' }}</span>
        <span class="condition-text">{{ c.label }}</span>
      </button>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="selected.length === 0"
      @back="$emit('back')"
      @continue="emitAndAdvance"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'

const emit = defineEmits(['advance', 'back', 'select-conditions'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const conditions = [
  { id: 'safety', label: 'I felt safe — physically and emotionally secure' },
  { id: 'autonomy', label: 'I had control over my own choices and direction' },
  { id: 'connection', label: 'I was surrounded by people I trusted and who trusted me' },
  { id: 'competence', label: 'I was building something, learning, or doing meaningful work' },
  { id: 'purpose', label: 'I had a clear sense of purpose or direction' },
  { id: 'opportunity', label: 'I had the time and resources to pursue what mattered to me' }
]

const selected = ref([])

function toggle(id) {
  const idx = selected.value.indexOf(id)
  if (idx === -1) {
    selected.value.push(id)
  } else {
    selected.value.splice(idx, 1)
  }
}

function emitAndAdvance() {
  emit('select-conditions', [...selected.value])
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.conditions { margin: 2rem 0 1rem; }

.condition-card {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  width: 100%;
  padding: 1rem 1.25rem;
  margin-bottom: 0.6rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  font-family: inherit;
  font-size: 0.95rem;
  line-height: 1.5;
  color: var(--ink);
  box-shadow: var(--shadow-soft);
  -webkit-tap-highlight-color: transparent;
}

.condition-card:hover {
  border-color: var(--ochre);
  box-shadow: var(--shadow-hover);
}

.condition-card.selected {
  border-color: var(--ochre);
  background: var(--ochre-faint);
}

.condition-check {
  flex-shrink: 0;
  width: 22px;
  height: 22px;
  border: 1.5px solid var(--border-subtle);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  color: var(--ochre);
  transition: all 0.2s ease;
  margin-top: 1px;
}

.condition-card.selected .condition-check {
  background: var(--ochre);
  border-color: var(--ochre);
  color: white;
}

.condition-text {
  flex: 1;
}

@media (max-width: 480px) {
  .condition-card {
    padding: 0.85rem 1rem;
    font-size: 0.9rem;
  }
}
</style>
VUEEOF

echo "  ✓ BestPeriod.vue"

# ── ThePattern ──
cat > src/components/experiences/exp03/ThePattern.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The pattern in your answer</p>
    <h2 class="display-medium">You just described what scientists call human flourishing.</h2>
    <Divider />

    <p class="body-text-large">The conditions you selected aren't random. They map to six pillars that researchers across psychology, neuroscience, economics, and philosophy have independently identified as the architecture of human well-being.</p>

    <div class="pillars">
      <div v-for="p in pillars" :key="p.id" class="pillar" :class="{ highlighted: isSelected(p.id) }">
        <div class="pillar-marker">{{ isSelected(p.id) ? '●' : '○' }}</div>
        <div class="pillar-content">
          <div class="pillar-name">{{ p.name }}</div>
          <div class="pillar-desc">{{ p.desc }}</div>
          <div v-if="isSelected(p.id)" class="pillar-yours">You identified this from your own life.</div>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>These aren't philosophical abstractions. They're the conditions that were present when <em>you</em> were at your best. And they're universal — every human being, across every culture and era, flourishes under these same conditions.</p>
    </ContentBlock>

    <p class="body-text">This matters because it means flourishing isn't a matter of opinion. It's an observable, measurable pattern in human nature. And anything that systematically undermines these conditions systematically undermines human well-being.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const selectedConditions = inject('selectedConditions', ref([]))

const pillars = [
  { id: 'safety', name: 'Safety', desc: 'The absence of credible threat to your body or well-being.' },
  { id: 'autonomy', name: 'Autonomy', desc: 'The freedom to direct your own life and make your own choices.' },
  { id: 'connection', name: 'Connection', desc: 'Relationships of trust, belonging, and mutual support.' },
  { id: 'competence', name: 'Competence', desc: 'The ability to act effectively — to build, create, and grow.' },
  { id: 'purpose', name: 'Purpose', desc: 'A sense that your life is coherent, valuable, and worth pursuing.' },
  { id: 'opportunity', name: 'Opportunity', desc: 'Access to the time, tools, and resources that make growth possible.' }
]

function isSelected(id) {
  return selectedConditions.value.includes(id)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.pillars {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.pillar {
  display: flex;
  gap: 0.75rem;
  padding: 1rem 1.25rem;
  border-radius: var(--radius);
  border: 1px solid var(--border-subtle);
  background: var(--cream);
  transition: all 0.3s ease;
}

.pillar.highlighted {
  border-color: var(--ochre);
  background: var(--ochre-faint);
}

.pillar-marker {
  flex-shrink: 0;
  font-size: 0.7rem;
  color: var(--ochre);
  margin-top: 0.25rem;
}

.pillar-content { flex: 1; }

.pillar-name {
  font-family: var(--serif);
  font-size: 1rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.2rem;
}

.pillar-desc {
  font-size: 0.85rem;
  color: var(--ink-muted);
  line-height: 1.5;
}

.pillar-yours {
  font-size: 0.75rem;
  color: var(--ochre);
  margin-top: 0.35rem;
  font-style: italic;
}

@media (max-width: 480px) {
  .pillar { padding: 0.85rem 1rem; }
}
</style>
VUEEOF

echo "  ✓ ThePattern.vue"

# ── WorstPeriod ──
cat > src/components/experiences/exp03/WorstPeriod.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The inverse</p>
    <h2 class="display-medium">Now consider the hardest sustained period of your life.</h2>
    <Divider />
    <p class="body-text-large">A stretch where things weren't working. Where you felt diminished, stuck, or struggling. Not a bad day — a bad chapter.</p>
    <p class="body-text">What was being violated or missing? Select what applies.</p>

    <div class="violations">
      <button
        v-for="v in violations"
        :key="v.id"
        class="violation-card"
        :class="{ selected: selected.includes(v.id) }"
        @click="toggle(v.id)"
      >
        <span class="violation-check">{{ selected.includes(v.id) ? '✓' : '' }}</span>
        <div class="violation-content">
          <span class="violation-text">{{ v.label }}</span>
          <span class="violation-domain">{{ v.domain }}</span>
        </div>
      </button>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="selected.length === 0"
      @back="$emit('back')"
      @continue="emitAndAdvance"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'

const emit = defineEmits(['advance', 'back', 'select-violations'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const violations = [
  { id: 'body-unsafe', label: 'My physical safety was threatened or compromised', domain: 'Body' },
  { id: 'body-fear', label: 'I lived with persistent fear or anxiety about harm', domain: 'Body' },
  { id: 'resources-taken', label: 'My money, property, or resources were taken or unstable', domain: 'Resources' },
  { id: 'resources-insecure', label: 'I couldn\'t plan for the future because my material foundation was shaky', domain: 'Resources' },
  { id: 'time-controlled', label: 'Someone else controlled how I spent my time', domain: 'Time' },
  { id: 'time-wasted', label: 'I was forced to spend my hours on things I didn\'t choose', domain: 'Time' },
  { id: 'time-trapped', label: 'I felt trapped — unable to direct my own life', domain: 'Time' }
]

const selected = ref([])

function toggle(id) {
  const idx = selected.value.indexOf(id)
  if (idx === -1) {
    selected.value.push(id)
  } else {
    selected.value.splice(idx, 1)
  }
}

function emitAndAdvance() {
  emit('select-violations', [...selected.value])
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.violations { margin: 2rem 0 1rem; }

.violation-card {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  width: 100%;
  padding: 1rem 1.25rem;
  margin-bottom: 0.6rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  font-family: inherit;
  font-size: 0.95rem;
  line-height: 1.5;
  color: var(--ink);
  box-shadow: var(--shadow-soft);
  -webkit-tap-highlight-color: transparent;
}

.violation-card:hover {
  border-color: var(--concede-warm);
  box-shadow: var(--shadow-hover);
}

.violation-card.selected {
  border-color: var(--concede-warm);
  background: var(--concede-bg);
}

.violation-check {
  flex-shrink: 0;
  width: 22px;
  height: 22px;
  border: 1.5px solid var(--border-subtle);
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  color: var(--concede-warm);
  transition: all 0.2s ease;
  margin-top: 1px;
}

.violation-card.selected .violation-check {
  background: var(--concede-warm);
  border-color: var(--concede-warm);
  color: white;
}

.violation-content { flex: 1; }
.violation-text { display: block; }
.violation-domain {
  display: block;
  font-size: 0.75rem;
  color: var(--ink-faint);
  margin-top: 0.2rem;
  font-style: italic;
}

@media (max-width: 480px) {
  .violation-card {
    padding: 0.85rem 1rem;
    font-size: 0.9rem;
  }
}
</style>
VUEEOF

echo "  ✓ WorstPeriod.vue"

# ── ThreeDomains ──
cat > src/components/experiences/exp03/ThreeDomains.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The structure of what went wrong</p>
    <h2 class="display-medium">Every violation you identified falls into one of three domains.</h2>
    <Divider />

    <p class="body-text-large">The conditions that suppressed your flourishing weren't random. They attacked specific dimensions of your life — the same three dimensions that, when respected, make flourishing possible.</p>

    <div class="domains">
      <div class="domain" :class="{ active: hasBody }">
        <div class="domain-header">
          <div class="domain-icon">I</div>
          <div>
            <div class="domain-name">Bodily Integrity</div>
            <div class="domain-imperative">Respect the Body: Do not harm.</div>
          </div>
        </div>
        <p class="domain-desc">Your body is the seat of all experience. When it is unsafe — when you face violence, threats, or the fear of harm — your nervous system shifts into survival mode. Creativity shuts down. Trust collapses. Long-term thinking becomes impossible. Safety isn't a luxury. It's the precondition for everything else.</p>
        <div v-if="hasBody" class="domain-yours">You experienced this.</div>
      </div>

      <div class="domain" :class="{ active: hasResources }">
        <div class="domain-header">
          <div class="domain-icon">II</div>
          <div>
            <div class="domain-name">Material Integrity</div>
            <div class="domain-imperative">Respect Resources: Do not steal.</div>
          </div>
        </div>
        <p class="domain-desc">Your property isn't just stuff. It's crystallized time — the physical form of hours, days, and years of effort. When resources are taken or destabilized, you lose not just things but the capacity to plan, build, and shape your future. Material security is the quiet engine of flourishing.</p>
        <div v-if="hasResources" class="domain-yours">You experienced this.</div>
      </div>

      <div class="domain" :class="{ active: hasTime }">
        <div class="domain-header">
          <div class="domain-icon">III</div>
          <div>
            <div class="domain-name">Temporal Integrity</div>
            <div class="domain-imperative">Respect Time: Do not coerce.</div>
          </div>
        </div>
        <p class="domain-desc">Time is the only truly non-renewable resource. It cannot be replaced, replenished, stored, or compensated. Every moment of coerced activity is a moment of life permanently redirected. When someone controls your time, they don't just inconvenience you — they consume the irreplaceable substance of your existence.</p>
        <div v-if="hasTime" class="domain-yours">You experienced this.</div>
      </div>
    </div>

    <ContentBlock variant="principle">
      <p>These three domains — body, resources, and time — form the complete architecture of a human life. When all three are respected, people flourish. When any is violated, flourishing predictably declines.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const selectedViolations = inject('selectedViolations', ref([]))

const hasBody = computed(() =>
  selectedViolations.value.some(v => v.startsWith('body'))
)
const hasResources = computed(() =>
  selectedViolations.value.some(v => v.startsWith('resources'))
)
const hasTime = computed(() =>
  selectedViolations.value.some(v => v.startsWith('time'))
)
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.domains {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.domain {
  padding: 1.5rem;
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  background: var(--cream);
  transition: all 0.3s ease;
}

.domain.active {
  border-color: var(--ochre);
  background: var(--ochre-faint);
}

.domain-header {
  display: flex;
  gap: 0.75rem;
  align-items: flex-start;
  margin-bottom: 0.75rem;
}

.domain-icon {
  flex-shrink: 0;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: var(--paper-deep);
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: var(--serif);
  font-size: 0.75rem;
  font-weight: 500;
  color: var(--ink-muted);
  margin-top: 2px;
}

.domain.active .domain-icon {
  background: var(--ochre);
  color: white;
}

.domain-name {
  font-family: var(--serif);
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--ink);
  line-height: 1.3;
}

.domain-imperative {
  font-size: 0.8rem;
  color: var(--ink-muted);
  font-style: italic;
  margin-top: 0.15rem;
}

.domain-desc {
  font-size: 0.9rem;
  color: var(--ink-soft);
  line-height: 1.7;
  margin: 0;
}

.domain-yours {
  font-size: 0.8rem;
  color: var(--ochre);
  margin-top: 0.75rem;
  font-style: italic;
}

@media (max-width: 480px) {
  .domain { padding: 1.25rem; }
  .domain-desc { font-size: 0.85rem; }
}
</style>
VUEEOF

echo "  ✓ ThreeDomains.vue"

# ── FlourishingPrinciple ──
cat > src/components/experiences/exp03/FlourishingPrinciple.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The principle, grounded</p>
    <h2 class="display-medium">This is what the Philosophy of Human Respect is actually saying.</h2>
    <Divider />

    <p class="body-text-large">In Experience 01, you encountered the principle as a claim. Now you can see where it comes from — not from ideology, but from the observable structure of human well-being.</p>

    <ContentBlock variant="principle">
      <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
      <p style="margin-top: 1rem;">Therefore, the ethical foundation of society is the full respect for each person's body, resources, and time.</p>
    </ContentBlock>

    <p class="body-text">This isn't a political position. It's a statement about cause and effect — the same kind of statement as "plants grow toward light" or "trust increases cooperation." It describes a pattern that holds across cultures, eras, and individual lives.</p>

    <p class="body-text">Including yours. The best period of your life had these conditions present. The worst period had them violated. That's not a coincidence — it's the pattern the principle describes.</p>

    <ContentBlock variant="insight">
      <p>What makes this different from other moral frameworks is the grounding. This isn't "coercion is wrong because rights exist" — a claim that requires accepting a metaphysical premise. This is "coercion is wrong because it predictably damages human flourishing" — a claim you can test against your own experience and the evidence of every society in history.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ FlourishingPrinciple.vue"

# ── TheBridge ──
cat > src/components/experiences/exp03/TheBridge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The foundation is complete</p>
    <h2 class="display-medium">You now have the complete framework.</h2>
    <Divider />

    <div class="foundation-summary">
      <div class="foundation-item">
        <span class="foundation-number">01</span>
        <div>
          <div class="foundation-title">The gap</div>
          <p class="foundation-desc">Most people hold one moral standard for personal life and a different one for politics.</p>
        </div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">02</span>
        <div>
          <div class="foundation-title">The objection</div>
          <p class="foundation-desc">The strongest counterarguments, taken seriously and honestly conceded where necessary.</p>
        </div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">03</span>
        <div>
          <div class="foundation-title">The grounding</div>
          <p class="foundation-desc">Flourishing is real, measurable, and sensitive to three domains — body, resources, and time. Coercion violates all three.</p>
        </div>
      </div>
    </div>

    <p class="body-text-large" style="margin-top: 2rem;">From here, the philosophy goes deeper. Each of the three domains has implications that reshape how you think about justice, economics, community, and the role of institutions in human life.</p>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Go deeper</p>

      <PathCard :to="{ name: 'home' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>The philosophy's most original insight: time is the irreplaceable substance of life, and every form of coercion is ultimately a theft of time. Coming soon.</template>
      </PathCard>

      <PathCard :to="{ name: 'home' }">
        <template #title>The Method Is the Message</template>
        <template #desc>Your values aren't the problem — progressive or conservative, they're both genuine. The question is whether you advance them through persuasion or force. Coming soon.</template>
      </PathCard>

      <PathCard :to="{ name: 'home' }">
        <template #title>Cooperation Is a Technology</template>
        <template #desc>Voluntary cooperation isn't just morally superior to coercion — it's more effective. Real examples of people solving "impossible" problems without force. Coming soon.</template>
      </PathCard>
    </div>

    <div style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Or revisit</p>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>Experience 01: The Question</template>
        <template #desc>The thought experiment that started it all.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp02' }">
        <template #title>Experience 02: The Objection</template>
        <template #desc>Your strongest pushback, honestly examined.</template>
      </PathCard>
    </div>

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">
      The Philosophy of Human Respect — articulated by Chris J. Rufer
    </p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import PathCard from '@/components/shared/PathCard.vue'

const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.foundation-summary {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.foundation-item {
  display: flex;
  gap: 1rem;
  align-items: flex-start;
}

.foundation-number {
  flex-shrink: 0;
  font-family: var(--serif);
  font-size: 0.85rem;
  font-weight: 400;
  color: var(--ochre);
  margin-top: 0.15rem;
}

.foundation-title {
  font-family: var(--serif);
  font-size: 1.05rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.2rem;
}

.foundation-desc {
  font-size: 0.88rem;
  color: var(--ink-muted);
  line-height: 1.6;
  margin: 0;
}
</style>
VUEEOF

echo "  ✓ TheBridge.vue"

# ══════════════════════════════════════
# UPDATE EXPERIENCE 02 CLOSING TO LINK TO EXP 03
# ══════════════════════════════════════

cat > src/components/experiences/exp02/WhereNext.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">You examined one objection. There are others.</h2>
    <Divider />
    <p class="body-text-large">Each of the other objections gets the same treatment — steelmanned, responded to, conceded where honesty requires, and left as an open question. You might find that one of them changes your mind where this one didn't.</p>

    <div style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore another objection</p>
      <PathCard
        v-for="key in otherObjections"
        :key="key"
        href="#"
        @click.prevent="$emit('restart-with', key)"
      >
        <template #title>{{ allObjections[key].title }}</template>
        <template #desc>Explore this objection with the same honesty.</template>
      </PathCard>
    </div>

    <div style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Or go deeper</p>
      <PathCard :to="{ name: 'exp03' }">
        <template #title>What flourishing actually means</template>
        <template #desc>The empirical grounding for the principle — why coercion damages human well-being, drawn from your own experience.</template>
      </PathCard>
      <PathCard href="#" @click.prevent="$emit('share')">
        <template #title>Share this with someone who disagrees</template>
        <template #desc>See which objection they choose — and whether the response holds up for them too.</template>
      </PathCard>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import PathCard from '@/components/shared/PathCard.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections as allObjections } from './objectionData.js'

defineEmits(['restart-with', 'share'])
const journey = useJourneyStore()
const otherObjections = computed(() =>
  Object.keys(allObjections).filter(k => k !== journey.exp02.chosenObjection)
)
const el = ref(null)
onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  journey.completeExp02(journey.exp02.chosenObjection, null)
})
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
VUEEOF

echo "  ✓ Exp02 WhereNext updated with link to Exp 03"

echo ""
echo "✅ Experience 03 complete!"
echo ""
echo "Files created/updated:"
echo "  src/router/index.js (added /experience/flourishing)"
echo "  src/pages/Experience03.vue"
echo "  src/components/experiences/exp03/Opening.vue"
echo "  src/components/experiences/exp03/BestPeriod.vue"
echo "  src/components/experiences/exp03/ThePattern.vue"
echo "  src/components/experiences/exp03/WorstPeriod.vue"
echo "  src/components/experiences/exp03/ThreeDomains.vue"
echo "  src/components/experiences/exp03/FlourishingPrinciple.vue"
echo "  src/components/experiences/exp03/TheBridge.vue"
echo "  src/components/experiences/exp02/WhereNext.vue (updated)"
echo ""
echo "Push with: git add . && git commit -m 'exp03: what flourishing actually means' && git push"
