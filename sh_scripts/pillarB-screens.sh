#!/bin/bash
# Creates Pillar B: "Your Time Is Your Life" — Temporal Integrity
# Run from humanrespect-app/ root

set -e

mkdir -p src/components/experiences/pillarB

echo "🏗️  Building Pillar B: Your Time Is Your Life..."

# ══════════════════════════════════════
# ROUTE — update router
# ══════════════════════════════════════

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
    path: '/pillar/your-time-is-your-life',
    name: 'pillarB',
    component: () => import('@/pages/PillarB.vue')
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

echo "  ✓ Router updated"

# ══════════════════════════════════════
# PAGE ORCHESTRATOR
# ══════════════════════════════════════

cat > src/pages/PillarB.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="screenKey"
          @advance="advance"
          @back="goBack"
          @set-income="handleIncome"
          @set-rate="handleRate"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'

import Opening from '@/components/experiences/pillarB/Opening.vue'
import TheCalculation from '@/components/experiences/pillarB/TheCalculation.vue'
import TheReframe from '@/components/experiences/pillarB/TheReframe.vue'
import TheHierarchy from '@/components/experiences/pillarB/TheHierarchy.vue'
import TheRecognition from '@/components/experiences/pillarB/TheRecognition.vue'
import TheQuestion from '@/components/experiences/pillarB/TheQuestion.vue'

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])
const income = ref(null)
const taxRate = ref(null)

provide('income', income)
provide('taxRate', taxRate)

