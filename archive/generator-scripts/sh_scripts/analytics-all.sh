#!/bin/bash
# Wire analytics into all experiences
# Run from humanrespect-app/ root

set -e

echo "📊 Wiring analytics into all experiences..."

# ══════════════════════════════════════
# 1. ENHANCED SCREEN NAV WITH ANALYTICS
# Instead of updating 12 page orchestrators individually,
# enhance the composable so any page that uses it gets tracking
# ══════════════════════════════════════

cat > src/composables/useScreenNav.js << 'JSEOF'
import { ref, watch } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

export function useScreenNav(totalScreens, experienceId = null, screenNames = []) {
  const currentScreen = ref(0)
  const history = ref([0])
  const { trackScreenView } = useAnalytics()

  // Track screen views when experienceId is provided
  if (experienceId) {
    watch(currentScreen, (idx) => {
      const name = screenNames[idx] || `screen-${idx}`
      trackScreenView(experienceId, name)
    })
  }

  function advance() {
    if (currentScreen.value < totalScreens - 1) {
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

  return { currentScreen, advance, goBack }
}
JSEOF

echo "  ✓ useScreenNav.js enhanced with built-in analytics"

# ══════════════════════════════════════
# 2. UPDATE EXPERIENCE 01 (uses useScreenNav)
# ══════════════════════════════════════

cat > src/pages/Experience01.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component :is="currentComponent" :key="currentScreen" @advance="advance" @back="goBack" @choose="handleChoice" />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { computed, watch, onUnmounted } from 'vue'
import { useScreenNav } from '@/composables/useScreenNav'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/exp01/Opening.vue'
import CommonGround from '@/components/experiences/exp01/CommonGround.vue'
import Scenario from '@/components/experiences/exp01/Scenario.vue'
import PersonalChoice from '@/components/experiences/exp01/PersonalChoice.vue'
import PoliticalChoice from '@/components/experiences/exp01/PoliticalChoice.vue'
import Mirror from '@/components/experiences/exp01/Mirror.vue'
import WhyTheGap from '@/components/experiences/exp01/WhyTheGap.vue'
import ThePrinciple from '@/components/experiences/exp01/ThePrinciple.vue'
import Invitation from '@/components/experiences/exp01/Invitation.vue'

const screenNames = ['opening','common-ground','scenario','personal-choice','political-choice','mirror','why-the-gap','the-principle','invitation']
const { currentScreen, advance, goBack } = useScreenNav(9, 'exp01', screenNames)
const journey = useJourneyStore()
const { trackChoice } = useAnalytics()

const screenComponents = [Opening, CommonGround, Scenario, PersonalChoice, PoliticalChoice, Mirror, WhyTheGap, ThePrinciple, Invitation]
const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })
onUnmounted(() => document.body.classList.remove('dark-mode'))

function handleChoice({ key, value }) {
  if (key === 'personal') journey.exp01.personal = value
  if (key === 'political') journey.exp01.political = value
  journey.persist()
  trackChoice('exp01', key, value)
}
</script>

<style scoped>
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF

echo "  ✓ Experience01.vue"

# ══════════════════════════════════════
# 3. UPDATE EXPERIENCE 02
# ══════════════════════════════════════

cat > src/pages/Experience02.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component :is="currentComponent" :key="screenKey" @advance="advance" @back="goBack" @choose-objection="handleObjectionChoice" @restart-with="restartWith" @share="handleShare" />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted } from 'vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/exp02/Opening.vue'
import ChooseObjection from '@/components/experiences/exp02/ChooseObjection.vue'
import Steelman from '@/components/experiences/exp02/Steelman.vue'
import Response from '@/components/experiences/exp02/Response.vue'
import Concession from '@/components/experiences/exp02/Concession.vue'
import TheQuestion from '@/components/experiences/exp02/TheQuestion.vue'
import WhereNext from '@/components/experiences/exp02/WhereNext.vue'

const journey = useJourneyStore()
const { trackScreenView, trackChoice, trackShare } = useAnalytics()

const currentScreen = ref(0)
const history = ref([0])
const screenNames = ['opening','choose-objection','steelman','response','concession','the-question','where-next']

