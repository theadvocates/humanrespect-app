#!/bin/bash
# Practice01: Two-pass political footprint
# Pass 1: Where does force operate in your life? (factual)
# Pass 2: Which of these do you actually support? (normative)
# The gap between them is the insight.
# Run from humanrespect-app/ root

set -e

echo "📊 Rebuilding Practice01 with two-pass footprint..."

# ══════════════════════════════════════
# UPDATE PAGE — 6 screens now
# ══════════════════════════════════════

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
import WhereItOperates from '@/components/experiences/practice01/WhereItOperates.vue'
import WhereYouSupportIt from '@/components/experiences/practice01/WhereYouSupportIt.vue'
import YourFootprint from '@/components/experiences/practice01/YourFootprint.vue'
import TheChallenge from '@/components/experiences/practice01/TheChallenge.vue'
import TheReflection from '@/components/experiences/practice01/TheReflection.vue'

const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])
const operates = ref([])
const supports = ref([])

provide('operates', operates)
provide('supports', supports)

const screenComponents = [Opening, WhereItOperates, WhereYouSupportIt, YourFootprint, TheChallenge, TheReflection]
const screenNames = ['opening', 'where-it-operates', 'where-you-support', 'footprint', 'challenge', 'reflection']

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

watch(currentScreen, (idx) => {
  trackScreenView('practice01', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) {
    trackCompletion('practice01', {
      operates_count: operates.value.length,
      supports_count: supports.value.length,
      gap: operates.value.length - supports.value.length
    })
  }
})

function advance() {
  if (currentScreen.value === 1) {
    trackChoice('practice01', 'operates', operates.value.join(','))
  }
  if (currentScreen.value === 2) {
    trackChoice('practice01', 'supports', supports.value.join(','))
  }
  if (currentScreen.value < TOTAL_SCREENS - 1) {
    currentScreen.value++
    history.value.push(currentScreen.value)
    window.scrollTo(0, 0)
  }
}