const screenComponents = [
  Opening, TheCalculation, TheReframe, TheHierarchy, TheRecognition, TheQuestion
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}`)

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

function handleIncome(val) { income.value = val }
function handleRate(val) { taxRate.value = val }
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

echo "  ✓ PillarB.vue"

# ══════════════════════════════════════
# SCREEN COMPONENTS
# ══════════════════════════════════════

# ── Opening ──
cat > src/components/experiences/pillarB/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Pillar · Temporal Integrity</span>
    <h1 class="display-large headline">
      Your time<br><em>is your life.</em>
    </h1>
    <Divider :centered="true" />
    <p class="subtitle">
      Every moral framework talks about property. Every moral framework talks about
      violence. Almost none talk about the resource that makes both of those matter —
      the one resource you can never get back.
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

# ── TheCalculation ──
cat > src/components/experiences/pillarB/TheCalculation.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">A personal calculation</p>
    <h2 class="display-medium">How many hours of your life go to taxes each year?</h2>
    <Divider />

    <p class="body-text-large">Not the money. The <em>hours</em>. The irreplaceable hours of your one life. Let's find out.</p>

    <div class="calc-inputs">
      <div class="calc-field">
        <label class="calc-label">Your approximate annual income</label>
        <div class="input-row">
          <span class="input-prefix">$</span>
          <input
            type="number"
            class="calc-input"
            placeholder="e.g. 60000"
            :value="localIncome"
            @input="localIncome = Number($event.target.value)"
          />
        </div>
      </div>

      <div class="calc-field">
        <label class="calc-label">Your approximate total tax rate (federal + state + local + payroll)</label>
        <div class="input-row">
          <input
            type="number"
            class="calc-input"
            placeholder="e.g. 30"
            :value="localRate"
            @input="localRate = Number($event.target.value)"
            min="0"
            max="70"
          />
          <span class="input-suffix">%</span>
        </div>
        <p class="calc-hint">Most working Americans pay 25-40% across all taxes combined.</p>
      </div>
    </div>

    <div v-if="hoursPerYear" class="result-block">
      <div class="result-number">{{ hoursPerYear.toLocaleString() }}</div>
      <div class="result-label">hours of your life per year</div>
      <div class="result-context">That's <strong>{{ weeksPerYear }} full work weeks</strong> — spent earning money that goes to someone else's priorities, not yours.</div>

      <div class="lifetime-row">
        <div class="lifetime-stat">
          <div class="lifetime-number">{{ lifetimeHours.toLocaleString() }}</div>
          <div class="lifetime-label">hours over a 40-year career</div>
        </div>
        <div class="lifetime-stat">
          <div class="lifetime-number">{{ lifetimeYears }}</div>
          <div class="lifetime-label">years of full-time work</div>
        </div>
      </div>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!hoursPerYear"
      @back="$emit('back')"
      @continue="emitAndAdvance"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'

const emit = defineEmits(['advance', 'back', 'set-income', 'set-rate'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const localIncome = ref(null)
const localRate = ref(null)

const hourlyRate = computed(() => {
  if (!localIncome.value || localIncome.value <= 0) return null
  return localIncome.value / 2080 // 40hr × 52wk
})

const hoursPerYear = computed(() => {
  if (!hourlyRate.value || !localRate.value || localRate.value <= 0) return null
  const taxAmount = localIncome.value * (localRate.value / 100)
  return Math.round(taxAmount / hourlyRate.value)
})

const weeksPerYear = computed(() => {
  if (!hoursPerYear.value) return null
  return Math.round(hoursPerYear.value / 40)
})

const lifetimeHours = computed(() => {
  if (!hoursPerYear.value) return null
  return hoursPerYear.value * 40
})

const lifetimeYears = computed(() => {
  if (!lifetimeHours.value) return null
  return (lifetimeHours.value / 2080).toFixed(1)
})

function emitAndAdvance() {
  emit('set-income', localIncome.value)
  emit('set-rate', localRate.value)
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.calc-inputs {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.calc-field {}

.calc-label {
  display: block;
  font-size: 0.85rem;
  color: var(--ink-muted);
  margin-bottom: 0.5rem;
}

.input-row {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.input-prefix, .input-suffix {
  font-family: var(--serif);
  font-size: 1.1rem;
  color: var(--ink-muted);
}

.calc-input {
  flex: 1;
  padding: 0.75rem 1rem;
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  font-family: var(--sans);
  font-size: 1rem;
  color: var(--ink);
  background: var(--cream);
  outline: none;
  transition: border-color 0.2s ease;
  -webkit-appearance: none;
}

.calc-input:focus {
  border-color: var(--ochre);
}

.calc-input::placeholder {
  color: var(--ink-faint);
}

.calc-hint {
  font-size: 0.75rem;
  color: var(--ink-faint);
  margin-top: 0.35rem;
  font-style: italic;
}

.result-block {
  background: var(--ochre-faint);
  border: 1px solid var(--ochre);
  border-radius: var(--radius);
  padding: 2rem;
  margin: 2rem 0;
  text-align: center;
}

.result-number {
  font-family: var(--serif);
  font-size: clamp(2.5rem, 6vw, 3.5rem);
  font-weight: 500;
  color: var(--ochre);
  line-height: 1;
}

.result-label {
  font-size: 0.9rem;
  color: var(--ink-muted);
  margin-top: 0.5rem;
}

.result-context {
  font-size: 0.95rem;
  color: var(--ink-soft);
  margin-top: 1.25rem;
  line-height: 1.6;
}

.lifetime-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid rgba(154, 123, 79, 0.2);
}

.lifetime-number {
  font-family: var(--serif);
  font-size: 1.5rem;
  font-weight: 500;
  color: var(--ink);
}

.lifetime-label {
  font-size: 0.75rem;
  color: var(--ink-muted);
  margin-top: 0.25rem;
}

/* Hide number input spinners */
.calc-input::-webkit-outer-spin-button,
.calc-input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
.calc-input[type=number] {
  -moz-appearance: textfield;
}

@media (max-width: 480px) {
  .result-block { padding: 1.5rem; }
  .lifetime-row { gap: 1rem; }
}
</style>
VUEEOF

echo "  ✓ TheCalculation.vue"

# ── TheReframe ──
cat > src/components/experiences/pillarB/TheReframe.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Seeing it differently</p>
    <h2 class="display-medium">Property isn't about stuff. It's about time.</h2>
    <Divider />

    <p class="body-text-large">Every object you own, every dollar you've saved, every asset you've built represents something deeper than its material form. It represents the <em>hours of your life</em> you exchanged to acquire it.</p>

    <ScenarioBox label="Consider">
      <p>A chair required someone's hours of labor. A dollar represents exchanged effort. A home represents years of saving — thousands of mornings getting up and going to work. A business represents decades of risk, creativity, and discipline.</p>
      <p>These aren't just things. They're <strong>crystallized time</strong> — life converted into durable form.</p>
    </ScenarioBox>

    <ContentBlock variant="principle">
      <p>When someone takes your property without consent, they aren't just taking a thing. They're consuming hours of your past — time you invested, time you can never get back — and diminishing the possibilities of your future.</p>
    </ContentBlock>

    <p class="body-text">This reframes the entire question of property. It's not about materialism or greed. It's about the recognition that your resources are the physical form of your irreplaceable life-hours. To respect someone's property is to respect the time they spent earning it — which is to respect their life itself.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
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

echo "  ✓ TheReframe.vue"

# ── TheHierarchy ──
cat > src/components/experiences/pillarB/TheHierarchy.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The hierarchy of irreversibility</p>
    <h2 class="display-medium">Not all losses are equal.</h2>
    <Divider />

    <p class="body-text-large">There's a hierarchy among the things that can be taken from you, and it's determined by one question: <em>can it be restored?</em></p>

    <div class="hierarchy">
      <div class="hierarchy-item level-3">
        <div class="hierarchy-bar"></div>
        <div class="hierarchy-content">
          <div class="hierarchy-label">Money</div>
          <p>Can be re-earned. Losses are recoverable. A financial setback is painful but not permanent.</p>
        </div>
      </div>
      <div class="hierarchy-item level-2">
        <div class="hierarchy-bar"></div>
        <div class="hierarchy-content">
          <div class="hierarchy-label">Property</div>
          <p>Harder to replace. A destroyed home, a stolen business, a wiped savings account — these take years to rebuild. But rebuilding is possible.</p>
        </div>
      </div>
      <div class="hierarchy-item level-1">
        <div class="hierarchy-bar"></div>
        <div class="hierarchy-content">
          <div class="hierarchy-label">Time</div>
          <p>Cannot be replaced. Cannot be replenished. Cannot be stored. Cannot be compensated. Once a moment is taken, it is gone from your life permanently.</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>This is why coercion — the theft of time — is the deepest violation. No payment can restore a stolen hour. No policy can return a wasted year. No compensation can un-live the life someone was forced to live instead of the one they would have chosen.</p>
    </ContentBlock>

    <p class="body-text">Money flows from property. Property flows from time. Time flows from nothing — it is the original resource, the source of all others. To steal someone's time is to steal the only resource that makes all others possible.</p>

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

.hierarchy {
  margin: 2.5rem 0;
  display: flex;
  flex-direction: column;
  gap: 0;
}

.hierarchy-item {
  display: flex;
  gap: 1.25rem;
  padding: 1.5rem 0;
  border-bottom: 1px solid var(--border-subtle);
}

.hierarchy-item:last-child {
  border-bottom: none;
}

.hierarchy-bar {
  flex-shrink: 0;
  width: 4px;
  border-radius: 2px;
  min-height: 60px;
}

.level-3 .hierarchy-bar { background: var(--border-subtle); }
.level-2 .hierarchy-bar { background: var(--ochre-light); opacity: 0.5; }
.level-1 .hierarchy-bar { background: var(--ochre); }

.hierarchy-content { flex: 1; }

.hierarchy-label {
  font-family: var(--serif);
  font-size: 1.15rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.35rem;
}

.level-1 .hierarchy-label {
  color: var(--ochre);
}

.hierarchy-content p {
  font-size: 0.9rem;
  color: var(--ink-soft);
  line-height: 1.7;
  margin: 0;
}

@media (max-width: 480px) {
  .hierarchy-item { padding: 1.25rem 0; gap: 1rem; }
}
</style>
VUEEOF

echo "  ✓ TheHierarchy.vue"

# ── TheRecognition ──
cat > src/components/experiences/pillarB/TheRecognition.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Seeing coercion clearly</p>
    <h2 class="display-medium">Every mandate is a claim on your life.</h2>
    <Divider />

    <p class="body-text-large">Once you see time as the fundamental human resource, forms of coercion that seemed routine begin to look different.</p>

    <div class="recognitions">
      <div class="recognition-item">
        <div class="recognition-surface">A tax</div>
        <div class="recognition-arrow">→</div>
        <div class="recognition-deep">A claim on the hours you spent earning that money</div>
      </div>
      <div class="recognition-item">
        <div class="recognition-surface">A regulation</div>
        <div class="recognition-arrow">→</div>
        <div class="recognition-deep">Hours spent complying instead of building, creating, or resting</div>
      </div>
      <div class="recognition-item">
        <div class="recognition-surface">A mandate</div>
        <div class="recognition-arrow">→</div>
        <div class="recognition-deep">Your life-hours redirected toward someone else's priorities</div>
      </div>
      <div class="recognition-item">
        <div class="recognition-surface">A bureaucratic process</div>
        <div class="recognition-arrow">→</div>
        <div class="recognition-deep">Irreplaceable moments consumed by procedures you didn't choose</div>
      </div>
      <div class="recognition-item">
        <div class="recognition-surface">A prison sentence</div>
        <div class="recognition-arrow">→</div>
        <div class="recognition-deep">Years of a human life permanently confiscated</div>
      </div>
    </div>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>This doesn't mean every claim on your time is unjust. You voluntarily trade time for wages. You choose to spend time on relationships, community, and obligations you value. The moral line isn't between "spending time" and "not spending time." It's between <em>choosing</em> how to spend your time and having that choice <em>made for you by someone else under threat of punishment</em>.</p>
    </ContentBlock>

    <p class="body-text">The question isn't whether society needs coordination. It's whether that coordination must come through coercion — the involuntary seizure of life-hours — or whether it can emerge from voluntary cooperation, where every participant has chosen to contribute their time.</p>

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

.recognitions {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.recognition-item {
  display: grid;
  grid-template-columns: 1fr auto 1.8fr;
  gap: 0.75rem;
  align-items: center;
  padding: 1rem 1.25rem;
  background: var(--cream);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius);
}

.recognition-surface {
  font-family: var(--serif);
  font-size: 0.95rem;
  font-weight: 500;
  color: var(--ink);
}

.recognition-arrow {
  color: var(--ochre);
  font-size: 0.85rem;
}

.recognition-deep {
  font-size: 0.85rem;
  color: var(--ink-soft);
  line-height: 1.5;
  font-style: italic;
}

@media (max-width: 480px) {
  .recognition-item {
    grid-template-columns: 1fr;
    gap: 0.25rem;
    padding: 0.85rem 1rem;
  }
  .recognition-arrow { display: none; }
  .recognition-surface { font-size: 0.9rem; }
  .recognition-deep { font-size: 0.8rem; }
}
</style>
VUEEOF

echo "  ✓ TheRecognition.vue"

# ── TheQuestion ──
cat > src/components/experiences/pillarB/TheQuestion.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">What is a system built on compulsory participation?</h2>
    <Divider />

    <p class="body-text-large">If time is the most fundamental human resource — the irreplaceable substance of your one life — and if coercion is the involuntary redirection of that time toward goals you didn't choose...</p>

    <ContentBlock variant="principle">
      <p>...then a political system that operates by taking people's time without their individual consent is not merely inefficient or unfortunate. It is consuming the very substance of human life.</p>
    </ContentBlock>

    <p class="body-text">This doesn't make the people in government evil. It doesn't make voters complicit in a crime. It means the <em>system</em> — the mechanism of compulsory participation — is misaligned with what human beings actually need to flourish. And it means the search for voluntary alternatives isn't utopian idealism. It's the most practical thing we could possibly do.</p>

    <div class="closing-question-block">
      <p class="closing-question">If your time is your life, and no one has the right to take your life — then who has the right to take your time?</p>
    </div>

    <ContentBlock variant="insight">
      <p>No major moral philosophy has placed time at the center of its framework this way. The Philosophy of Human Respect does — because once you see property as crystallized time and coercion as life-theft, every political question looks fundamentally different.</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'exp03' }">
        <template #title>Revisit: What Flourishing Actually Means</template>
        <template #desc>The full framework — Safety, Autonomy, Connection, Competence, Purpose, and Opportunity.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp01' }">
        <template #title>Revisit: The Original Question</template>
        <template #desc>The thought experiment that started everything — now with a deeper understanding of what's at stake.</template>
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
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'

const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.closing-question-block {
  margin: 2.5rem 0;
  text-align: center;
  padding: 2rem 1.5rem;
}

.closing-question {
  font-family: var(--serif);
  font-size: clamp(1.3rem, 3vw, 1.7rem);
  line-height: 1.45;
  color: var(--ink);
  font-style: italic;
  font-weight: 400;
}
</style>
VUEEOF

echo "  ✓ TheQuestion.vue"

# ══════════════════════════════════════
# UPDATE EXP03 BRIDGE TO LINK TO PILLAR B
# ══════════════════════════════════════

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

      <PathCard :to="{ name: 'pillarB' }">
        <template #title>Your Time Is Your Life</template>
        <template #desc>The philosophy's most original insight: time is the irreplaceable substance of life, and every form of coercion is ultimately a theft of time.</template>
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

echo "  ✓ Exp03 TheBridge rewritten with Pillar B link"

echo ""
echo "✅ Pillar B complete!"
echo ""
echo "Files created/updated:"
echo "  src/router/index.js (added /pillar/your-time-is-your-life)"
echo "  src/pages/PillarB.vue"
echo "  src/components/experiences/pillarB/Opening.vue"
echo "  src/components/experiences/pillarB/TheCalculation.vue"
echo "  src/components/experiences/pillarB/TheReframe.vue"
echo "  src/components/experiences/pillarB/TheHierarchy.vue"
echo "  src/components/experiences/pillarB/TheRecognition.vue"
echo "  src/components/experiences/pillarB/TheQuestion.vue"
echo "  src/components/experiences/exp03/TheBridge.vue (updated)"
echo ""
echo "Push with: git add . && git commit -m 'pillar B: your time is your life' && git push"