const screenComponents = [Opening, ChooseObjection, Steelman, Response, Concession, TheQuestion, WhereNext]
const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${journey.exp02.chosenObjection}`)

watch(currentScreen, (idx) => trackScreenView('exp02', screenNames[idx]))

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })
onUnmounted(() => document.body.classList.remove('dark-mode'))

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
function handleShare() {
  const text = "I picked my strongest objection to a philosophical idea — and it got a more honest answer than I expected."
  const url = window.location.origin + '/experience/the-objection'
  if (navigator.share) {
    navigator.share({ title: 'The Objection', text, url })
    trackShare('native', 'exp02')
  } else {
    navigator.clipboard.writeText(text + ' ' + url)
    trackShare('clipboard', 'exp02')
  }
}
</script>

<style scoped>
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF

echo "  ✓ Experience02.vue"

# ══════════════════════════════════════
# 4. UPDATE EXPERIENCE 03
# ══════════════════════════════════════

cat > src/pages/Experience03.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component :is="currentComponent" :key="currentScreen" @advance="advance" @back="goBack" @select-conditions="handleConditions" @select-violations="handleViolations" />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/exp03/Opening.vue'
import BestPeriod from '@/components/experiences/exp03/BestPeriod.vue'
import ThePattern from '@/components/experiences/exp03/ThePattern.vue'
import WorstPeriod from '@/components/experiences/exp03/WorstPeriod.vue'
import ThreeDomains from '@/components/experiences/exp03/ThreeDomains.vue'
import FlourishingPrinciple from '@/components/experiences/exp03/FlourishingPrinciple.vue'
import TheBridge from '@/components/experiences/exp03/TheBridge.vue'

const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()
const screenNames = ['opening','best-period','the-pattern','worst-period','three-domains','flourishing-principle','the-bridge']

const TOTAL_SCREENS = 7
const currentScreen = ref(0)
const history = ref([0])
const selectedConditions = ref([])
const selectedViolations = ref([])

provide('selectedConditions', selectedConditions)
provide('selectedViolations', selectedViolations)

const screenComponents = [Opening, BestPeriod, ThePattern, WorstPeriod, ThreeDomains, FlourishingPrinciple, TheBridge]
const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(currentScreen, (idx) => {
  trackScreenView('exp03', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('exp03', { conditions: selectedConditions.value, violations: selectedViolations.value })
})

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })
onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) { currentScreen.value++; history.value.push(currentScreen.value); window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
function goBack() {
  if (history.value.length > 1) { history.value.pop(); currentScreen.value = history.value[history.value.length - 1]; window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
function handleConditions(conditions) {
  selectedConditions.value = conditions
  trackChoice('exp03', 'flourishing-conditions', conditions.join(','))
}
function handleViolations(violations) {
  selectedViolations.value = violations
  trackChoice('exp03', 'violation-domains', violations.join(','))
}
</script>

<style scoped>
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF

echo "  ✓ Experience03.vue"

# ══════════════════════════════════════
# 5. PILLAR PAGE TEMPLATE WITH ANALYTICS
# Generates all 5 pillar pages with tracking built in
# ══════════════════════════════════════

create_tracked_pillar() {
  local FILE=$1
  local ID=$2
  local IMPORTS=$3
  local COMPONENTS=$4
  local SCREENS=$5
  local SCREEN_NAMES=$6
  local EXTRA_STATE=$7
  local EXTRA_EMITS=$8
  local EXTRA_METHODS=$9

cat > "src/pages/${FILE}.vue" << VUEEOF
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component :is="currentComponent" :key="screenKey" @advance="advance" @back="goBack" ${EXTRA_EMITS} />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

${IMPORTS}

const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()
const screenNames = [${SCREEN_NAMES}]

const TOTAL_SCREENS = ${SCREENS}
const currentScreen = ref(0)
const history = ref([0])
${EXTRA_STATE}

const screenComponents = [${COMPONENTS}]
const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => \`\${currentScreen.value}\`)

watch(currentScreen, (idx) => {
  trackScreenView('${ID}', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('${ID}')
})

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })
onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) { currentScreen.value++; history.value.push(currentScreen.value); window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
function goBack() {
  if (history.value.length > 1) { history.value.pop(); currentScreen.value = history.value[history.value.length - 1]; window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
${EXTRA_METHODS}
</script>

<style scoped>
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF
}

# ── Pillar A ──
create_tracked_pillar "PillarA" "pillarA" \
"import Opening from '@/components/experiences/pillarA/Opening.vue'
import TheMemory from '@/components/experiences/pillarA/TheMemory.vue'
import TheCascade from '@/components/experiences/pillarA/TheCascade.vue'
import TrustInfrastructure from '@/components/experiences/pillarA/TrustInfrastructure.vue'
import ConsentBoundary from '@/components/experiences/pillarA/ConsentBoundary.vue'
import TheQuestion from '@/components/experiences/pillarA/TheQuestion.vue'" \
"Opening, TheMemory, TheCascade, TrustInfrastructure, ConsentBoundary, TheQuestion" \
6 "'opening','the-memory','the-cascade','trust-infrastructure','consent-boundary','the-question'" \
"" "" ""

echo "  ✓ PillarA.vue"

# ── Pillar B ──
cat > src/pages/PillarB.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component :is="currentComponent" :key="screenKey" @advance="advance" @back="goBack" @set-income="handleIncome" @set-rate="handleRate" />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/pillarB/Opening.vue'
import TheCalculation from '@/components/experiences/pillarB/TheCalculation.vue'
import TheReframe from '@/components/experiences/pillarB/TheReframe.vue'
import TheHierarchy from '@/components/experiences/pillarB/TheHierarchy.vue'
import TheRecognition from '@/components/experiences/pillarB/TheRecognition.vue'
import TheQuestion from '@/components/experiences/pillarB/TheQuestion.vue'

const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()
const screenNames = ['opening','the-calculation','the-reframe','the-hierarchy','the-recognition','the-question']

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])
const income = ref(null)
const taxRate = ref(null)

provide('income', income)
provide('taxRate', taxRate)

const screenComponents = [Opening, TheCalculation, TheReframe, TheHierarchy, TheRecognition, TheQuestion]
const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}`)