function goBack() {
  if (history.value.length > 1) {
    history.value.pop()
    currentScreen.value = history.value[history.value.length - 1]
    window.scrollTo(0, 0)
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
@media (max-width: 480px) { .exp-container { padding: 2.5rem 1rem; } }
</style>
VUEEOF

echo "  ✓ Practice01.vue (6 screens)"

# ══════════════════════════════════════
# SHARED ITEMS DATA
# ══════════════════════════════════════

cat > src/components/experiences/practice01/footprintData.js << 'JSEOF'
export const categories = [
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
    label: 'Services',
    items: [
      { id: 'public-schools', label: 'Public schools', mechanism: 'Tax-funded regardless of whether you use them or have children' },
      { id: 'roads', label: 'Roads and infrastructure', mechanism: 'Gas taxes and general revenue; no option to fund only roads you use' },
      { id: 'police', label: 'Police and courts', mechanism: 'Tax-funded; no option to choose alternative dispute resolution' },
      { id: 'military', label: 'Military and defense', mechanism: 'Compulsory funding of all operations including those you oppose' },
    ]
  },
  {
    id: 'rules',
    label: 'Rules and regulations',
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

export const allItemIds = categories.flatMap(cat => cat.items.map(i => i.id))
export const totalItems = allItemIds.length
JSEOF

echo "  ✓ footprintData.js"

# ══════════════════════════════════════
# PASS 1: Where does force operate?
# ══════════════════════════════════════

cat > src/components/experiences/practice01/WhereItOperates.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Pass 1 of 2</p>
    <h2 class="display-medium">Where does government force currently operate in your life?</h2>
    <Divider />
    <p class="body-text">This isn't about whether you agree with these policies. Just identify where force — the threat of fines, seizure, or imprisonment — is the enforcement mechanism.</p>

    <div class="categories">
      <div v-for="cat in categories" :key="cat.id" class="category">
        <p class="cat-label">{{ cat.label }}</p>
        <div class="items">
          <button
            v-for="item in cat.items"
            :key="item.id"
            class="item-card"
            :class="{ selected: operates.includes(item.id) }"
            @click="toggle(item.id)"
          >
            <span class="item-check">{{ operates.includes(item.id) ? '✓' : '' }}</span>
            <div class="item-content">
              <span class="item-label">{{ item.label }}</span>
              <span class="item-mechanism">{{ item.mechanism }}</span>
            </div>
          </button>
        </div>
      </div>
    </div>

    <p class="tally">{{ operates.length }} of {{ totalItems }} areas identified</p>

    <NavBar :can-go-back="true" :disable-continue="operates.length === 0" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { categories, totalItems } from './footprintData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
const operates = inject('operates')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function toggle(id) {
  const idx = operates.value.indexOf(id)
  if (idx === -1) operates.value.push(id)
  else operates.value.splice(idx, 1)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.categories { margin: 2rem 0; }
.cat-label { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin: 1.5rem 0 0.5rem; }
.category:first-child .cat-label { margin-top: 0; }
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

echo "  ✓ WhereItOperates (Pass 1)"

# ══════════════════════════════════════
# PASS 2: Which do you support?
# Only shows items checked in Pass 1
# ══════════════════════════════════════

cat > src/components/experiences/practice01/WhereYouSupportIt.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Pass 2 of 2</p>
    <h2 class="display-medium">Now: which of these do you actually support?</h2>
    <Divider />
    <p class="body-text">You identified {{ operates.length }} areas where government force operates in your life. Now look at each one and ask: do I believe this <em>should</em> be enforced through force? Check only the ones you genuinely endorse.</p>

    <div class="items">
      <button
        v-for="item in operatingItems"
        :key="item.id"
        class="item-card"
        :class="{ selected: supports.includes(item.id) }"
        @click="toggle(item.id)"
      >
        <span class="item-check">{{ supports.includes(item.id) ? '✓' : '' }}</span>
        <div class="item-content">
          <span class="item-label">{{ item.label }}</span>
        </div>
      </button>
    </div>

    <p class="tally">{{ supports.length }} of {{ operates.length }} areas supported</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { categories } from './footprintData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
const operates = inject('operates')
const supports = inject('supports')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const allItems = categories.flatMap(cat => cat.items)
const operatingItems = computed(() => allItems.filter(i => operates.value.includes(i.id)))

function toggle(id) {
  const idx = supports.value.indexOf(id)
  if (idx === -1) supports.value.push(id)
  else supports.value.splice(idx, 1)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.items { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.item-card { display: flex; align-items: center; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.item-card:hover { border-color: var(--insight-green); }
.item-card.selected { border-color: var(--insight-green); background: var(--insight-bg); }
.item-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--insight-green); margin-top: 0px; transition: all 0.2s; }
.item-card.selected .item-check { background: var(--insight-green); border-color: var(--insight-green); color: white; }
.item-content { flex: 1; }
.item-label { display: block; font-weight: 500; font-size: 0.88rem; }
.tally { text-align: center; margin-top: 1.5rem; font-size: 0.85rem; color: var(--ink-muted); font-style: italic; }
</style>
VUEEOF

echo "  ✓ WhereYouSupportIt (Pass 2)"

# ══════════════════════════════════════
# VISUAL OUTPUT: Three-state footprint
# ══════════════════════════════════════

cat > src/components/experiences/practice01/YourFootprint.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your political footprint</p>
    <h2 class="display-medium">The gap between force and support.</h2>
    <Divider />

    <!-- Stats row -->
    <div class="stats-row">
      <div class="stat">
        <div class="stat-number">{{ operates.length }}</div>
        <div class="stat-label">areas where force operates</div>
      </div>
      <div class="stat">
        <div class="stat-number stat-green">{{ supports.length }}</div>
        <div class="stat-label">areas you support</div>
      </div>
      <div class="stat">
        <div class="stat-number stat-ochre">{{ gap }}</div>
        <div class="stat-label">areas of involuntary force</div>
      </div>
    </div>

    <!-- Visual grid -->
    <div class="footprint-visual">
      <div class="footprint-grid">
        <div
          v-for="item in allItems"
          :key="item.id"
          class="footprint-cell"
          :class="cellClass(item.id)"
          :title="item.label + ': ' + cellLabel(item.id)"
        />
      </div>
      <div class="footprint-legend">
        <span class="legend-item"><span class="legend-dot supported"></span> Force you support</span>
        <span class="legend-item"><span class="legend-dot involuntary"></span> Force imposed on you</span>
        <span class="legend-item"><span class="legend-dot none"></span> No force identified</span>
      </div>
    </div>

    <ContentBlock v-if="gap > 0" variant="mirror">
      <p>{{ gap }} areas of your life involve government force that you don't actually endorse. That's not a political position — it's a measurement. These are places where someone else's priorities are being imposed on you through the threat of punishment.</p>
    </ContentBlock>

    <ContentBlock v-if="gap === 0 && supports.length > 0" variant="mirror">
      <p>You support every area of force you identified. That's a consistent position. The question the philosophy raises: for each one, could the same goal be achieved through voluntary cooperation instead?</p>
    </ContentBlock>

    <ContentBlock v-if="supports.length === 0 && operates.length > 0" variant="mirror">
      <p>You identified {{ operates.length }} areas where force operates but don't endorse any of them. Your entire political footprint is involuntary. You already see the scope of the problem the philosophy describes.</p>
    </ContentBlock>

    <!-- Per-category breakdown -->
    <div class="breakdown">
      <div v-for="cat in categoryBreakdown" :key="cat.label" class="breakdown-row">
        <div class="breakdown-label">{{ cat.label }}</div>
        <div class="breakdown-bars">
          <div class="bar-track">
            <div class="bar-fill operates" :style="{ width: cat.operatesPct + '%' }"></div>
            <div class="bar-fill supported" :style="{ width: cat.supportsPct + '%' }"></div>
          </div>
        </div>
        <div class="breakdown-count">{{ cat.supportsCount }}/{{ cat.operatesCount }}</div>
      </div>
      <div class="breakdown-legend">
        <span class="legend-item"><span class="legend-dot involuntary" style="width:8px;height:8px;"></span> operates</span>
        <span class="legend-item"><span class="legend-dot supported" style="width:8px;height:8px;"></span> supported</span>
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
import { categories, allItemIds } from './footprintData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
const operates = inject('operates')
const supports = inject('supports')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const allItems = categories.flatMap(cat => cat.items)
const gap = computed(() => operates.value.length - supports.value.length)

function cellClass(id) {
  if (supports.value.includes(id)) return 'supported'
  if (operates.value.includes(id)) return 'involuntary'
  return 'none'
}

function cellLabel(id) {
  if (supports.value.includes(id)) return 'force you support'
  if (operates.value.includes(id)) return 'force imposed on you'
  return 'no force identified'
}

const categoryBreakdown = computed(() => {
  return categories.map(cat => {
    const ids = cat.items.map(i => i.id)
    const operatesCount = ids.filter(id => operates.value.includes(id)).length
    const supportsCount = ids.filter(id => supports.value.includes(id)).length
    const total = ids.length
    return {
      label: cat.label,
      operatesCount,
      supportsCount,
      operatesPct: Math.round(100 * operatesCount / total),
      supportsPct: Math.round(100 * supportsCount / total)
    }
  })
})
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.stats-row { display: flex; gap: 1rem; margin: 2rem 0; text-align: center; }
.stat { flex: 1; padding: 1rem 0.5rem; background: var(--cream); border-radius: var(--radius); border: 1px solid var(--border-subtle); }
.stat-number { font-family: var(--serif); font-size: 2rem; font-weight: 500; color: var(--ink); }
.stat-green { color: var(--insight-green); }
.stat-ochre { color: var(--ochre); }
.stat-label { font-size: 0.68rem; color: var(--ink-muted); margin-top: 0.25rem; line-height: 1.3; }

.footprint-visual { margin: 2rem 0; text-align: center; }
.footprint-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 6px; max-width: 280px; margin: 0 auto; }
.footprint-cell { aspect-ratio: 1; border-radius: 4px; border: 1px solid var(--border-subtle); transition: all 0.3s ease; }
.footprint-cell.supported { background: var(--insight-green); border-color: var(--insight-green); }
.footprint-cell.involuntary { background: var(--ochre); border-color: var(--ochre); }
.footprint-cell.none { background: var(--paper-warm); }

.footprint-legend { margin-top: 1rem; display: flex; flex-wrap: wrap; justify-content: center; gap: 1rem; font-size: 0.72rem; color: var(--ink-faint); }
.legend-item { display: flex; align-items: center; gap: 0.3rem; }
.legend-dot { display: inline-block; width: 10px; height: 10px; border-radius: 2px; }
.legend-dot.supported { background: var(--insight-green); }
.legend-dot.involuntary { background: var(--ochre); }
.legend-dot.none { background: var(--paper-warm); border: 1px solid var(--border-subtle); }

.breakdown { margin: 2rem 0; }
.breakdown-row { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.65rem; }
.breakdown-label { flex-shrink: 0; width: 110px; font-size: 0.78rem; color: var(--ink-muted); text-align: right; }
.breakdown-bars { flex: 1; }
.bar-track { height: 10px; background: var(--paper-warm); border-radius: 5px; overflow: hidden; position: relative; }
.bar-fill { height: 100%; position: absolute; top: 0; left: 0; border-radius: 5px; transition: width 0.6s ease; }
.bar-fill.operates { background: var(--ochre); opacity: 0.4; }
.bar-fill.supported { background: var(--insight-green); z-index: 1; }
.breakdown-count { flex-shrink: 0; width: 36px; font-size: 0.72rem; color: var(--ink-faint); }
.breakdown-legend { display: flex; justify-content: flex-end; gap: 1rem; font-size: 0.68rem; color: var(--ink-faint); margin-top: 0.5rem; padding-right: 36px; }

@media (max-width: 480px) {
  .stats-row { gap: 0.5rem; }
  .stat { padding: 0.75rem 0.3rem; }
  .stat-number { font-size: 1.5rem; }
  .stat-label { font-size: 0.62rem; }
  .breakdown-label { width: 80px; font-size: 0.72rem; }
}
</style>
VUEEOF

echo "  ✓ YourFootprint (three-state visual)"

# ══════════════════════════════════════
# TheChallenge — updated for two-pass context
# ══════════════════════════════════════

cat > src/components/experiences/practice01/TheChallenge.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question behind the footprint</p>
    <h2 class="display-medium">For each area — whether you support it or not — ask one question.</h2>
    <Divider />

    <p class="body-text-large">Could this be done without force? Could the same goal be achieved through persuasion, voluntary funding, or cooperative action?</p>

    <p class="body-text">For some areas, the answer might be "I don't see how." That's honest. Not every problem has an obvious voluntary solution. But notice the difference between "it can't be done voluntarily" and "I haven't seen how it could be done voluntarily." Those are very different claims.</p>

    <ContentBlock variant="insight">
      <p>People once said the same thing about mail delivery, roads, education, and disaster relief. All of these now have functioning voluntary alternatives alongside or instead of government versions. The category of "this requires force" has been shrinking for centuries.</p>
    </ContentBlock>

    <ContentBlock variant="principle">
      <p>The philosophy doesn't ask you to oppose everything on your list. It asks you to hold each one up to the light and ask: is force truly necessary here, or have I simply never considered the alternative?</p>
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

echo "  ✓ TheChallenge updated"

# ══════════════════════════════════════
# TheReflection — closing with JourneyNav
# ══════════════════════════════════════

cat > src/components/experiences/practice01/TheReflection.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your next step</p>
    <h2 class="display-medium">Pick one. Just one.</h2>
    <Divider />

    <p class="body-text-large">Pick one area from your footprint — ideally one you marked as involuntary — and spend this week exploring voluntary alternatives. Not arguing about it online. Not trying to convince anyone. Just researching: has anyone solved this without force?</p>

    <ContentBlock variant="insight">
      <p>Your political footprint shifts one conscious choice at a time. Not through revolution, but through the quiet decision to question force in one more area of life.</p>
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

echo "  ✓ TheReflection (closing)"

# Clean up old files that are no longer imported
rm -f src/components/experiences/practice01/TheMapping.vue
rm -f src/components/experiences/practice01/TheTotal.vue

echo "  ✓ Cleaned up old files"

echo ""
echo "✅ Practice01 rebuilt with two-pass footprint!"
echo ""
echo "Flow:"
echo "  1. Opening (dark)"
echo "  2. Pass 1: Where does force operate? (factual, check all that apply)"
echo "  3. Pass 2: Which do you support? (normative, only shows Pass 1 items)"
echo "  4. Your Footprint (three-state visual: supported / involuntary / none)"
echo "  5. The Challenge (question about voluntary alternatives)"
echo "  6. The Reflection (closing + newsletter + JourneyNav)"
echo ""
echo "Analytics captures:"
echo "  - operates: which areas force operates (from pass 1)"
echo "  - supports: which areas visitor endorses (from pass 2)"
echo "  - gap: difference between operates and supports"
echo ""
echo "Push with: git add . && git commit -m 'practice01: two-pass footprint' && git push"
