#!/bin/bash
# Three engagement improvements:
# 1. Exp02: Active reflection after objection response
# 2. Practice01: Interactive footprint with visual output
# 3. Foundation milestone page (/milestone)
# Run from humanrespect-app/ root

set -e

echo "🚀 Building engagement improvements..."

# ══════════════════════════════════════
# 1. EXP02: ADD REFLECTION SCREEN
# New "YourVerdict" between TheQuestion and WhereNext
# ══════════════════════════════════════

cat > src/components/experiences/exp02/YourVerdict.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your assessment</p>
    <h2 class="display-medium">You've seen the steelman, the response, and the honest concession.</h2>
    <Divider />
    <p class="body-text-large">Where do you land?</p>

    <div class="verdicts">
      <button
        v-for="v in verdicts"
        :key="v.id"
        class="verdict-card"
        :class="{ selected: chosen === v.id }"
        @click="choose(v.id)"
      >
        <div class="verdict-label">{{ v.label }}</div>
        <div class="verdict-desc">{{ v.desc }}</div>
      </button>
    </div>

    <div v-if="chosen" class="response-block stagger" ref="responseEl">
      <ContentBlock v-if="chosen === 'addressed'" variant="insight">
        <p>That's worth sitting with. Not because you should agree with every detail, but because a philosophy that can survive your strongest objection has earned your further attention.</p>
      </ContentBlock>
      <ContentBlock v-if="chosen === 'partial'" variant="insight">
        <p>That's a fair assessment. The philosophy doesn't claim to have a perfect answer to every objection. What it claims is that the <em>direction</em> — toward voluntary cooperation and away from force — produces better outcomes than the alternative. Partial answers can still point in the right direction.</p>
      </ContentBlock>
      <ContentBlock v-if="chosen === 'not-addressed'" variant="concession" label="Acknowledged">
        <p>That's an honest answer, and it matters. If the philosophy can't adequately address your core concern, you shouldn't pretend it did. You might find that the deeper experiences address aspects the response missed, or you might conclude that this particular objection remains a genuine limitation. Either way, your honesty makes the conversation better.</p>
      </ContentBlock>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!chosen"
      @back="$emit('back')"
      @continue="$emit('advance')"
    />
  </div>
</template>