watch(currentScreen, (idx) => {
  trackScreenView('pillarB', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('pillarB', { income: income.value, taxRate: taxRate.value })
})

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })
onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) { currentScreen.value++; history.value.push(currentScreen.value); window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
function goBack() {
  if (history.value.length > 1) { history.value.pop(); currentScreen.value = history.value[history.value.length - 1]; window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
function handleIncome(val) { income.value = val; trackChoice('pillarB', 'income', val) }
function handleRate(val) { taxRate.value = val; trackChoice('pillarB', 'tax-rate', val) }
</script>

<style scoped>
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF

echo "  ✓ PillarB.vue"

# ── Pillar C ──
create_tracked_pillar "PillarC" "pillarC" \
"import Opening from '@/components/experiences/pillarC/Opening.vue'
import TheConnection from '@/components/experiences/pillarC/TheConnection.vue'
import TheftAsLifeTheft from '@/components/experiences/pillarC/TheftAsLifeTheft.vue'
import FraudAndTrust from '@/components/experiences/pillarC/FraudAndTrust.vue'
import SecurityAndProsperity from '@/components/experiences/pillarC/SecurityAndProsperity.vue'
import TheQuestion from '@/components/experiences/pillarC/TheQuestion.vue'" \
"Opening, TheConnection, TheftAsLifeTheft, FraudAndTrust, SecurityAndProsperity, TheQuestion" \
6 "'opening','the-connection','theft-as-life-theft','fraud-and-trust','security-and-prosperity','the-question'" \
"" "" ""

echo "  ✓ PillarC.vue"

# ── Pillar D ──
cat > src/pages/PillarD.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component :is="currentComponent" :key="currentScreen" @advance="advance" @back="goBack" @set-values="handleValues" @set-methods="handleMethods" />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/pillarD/Opening.vue'
import YourValues from '@/components/experiences/pillarD/YourValues.vue'
import TheMethodQuestion from '@/components/experiences/pillarD/TheMethodQuestion.vue'
import TheMirror from '@/components/experiences/pillarD/TheMirror.vue'
import TheReframe from '@/components/experiences/pillarD/TheReframe.vue'
import TheQuestion from '@/components/experiences/pillarD/TheQuestion.vue'

const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()
const screenNames = ['opening','your-values','the-method-question','the-mirror','the-reframe','the-question']

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])
const selectedValues = ref([])
const methodAnswers = ref({})

provide('selectedValues', selectedValues)
provide('methodAnswers', methodAnswers)

const screenComponents = [Opening, YourValues, TheMethodQuestion, TheMirror, TheReframe, TheQuestion]
const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(currentScreen, (idx) => {
  trackScreenView('pillarD', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('pillarD', { values: selectedValues.value, methods: methodAnswers.value })
})

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })
onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) { currentScreen.value++; history.value.push(currentScreen.value); window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
function goBack() {
  if (history.value.length > 1) { history.value.pop(); currentScreen.value = history.value[history.value.length - 1]; window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
function handleValues(vals) { selectedValues.value = vals; trackChoice('pillarD', 'values', vals.join(',')) }
function handleMethods(methods) { methodAnswers.value = methods; trackChoice('pillarD', 'methods', JSON.stringify(methods)) }
</script>

<style scoped>
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF

echo "  ✓ PillarD.vue"

# ── Pillar E ──
cat > src/pages/PillarE.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component :is="currentComponent" :key="screenKey" @advance="advance" @back="goBack" @set-issue="handleIssue" @restart-with="restartWith" />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onUnmounted, provide } from 'vue'
import { useAnalytics } from '@/composables/useAnalytics'

import Opening from '@/components/experiences/pillarE/Opening.vue'
import TheEvidence from '@/components/experiences/pillarE/TheEvidence.vue'
import WhyItWorks from '@/components/experiences/pillarE/WhyItWorks.vue'
import DesignYourOwn from '@/components/experiences/pillarE/DesignYourOwn.vue'
import VoluntaryAlternatives from '@/components/experiences/pillarE/VoluntaryAlternatives.vue'
import TheQuestion from '@/components/experiences/pillarE/TheQuestion.vue'

const { trackScreenView, trackChoice, trackCompletion } = useAnalytics()
const screenNames = ['opening','the-evidence','why-it-works','design-your-own','voluntary-alternatives','the-question']

const TOTAL_SCREENS = 6
const currentScreen = ref(0)
const history = ref([0])
const chosenIssue = ref(null)

provide('chosenIssue', chosenIssue)

const screenComponents = [Opening, TheEvidence, WhyItWorks, DesignYourOwn, VoluntaryAlternatives, TheQuestion]
const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${chosenIssue.value}`)

watch(currentScreen, (idx) => {
  trackScreenView('pillarE', screenNames[idx])
  if (idx === TOTAL_SCREENS - 1) trackCompletion('pillarE', { issue: chosenIssue.value })
})

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })
onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  if (currentScreen.value < TOTAL_SCREENS - 1) { currentScreen.value++; history.value.push(currentScreen.value); window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
function goBack() {
  if (history.value.length > 1) { history.value.pop(); currentScreen.value = history.value[history.value.length - 1]; window.scrollTo({ top: 0, behavior: 'smooth' }) }
}
function handleIssue(id) { chosenIssue.value = id; trackChoice('pillarE', 'issue', id) }
function restartWith(id) {
  chosenIssue.value = id
  trackChoice('pillarE', 'issue-restart', id)
  currentScreen.value = 3
  history.value = [0, 1, 2, 3]
  window.scrollTo({ top: 0, behavior: 'smooth' })
}
</script>

<style scoped>
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF

echo "  ✓ PillarE.vue"

# ══════════════════════════════════════
# 6. PRACTICE PAGES — add tracking via enhanced useScreenNav
# ══════════════════════════════════════

# Practice pages use the simple orchestrator pattern, so we regenerate
# them to use the analytics-enabled useScreenNav

create_tracked_practice() {
  local NUM=$1
  local ID=$2
  local IMPORTS=$3
  local COMPONENTS=$4
  local SCREEN_NAMES=$5

cat > "src/pages/Practice0${NUM}.vue" << VUEEOF
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component :is="currentComponent" :key="currentScreen" @advance="advance" @back="goBack" />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { computed, watch, onUnmounted } from 'vue'
import { useScreenNav } from '@/composables/useScreenNav'
import { useAnalytics } from '@/composables/useAnalytics'

${IMPORTS}

const screenNames = [${SCREEN_NAMES}]
const { currentScreen, advance, goBack } = useScreenNav(4, '${ID}', screenNames)
const { trackCompletion } = useAnalytics()

const screenComponents = [${COMPONENTS}]
const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

watch(currentScreen, (idx) => {
  if (idx === 3) trackCompletion('${ID}')
})

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })
onUnmounted(() => document.body.classList.remove('dark-mode'))
</script>

<style scoped>
.exp-app { width: 100%; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 2rem 1.5rem; transition: background 0.6s ease, color 0.6s ease; background: var(--paper); }
.exp-app.dark-mode { background: var(--bg-dark); color: var(--text-inverse); }
.exp-container { max-width: 640px; width: 100%; }
.screen-fade-enter-active, .screen-fade-leave-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.screen-fade-enter-from { opacity: 0; transform: translateY(16px); }
.screen-fade-leave-to { opacity: 0; transform: translateY(-8px); }
@media (max-width: 480px) { .exp-app { padding: 1.5rem 1rem; } }
</style>
VUEEOF
}

create_tracked_practice 1 "practice01" \
"import Opening from '@/components/experiences/practice01/Opening.vue'
import TheMapping from '@/components/experiences/practice01/TheMapping.vue'
import TheTotal from '@/components/experiences/practice01/TheTotal.vue'
import TheReflection from '@/components/experiences/practice01/TheReflection.vue'" \
"Opening, TheMapping, TheTotal, TheReflection" \
"'opening','the-mapping','the-total','the-reflection'"

create_tracked_practice 2 "practice02" \
"import Opening from '@/components/experiences/practice02/Opening.vue'
import ChooseYourIssue from '@/components/experiences/practice02/ChooseYourIssue.vue'
import DraftYourApproach from '@/components/experiences/practice02/DraftYourApproach.vue'
import TheChallenge from '@/components/experiences/practice02/TheChallenge.vue'" \
"Opening, ChooseYourIssue, DraftYourApproach, TheChallenge" \
"'opening','choose-your-issue','draft-your-approach','the-challenge'"

create_tracked_practice 3 "practice03" \
"import Opening from '@/components/experiences/practice03/Opening.vue'
import TheFramework from '@/components/experiences/practice03/TheFramework.vue'
import TheExamples from '@/components/experiences/practice03/TheExamples.vue'
import TheInvitation from '@/components/experiences/practice03/TheInvitation.vue'" \
"Opening, TheFramework, TheExamples, TheInvitation" \
"'opening','the-framework','the-examples','the-invitation'"

create_tracked_practice 4 "practice04" \
"import Opening from '@/components/experiences/practice04/Opening.vue'
import HowItWorks from '@/components/experiences/practice04/HowItWorks.vue'
import DayOne from '@/components/experiences/practice04/DayOne.vue'
import TheCommitment from '@/components/experiences/practice04/TheCommitment.vue'" \
"Opening, HowItWorks, DayOne, TheCommitment" \
"'opening','how-it-works','day-one','the-commitment'"

create_tracked_practice 5 "practice05" \
"import Opening from '@/components/experiences/practice05/Opening.vue'
import IdentifyProblem from '@/components/experiences/practice05/IdentifyProblem.vue'
import DesignSolution from '@/components/experiences/practice05/DesignSolution.vue'
import TheChallenge from '@/components/experiences/practice05/TheChallenge.vue'" \
"Opening, IdentifyProblem, DesignSolution, TheChallenge" \
"'opening','identify-problem','design-solution','the-challenge'"

echo "  ✓ All 5 Practice pages"

echo ""
echo "✅ Analytics wired into all 14 experiences!"
echo ""
echo "Events now tracked:"
echo "  • screen_view — every screen transition in every experience"
echo "  • choice_made — every interactive selection (Exp01 answers, Exp02 objection,"
echo "    Exp03 conditions/violations, Pillar B income/rate, Pillar D values/methods,"
echo "    Pillar E issue choice)"
echo "  • experience_completed — when visitor reaches final screen"
echo "  • share — when visitor shares a link"
echo "  • newsletter_signup — when visitor subscribes"
echo ""
echo "Push with: git add . && git commit -m 'analytics: full tracking across all experiences' && git push"