<script setup>
import { ref, nextTick, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'
import { useJourneyStore } from '@/stores/journey'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const journey = useJourneyStore()
const el = ref(null)
const responseEl = ref(null)
const chosen = ref(null)

onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const verdicts = [
  {
    id: 'addressed',
    label: 'My objection was addressed.',
    desc: 'The response was substantive and the concession was honest. I\'m willing to explore further.'
  },
  {
    id: 'partial',
    label: 'Partially addressed.',
    desc: 'Some points landed, but I still have reservations. The concession helped.'
  },
  {
    id: 'not-addressed',
    label: 'Not adequately addressed.',
    desc: 'My core concern remains. The response didn\'t resolve it.'
  }
]

function choose(id) {
  chosen.value = id
  trackChoice('exp02', 'verdict', id)
  nextTick(() => {
    if (responseEl.value) {
      responseEl.value.classList.add('animate')
    }
  })
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.verdicts { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.75rem; }
.verdict-card {
  display: block;
  width: 100%;
  padding: 1.1rem 1.35rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  font-family: inherit;
  color: var(--ink);
  -webkit-tap-highlight-color: transparent;
}
.verdict-card:hover { border-color: var(--ochre); }
.verdict-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.verdict-label { font-family: var(--serif); font-size: 1.05rem; font-weight: 500; }
.verdict-desc { font-size: 0.82rem; color: var(--ink-muted); margin-top: 0.25rem; line-height: 1.55; }
.verdict-card.selected .verdict-label { color: var(--ink); }
.response-block { margin-top: 1.5rem; }
</style>
VUEEOF

echo "  ✓ Exp02 YourVerdict screen"

# Update Experience02.vue to include the new screen
cat > src/pages/Experience02.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="screenKey"
          @advance="advance"
          @back="goBack"
          @choose-objection="handleObjectionChoice"
          @restart-with="restartWith"
          @share="handleShare"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/exp02/Opening.vue'
import ChooseObjection from '@/components/experiences/exp02/ChooseObjection.vue'
import Steelman from '@/components/experiences/exp02/Steelman.vue'
import Response from '@/components/experiences/exp02/Response.vue'
import Concession from '@/components/experiences/exp02/Concession.vue'
import TheQuestion from '@/components/experiences/exp02/TheQuestion.vue'
import YourVerdict from '@/components/experiences/exp02/YourVerdict.vue'
import WhereNext from '@/components/experiences/exp02/WhereNext.vue'

const journey = useJourneyStore()
const { trackScreenView, trackChoice, trackShare } = useAnalytics()

const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, ChooseObjection, Steelman, Response, Concession, TheQuestion, YourVerdict, WhereNext
]

const screenNames = [
  'opening', 'choose-objection', 'steelman', 'response', 'concession', 'the-question', 'your-verdict', 'where-next'
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${journey.exp02.chosenObjection}`)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => trackScreenView('exp02', screenNames[idx]))

function advance() {
  if (currentScreen.value < screenComponents.length - 1) {
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

function handleObjectionChoice(key) {
  journey.exp02.chosenObjection = key
  journey.persist()
  trackChoice('exp02', 'objection', key)
}

function restartWith(key) {
  journey.exp02.chosenObjection = key
  journey.persist()
  trackChoice('exp02', 'objection-restart', key)
  currentScreen.value = 2
  history.value = [0, 1, 2]
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function handleShare(method) {
  trackShare(method, 'exp02')
}
</script>

<style scoped>
.exp-app { min-height: 100vh; background: var(--paper); transition: background 0.6s ease; }
.exp-app.dark-mode { background: var(--bg-dark); }
.exp-container { max-width: 640px; margin: 0 auto; padding: 4rem 1.5rem; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.35s ease, transform 0.35s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(12px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-container { padding: 3rem 1rem; } }
</style>
VUEEOF

# Update StepDots count in existing Exp02 screens to reflect 8 total
for file in src/components/experiences/exp02/Steelman.vue \
            src/components/experiences/exp02/Response.vue \
            src/components/experiences/exp02/Concession.vue \
            src/components/experiences/exp02/TheQuestion.vue; do
  if [ -f "$file" ]; then
    sed -i.bak 's/:total="7"/:total="8"/g' "$file"
    rm -f "${file}.bak"
  fi
done

# Update WhereNext to total 8
if [ -f "src/components/experiences/exp02/WhereNext.vue" ]; then
  sed -i.bak 's/:current="6" :total="7"/:current="7" :total="8"/g' src/components/experiences/exp02/WhereNext.vue
  rm -f src/components/experiences/exp02/WhereNext.vue.bak
fi

echo "  ✓ Exp02 page updated (8 screens, verdict after TheQuestion)"

# ══════════════════════════════════════
# 2. PRACTICE 01: INTERACTIVE POLITICAL FOOTPRINT
# Real checklist → visual output → reflection
# ══════════════════════════════════════

# Update the page to 5 screens
cat > src/pages/Practice01.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="currentScreen"
          @advance="advance"
          @back="goBack"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, provide, watch } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/practice01/Opening.vue'
import TheMapping from '@/components/experiences/practice01/TheMapping.vue'
import YourFootprint from '@/components/experiences/practice01/YourFootprint.vue'
import TheChallenge from '@/components/experiences/practice01/TheChallenge.vue'
import TheReflection from '@/components/experiences/practice01/TheReflection.vue'

const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 5
const currentScreen = ref(0)
const history = ref([0])
const selectedAreas = ref([])

provide('selectedAreas', selectedAreas)

const screenComponents = [Opening, TheMapping, YourFootprint, TheChallenge, TheReflection]
const screenNames = ['opening', 'mapping', 'footprint', 'challenge', 'reflection']

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('practice01', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('practice01', { areas_checked: selectedAreas.value.length })
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
</script>

<style scoped>
.exp-app { min-height: 100vh; background: var(--paper); transition: background 0.6s ease; }
.exp-app.dark-mode { background: var(--bg-dark); }
.exp-container { max-width: 640px; margin: 0 auto; padding: 4rem 1.5rem; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.35s ease, transform 0.35s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(12px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-container { padding: 3rem 1rem; } }
</style>
VUEEOF

echo "  ✓ Practice01.vue updated (5 screens)"

# ── Updated TheMapping with proper provide/inject ──
cat > src/components/experiences/practice01/TheMapping.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="5" />
    <p class="caption" style="margin-bottom: 1.5rem;">Map your footprint</p>
    <h2 class="display-medium">Where do you currently support the use of force?</h2>
    <Divider />
    <p class="body-text">No judgment. This is about seeing clearly. For each area, ask: does the government use force (fines, imprisonment, seizure) to fund or enforce this?</p>

    <div class="categories">
      <div v-for="cat in categories" :key="cat.id" class="category">
        <p class="cat-label">{{ cat.label }}</p>
        <div class="items">
          <button
            v-for="item in cat.items"
            :key="item.id"
            class="item-card"
            :class="{ selected: selectedAreas.includes(item.id) }"
            @click="toggle(item.id)"
          >
            <span class="item-check">{{ selectedAreas.includes(item.id) ? '✓' : '' }}</span>
            <div class="item-content">
              <span class="item-label">{{ item.label }}</span>
              <span class="item-mechanism">{{ item.mechanism }}</span>
            </div>
          </button>
        </div>
      </div>
    </div>

    <p class="tally">{{ selectedAreas.length }} of {{ totalItems }} areas selected</p>

    <NavBar :can-go-back="true" :disable-continue="selectedAreas.length === 0" @back="$emit('back')" @continue="handleContinue" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

const emit = defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const selectedAreas = inject('selectedAreas')

onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const categories = [
  {
    id: 'money',
    label: 'Your money',
    items: [
      { id: 'income-tax', label: 'Income tax', mechanism: 'Compulsory payment; non-compliance leads to penalties and imprisonment' },
      { id: 'property-tax', label: 'Property tax', mechanism: 'Pay or your home is seized, even if fully paid for' },
      { id: 'sales-tax', label: 'Sales tax', mechanism: 'Added to every purchase; businesses face closure for non-collection' },
      { id: 'social-security', label: 'Social Security / Medicare', mechanism: 'Mandatory payroll deduction; no individual opt-out' },
    ]
  },
  {
    id: 'services',
    label: 'Services you use',
    items: [
      { id: 'public-schools', label: 'Public schools', mechanism: 'Tax-funded regardless of whether you use them or have children' },
      { id: 'roads', label: 'Roads and infrastructure', mechanism: 'Gas taxes and general revenue; no option to fund only roads you use' },
      { id: 'police', label: 'Police and courts', mechanism: 'Tax-funded; no option to choose alternative dispute resolution' },
      { id: 'military', label: 'Military and defense', mechanism: 'Compulsory funding of all operations including those you oppose' },
    ]
  },
  {
    id: 'rules',
    label: 'Rules you support',
    items: [
      { id: 'min-wage', label: 'Minimum wage laws', mechanism: 'Criminalizes voluntary employment agreements below a threshold' },
      { id: 'drug-laws', label: 'Drug prohibition', mechanism: 'Imprisonment for personal consumption choices' },
      { id: 'licensing', label: 'Occupational licensing', mechanism: 'Government permission required to practice many professions' },
      { id: 'zoning', label: 'Zoning and building codes', mechanism: 'Restrictions on how you use property you own' },
      { id: 'regulations', label: 'Business regulations', mechanism: 'Comply or face fines, forced closure, or imprisonment' },
      { id: 'env-regs', label: 'Environmental regulations', mechanism: 'Mandated compliance backed by fines and penalties' },
    ]
  }
]

const totalItems = computed(() => categories.reduce((sum, cat) => sum + cat.items.length, 0))

function toggle(id) {
  const idx = selectedAreas.value.indexOf(id)
  if (idx === -1) selectedAreas.value.push(id)
  else selectedAreas.value.splice(idx, 1)
}

function handleContinue() {
  trackChoice('practice01', 'footprint-areas', selectedAreas.value.join(','))
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.categories { margin: 2rem 0; }
.cat-label { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin: 1.5rem 0 0.5rem; }
.cat-label:first-child { margin-top: 0; }
.items { display: flex; flex-direction: column; gap: 0.4rem; }
.item-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.item-card:hover { border-color: var(--ochre); }
.item-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.item-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--ochre); margin-top: 2px; transition: all 0.2s; }
.item-card.selected .item-check { background: var(--ochre); border-color: var(--ochre); color: white; }
.item-content { flex: 1; }
.item-label { display: block; font-weight: 500; font-size: 0.88rem; }
.item-mechanism { display: block; font-size: 0.72rem; color: var(--ink-faint); margin-top: 0.1rem; }
.tally { text-align: center; margin-top: 1.5rem; font-size: 0.85rem; color: var(--ink-muted); font-style: italic; }
</style>
VUEEOF

echo "  ✓ Practice01 TheMapping (categorized checklist)"

# ── NEW: YourFootprint — visual output ──
cat > src/components/experiences/practice01/YourFootprint.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="5" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your political footprint</p>
    <h2 class="display-medium">{{ selectedAreas.length }} of {{ totalItems }} areas.</h2>
    <Divider />

    <!-- Visual footprint -->
    <div class="footprint-visual">
      <div class="footprint-grid">
        <div
          v-for="item in allItems"
          :key="item.id"
          class="footprint-cell"
          :class="{ active: selectedAreas.includes(item.id) }"
          :title="item.label"
        />
      </div>
      <p class="footprint-legend">
        <span class="legend-active"></span> Force supported
        <span class="legend-inactive"></span> Not selected
      </p>
    </div>

    <p class="body-text-large">Each filled square represents an area of life where you support using government force against peaceful people who disagree or don't comply.</p>

    <ContentBlock variant="mirror">
      <p>This doesn't make you a bad person. Nearly everyone's footprint looks like this. These policies are so normal that the force behind them has become invisible. That's exactly why this exercise exists — to make the invisible visible.</p>
    </ContentBlock>

    <div class="breakdown">
      <div v-for="cat in categorizedSelections" :key="cat.label" class="breakdown-row">
        <div class="breakdown-label">{{ cat.label }}</div>
        <div class="breakdown-bar">
          <div class="breakdown-fill" :style="{ width: cat.pct + '%' }"></div>
        </div>
        <div class="breakdown-count">{{ cat.selected }}/{{ cat.total }}</div>
      </div>
    </div>

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
const selectedAreas = inject('selectedAreas')

onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const categories = [
  { label: 'Your money', ids: ['income-tax', 'property-tax', 'sales-tax', 'social-security'] },
  { label: 'Services you use', ids: ['public-schools', 'roads', 'police', 'military'] },
  { label: 'Rules you support', ids: ['min-wage', 'drug-laws', 'licensing', 'zoning', 'regulations', 'env-regs'] },
]

const allItems = computed(() => {
  const items = []
  categories.forEach(cat => {
    cat.ids.forEach(id => items.push({ id, label: id.replace(/-/g, ' ') }))
  })
  return items
})

const totalItems = computed(() => allItems.value.length)

const categorizedSelections = computed(() => {
  return categories.map(cat => ({
    label: cat.label,
    total: cat.ids.length,
    selected: cat.ids.filter(id => selectedAreas.value.includes(id)).length,
    pct: Math.round(100 * cat.ids.filter(id => selectedAreas.value.includes(id)).length / cat.ids.length)
  }))
})
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.footprint-visual { margin: 2rem 0; text-align: center; }
.footprint-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 6px;
  max-width: 280px;
  margin: 0 auto;
}
.footprint-cell {
  aspect-ratio: 1;
  border-radius: 4px;
  background: var(--paper-warm);
  border: 1px solid var(--border-subtle);
  transition: all 0.3s ease;
}
.footprint-cell.active {
  background: var(--ochre);
  border-color: var(--ochre);
}

.footprint-legend {
  margin-top: 1rem;
  font-size: 0.72rem;
  color: var(--ink-faint);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}
.legend-active {
  display: inline-block;
  width: 10px;
  height: 10px;
  border-radius: 2px;
  background: var(--ochre);
  margin-right: 0.2rem;
}
.legend-inactive {
  display: inline-block;
  width: 10px;
  height: 10px;
  border-radius: 2px;
  background: var(--paper-warm);
  border: 1px solid var(--border-subtle);
  margin-left: 0.75rem;
  margin-right: 0.2rem;
}

.breakdown { margin: 2rem 0; }
.breakdown-row {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.65rem;
}
.breakdown-label {
  flex-shrink: 0;
  width: 120px;
  font-size: 0.8rem;
  color: var(--ink-muted);
  text-align: right;
}
.breakdown-bar {
  flex: 1;
  height: 8px;
  background: var(--paper-warm);
  border-radius: 4px;
  overflow: hidden;
}
.breakdown-fill {
  height: 100%;
  background: var(--ochre);
  border-radius: 4px;
  transition: width 0.6s ease;
}
.breakdown-count {
  flex-shrink: 0;
  width: 36px;
  font-size: 0.75rem;
  color: var(--ink-faint);
}
</style>
VUEEOF

echo "  ✓ Practice01 YourFootprint (visual output)"

# ── Updated TheChallenge ──
cat > src/components/experiences/practice01/TheChallenge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="5" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question behind the footprint</p>
    <h2 class="display-medium">For each area you selected, ask one question.</h2>
    <Divider />

    <p class="body-text-large">Could this be done without force? Could the same goal be achieved through persuasion, voluntary funding, or cooperative action?</p>

    <p class="body-text">For some areas, the answer might be "I don't see how." That's honest. Not every problem has an obvious voluntary solution. But notice the difference between "it can't be done voluntarily" and "I haven't seen how it could be done voluntarily." Those are very different claims.</p>

    <ContentBlock variant="insight">
      <p>People once said the same thing about mail delivery, roads, education, and disaster relief. All of these now have functioning voluntary alternatives alongside or instead of government versions. The category of "this requires force" has been shrinking for centuries.</p>
    </ContentBlock>

    <ContentBlock variant="principle">
      <p>The philosophy doesn't ask you to oppose everything you checked. It asks you to hold each one up to the light and ask: is force truly necessary here, or have I simply never considered the alternative?</p>
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

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Practice01 TheChallenge updated"

# ── Updated TheReflection (closing with JourneyNav + newsletter) ──
cat > src/components/experiences/practice01/TheReflection.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="5" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your next step</p>
    <h2 class="display-medium">Pick one. Just one.</h2>
    <Divider />

    <p class="body-text-large">Pick one area from your footprint and spend this week exploring voluntary alternatives. Not arguing about it online. Not trying to convince anyone. Just researching: has anyone solved this without force?</p>

    <ContentBlock variant="insight">
      <p>Your political footprint shrinks one conscious choice at a time. Not through revolution, but through the quiet decision to stop supporting force in one more area of life.</p>
    </ContentBlock>

    <NewsletterSignup source="practice01_closing" headline="Keep practicing." description="A weekly email with one real-world situation and the question: force or persuasion? Plus what other people designed as voluntary solutions." button-text="I'm in" success-message="Welcome. The first situation arrives this week." />
    <JourneyNav current="practice01" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Practice01 TheReflection (closing with JourneyNav)"

# ══════════════════════════════════════
# 3. FOUNDATION MILESTONE PAGE
# Shown after completing Exp03
# Celebrates progress, summarizes discoveries, provides clear direction
# ══════════════════════════════════════

cat > src/pages/MilestonePage.vue << 'VUEEOF'
<template>
  <div class="page">
    <div class="page-container stagger" ref="el">

      <div class="milestone-badge">Foundation complete</div>

      <h1 class="display-large" style="margin-top: 1rem; text-align: center;">
        You've built the framework.
      </h1>

      <Divider :centered="true" />

      <p class="body-text-large" style="text-align: center; max-width: 520px; margin: 1.5rem auto 0;">
        Three experiences. Three discoveries. A foundation for seeing every political question differently.
      </p>

      <!-- Summary of discoveries -->
      <div class="discoveries">
        <div class="discovery">
          <div class="discovery-num">01</div>
          <div class="discovery-content">
            <div class="discovery-title">The gap</div>
            <p class="discovery-desc" v-if="journey.mirrorPattern === 'gap'">You hold one moral standard for personal life and a different one for politics. Most people do. Now you've seen it.</p>
            <p class="discovery-desc" v-else-if="journey.mirrorPattern === 'consistent-voluntary'">You apply the same moral standard to personal and political life. You're already living by the principle most people haven't noticed.</p>
            <p class="discovery-desc" v-else>You examined your own moral reasoning and found a pattern worth understanding.</p>
          </div>
        </div>

        <div class="discovery">
          <div class="discovery-num">02</div>
          <div class="discovery-content">
            <div class="discovery-title">The objection</div>
            <p class="discovery-desc" v-if="journey.exp02.chosenObjection">You chose "{{ objectionTitle }}" — and saw it steelmanned, responded to, and honestly conceded.</p>
            <p class="discovery-desc" v-else>You tested the philosophy against your strongest objection.</p>
          </div>
        </div>

        <div class="discovery">
          <div class="discovery-num">03</div>
          <div class="discovery-content">
            <div class="discovery-title">The grounding</div>
            <p class="discovery-desc">You traced the principle through your own life and found that flourishing tracks with the three domains: body, resources, and time.</p>
          </div>
        </div>
      </div>

      <!-- What the philosophy asks -->
      <div style="margin-top: 3rem;">
        <h2 class="display-medium" style="text-align: center;">What the philosophy asks of you.</h2>
        <Divider :centered="true" />

        <ContentBlock variant="principle">
          <p>Not agreement. Not conversion. Not a political identity. Just a question you carry with you: in this situation, am I reaching for force or persuasion? And could the outcome be better if I chose differently?</p>
        </ContentBlock>

        <p class="body-text">That's it. One question, applied consistently, across every area of your life. The philosophy claims that people who carry this question discover, over time, that voluntary cooperation produces more flourishing than coercion. Not always faster. Not always easier. But more.</p>
      </div>

      <!-- What's next -->
      <div style="margin-top: 3rem;">
        <h2 class="display-medium" style="text-align: center;">Where to go from here.</h2>
        <Divider :centered="true" />

        <p class="body-text">The foundation is complete, but the philosophy goes deeper. Five pillars explore specific dimensions — your body, your time, your resources, the method question, and the evidence for cooperation. Five practices help you apply the ideas to your actual life.</p>
      </div>

      <JourneyNav current="milestone" next-label="Continue your journey" />

      <NewsletterSignup
        source="milestone"
        headline="The questions don't stop here."
        description="One short email per week applying the Philosophy of Human Respect to a real situation. No selling. No spam. Just the question, applied."
        success-message="You're in. The first question arrives this week."
      />

    </div>

    <footer class="page-footer">
      <div class="footer-inner">
        <div class="footer-left">Human Respect</div>
        <div class="footer-right">
          <router-link to="/about" class="footer-link">About</router-link>
          <router-link to="/privacy" class="footer-link">Privacy</router-link>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from '@/components/experiences/exp02/objectionData.js'

const journey = useJourneyStore()
const el = ref(null)

onMounted(() => {
  document.body.classList.remove('dark-mode')
  requestAnimationFrame(() => el.value?.classList.add('animate'))
})

const objectionTitle = computed(() => {
  const key = journey.exp02.chosenObjection
  return key && objections[key] ? objections[key].title : ''
})
</script>

<style scoped>
.page { background: var(--paper); min-height: 100vh; }

.page-container {
  max-width: 640px;
  margin: 0 auto;
  padding: 5rem 1.5rem 4rem;
}

.milestone-badge {
  text-align: center;
  font-size: 0.68rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--insight-green);
  background: var(--insight-bg);
  display: inline-block;
  padding: 0.35rem 1rem;
  border-radius: 100px;
  font-weight: 600;
  margin: 0 auto;
  display: block;
  width: fit-content;
}

.discoveries {
  margin: 3rem 0;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.discovery {
  display: flex;
  gap: 1.25rem;
  align-items: flex-start;
}

.discovery-num {
  flex-shrink: 0;
  font-family: var(--serif);
  font-size: 0.85rem;
  font-weight: 400;
  color: var(--ochre);
  margin-top: 0.15rem;
}

.discovery-title {
  font-family: var(--serif);
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.25rem;
}

.discovery-desc {
  font-size: 0.88rem;
  color: var(--ink-muted);
  line-height: 1.65;
  margin: 0;
}

/* Footer */
.page-footer { padding: 3rem 1.5rem; background: var(--ink); display: flex; justify-content: center; }
.footer-inner { max-width: 640px; width: 100%; display: flex; justify-content: space-between; align-items: center; }
.footer-left { font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: rgba(244, 240, 234, 0.3); }
.footer-right { display: flex; gap: 2rem; }
.footer-link { font-family: var(--sans); font-size: 0.72rem; letter-spacing: 0.08em; text-transform: uppercase; color: rgba(244, 240, 234, 0.25); text-decoration: none; transition: color 0.3s ease; }
.footer-link:hover { color: rgba(244, 240, 234, 0.6); }

@media (max-width: 480px) {
  .page-container { padding: 3.5rem 1.25rem 3rem; }
  .footer-inner { flex-direction: column; gap: 1.5rem; text-align: center; }
}
</style>
VUEEOF

echo "  ✓ MilestonePage.vue"

# ── Add route ──
# We need to add the milestone route to the router
# The copy-edit.sh already rewrote the router, so let's use sed
if grep -q "milestone" src/router/index.js 2>/dev/null; then
  echo "  ✓ Milestone route already exists"
else
  sed -i.bak "/path: '\/about'/i\\  { path: '/milestone', name: 'milestone', component: () => import('@/pages/MilestonePage.vue') }," src/router/index.js
  rm -f src/router/index.js.bak
  echo "  ✓ Milestone route added"
fi

# ── Add milestone to route meta ──
if grep -q "milestone:" src/router/meta.js 2>/dev/null; then
  echo "  ✓ Milestone meta already exists"
else
  sed -i.bak "/privacy:/i\\  milestone: {\n    title: 'Foundation Complete — Human Respect',\n    description: 'You\\'ve completed the foundation of the Philosophy of Human Respect. Three discoveries that change how you see every political question.'\n  }," src/router/meta.js
  rm -f src/router/meta.js.bak
  echo "  ✓ Milestone meta added"
fi

# ── Update Exp03 TheBridge to link to milestone ──
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
        <div><div class="foundation-title">The gap</div><p class="foundation-desc">Most people hold one moral standard for personal life and a different one for politics.</p></div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">02</span>
        <div><div class="foundation-title">The objection</div><p class="foundation-desc">The strongest counterarguments, taken seriously and honestly conceded where necessary.</p></div>
      </div>
      <div class="foundation-item">
        <span class="foundation-number">03</span>
        <div><div class="foundation-title">The grounding</div><p class="foundation-desc">Flourishing is real, measurable, and sensitive to three domains — body, resources, and time.</p></div>
      </div>
    </div>

    <PathCard :to="{ name: 'milestone' }" :recommended="true">
      <template #title>See your foundation summary</template>
      <template #desc>A personalized summary of what you discovered, and where the philosophy goes from here.</template>
    </PathCard>

    <p class="body-text" style="margin-top: 1.5rem;">Or continue exploring directly:</p>

    <JourneyNav current="exp03" next-label="Go deeper" />

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import PathCard from '@/components/shared/PathCard.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.foundation-summary { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }
.foundation-item { display: flex; gap: 1rem; align-items: flex-start; }
.foundation-number { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.foundation-title { font-family: var(--serif); font-size: 1.05rem; font-weight: 500; color: var(--ink); margin-bottom: 0.2rem; }
.foundation-desc { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }
</style>
VUEEOF

echo "  ✓ Exp03 TheBridge links to milestone"

echo ""
echo "✅ All three engagement improvements built!"
echo ""
echo "What changed:"
echo ""
echo "  1. EXP02: New 'YourVerdict' screen (screen 7 of 8)"
echo "     - Three options: addressed / partially / not addressed"
echo "     - Each triggers a different response"
echo "     - Analytics tracks the verdict for each objection"
echo "     - All other screens updated to :total='8'"
echo ""
echo "  2. PRACTICE01: Interactive Political Footprint (5 screens)"
echo "     - Categorized checklist (money, services, rules) with 14 items"
echo "     - Visual footprint grid showing selected areas"
echo "     - Category breakdown with progress bars"
echo "     - Analytics tracks which areas people select"
echo ""
echo "  3. MILESTONE PAGE (/milestone)"
echo "     - Personalized summary of foundation discoveries"
echo "     - Shows mirror pattern and chosen objection"
echo "     - Clear statement of what the philosophy asks"
echo "     - Newsletter signup + JourneyNav to pillars/practices"
echo "     - Linked from Exp03 closing screen"
echo ""
echo "Push with: git add . && git commit -m 'engagement: verdict, footprint, milestone' && git push"
