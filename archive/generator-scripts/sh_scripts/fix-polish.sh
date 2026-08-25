#!/bin/bash
# Fix: headline redundancy, mobile optimization, dark mode persistence
# Run from humanrespect-app/ root

set -e

echo "🔧 Applying fixes..."

# ══════════════════════════════════════
# FIX 1: Differentiate Experience 01 opening headline
# The landing page keeps "You live by a moral code..."
# Experience 01 gets a new headline that picks up where the landing left off
# ══════════════════════════════════════

cat > src/components/experiences/exp01/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">A five-minute philosophical experiment</span>
    <h1 class="display-large headline">
      Let's find it.<br><em>Two questions. One mirror.</em>
    </h1>
    <Divider :centered="true" />
    <p class="subtitle">
      You're about to answer two simple questions. Then you'll see them
      side by side — and notice something you've probably never noticed before.
    </p>
    <button class="begin-btn" @click="$emit('advance')">
      Begin <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'

defineEmits(['advance'])

const el = ref(null)
onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
})
</script>

<style scoped>
.opening {
  text-align: center;
  padding: 2rem 0;
}

.overline {
  font-size: 0.75rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--ochre-light);
  margin-bottom: 2rem;
  display: block;
}

.headline {
  color: #F0EBE3;
  font-weight: 500;
}

.headline em {
  color: rgba(240, 235, 227, 0.85);
  font-weight: 400;
  font-style: italic;
}

.subtitle {
  font-family: var(--sans);
  font-size: 1rem;
  line-height: 1.8;
  color: rgba(240, 235, 227, 0.65);
  max-width: 480px;
  margin: 0 auto;
}

.begin-btn {
  display: inline-block;
  margin-top: 3rem;
  padding: 1rem 3rem;
  background: transparent;
  color: var(--ochre-light);
  border: 1px solid var(--ochre-light);
  border-radius: 100px;
  font-family: var(--serif);
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  letter-spacing: 0.05em;
}

.begin-btn:hover {
  background: var(--ochre-light);
  color: var(--bg-dark);
}

.begin-btn .arrow {
  display: inline-block;
  transition: transform 0.3s ease;
}

.begin-btn:hover .arrow {
  transform: translateX(4px);
}
</style>
VUEEOF

echo "  ✓ Fix 1: Experience 01 headline differentiated"

# ══════════════════════════════════════
# FIX 2: Mobile optimization across base styles
# ══════════════════════════════════════

cat > src/styles/base.css << 'CSSEOF'
@import url('https://fonts.googleapis.com/css2?family=Cormorant:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400;1,500;1,600&family=Karla:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400&display=swap');

*, *::before, *::after {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html {
    font-size: 18px;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    scroll-behavior: smooth;
}

body {
    font-family: var(--sans);
    color: var(--ink);
    background: var(--paper);
    line-height: 1.7;
    overflow-x: hidden;
    transition: background var(--transition), color var(--transition);
}

body.dark-mode {
    background: var(--bg-dark);
    color: var(--text-inverse);
}

/* Paper texture */
body::before {
    content: '';
    position: fixed;
    inset: 0;
    pointer-events: none;
    z-index: 9999;
    opacity: 0.025;
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
    background-repeat: repeat;
}

::selection {
    background: var(--ochre-faint);
    color: var(--ink);
}

a {
    color: inherit;
    text-decoration: none;
}

/* Stagger animation utility */
.stagger > * {
    opacity: 0;
    transform: translateY(12px);
    transition: opacity 0.5s ease, transform 0.5s ease;
}

.stagger.animate > *:nth-child(1) { transition-delay: 0.05s; opacity: 1; transform: translateY(0); }
.stagger.animate > *:nth-child(2) { transition-delay: 0.15s; opacity: 1; transform: translateY(0); }
.stagger.animate > *:nth-child(3) { transition-delay: 0.25s; opacity: 1; transform: translateY(0); }
.stagger.animate > *:nth-child(4) { transition-delay: 0.35s; opacity: 1; transform: translateY(0); }
.stagger.animate > *:nth-child(5) { transition-delay: 0.45s; opacity: 1; transform: translateY(0); }
.stagger.animate > *:nth-child(6) { transition-delay: 0.55s; opacity: 1; transform: translateY(0); }
.stagger.animate > *:nth-child(7) { transition-delay: 0.65s; opacity: 1; transform: translateY(0); }
.stagger.animate > *:nth-child(8) { transition-delay: 0.75s; opacity: 1; transform: translateY(0); }
.stagger.animate > *:nth-child(9) { transition-delay: 0.85s; opacity: 1; transform: translateY(0); }
.stagger.animate > *:nth-child(10) { transition-delay: 0.95s; opacity: 1; transform: translateY(0); }

/* Scroll reveal */
.reveal {
    opacity: 0;
    transform: translateY(24px);
    transition: opacity 0.8s ease, transform 0.8s cubic-bezier(0.22, 1, 0.36, 1);
}

.reveal.visible {
    opacity: 1;
    transform: translateY(0);
}

.reveal-stagger > * {
    opacity: 0;
    transform: translateY(16px);
    transition: opacity 0.6s ease, transform 0.6s cubic-bezier(0.22, 1, 0.36, 1);
}

.reveal-stagger.visible > *:nth-child(1) { transition-delay: 0s;   opacity: 1; transform: translateY(0); }
.reveal-stagger.visible > *:nth-child(2) { transition-delay: 0.1s; opacity: 1; transform: translateY(0); }
.reveal-stagger.visible > *:nth-child(3) { transition-delay: 0.2s; opacity: 1; transform: translateY(0); }

/* ── Mobile Optimization ── */

@media (max-width: 680px) {
    html {
        font-size: 16px;
    }
}

@media (max-width: 480px) {
    html {
        font-size: 15px;
    }
}

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}
CSSEOF

echo "  ✓ Fix 2a: Base styles mobile breakpoints"

# ── Mobile fixes for shared components ──

cat > src/components/shared/NavBar.vue << 'VUEEOF'
<template>
  <div class="nav-area">
    <button
      class="nav-back"
      :disabled="!canGoBack"
      @click="$emit('back')"
    >← Back</button>
    <button
      class="nav-continue"
      :disabled="disableContinue"
      @click="$emit('continue')"
    >
      Continue <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
defineProps({
  canGoBack: { type: Boolean, default: true },
  disableContinue: { type: Boolean, default: false }
})
defineEmits(['back', 'continue'])
</script>

<style scoped>
.nav-area {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 2.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid var(--border-subtle);
}
.nav-back {
  background: none;
  border: none;
  font-family: inherit;
  font-size: 0.85rem;
  color: var(--ink-faint);
  cursor: pointer;
  padding: 0.75rem 0;
  transition: color 0.2s ease;
  -webkit-tap-highlight-color: transparent;
}
.nav-back:hover { color: var(--ink); }
.nav-back:disabled { opacity: 0; cursor: default; }
.nav-continue {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.85rem 2rem;
  background: var(--ochre);
  color: white;
  border: none;
  border-radius: 100px;
  font-family: inherit;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.25s ease;
  -webkit-tap-highlight-color: transparent;
}
.nav-continue:hover { background: var(--ochre-light); transform: translateY(-1px); }
.nav-continue:disabled { opacity: 0.35; cursor: not-allowed; transform: none; }
.nav-continue .arrow { transition: transform 0.2s ease; }
.nav-continue:hover:not(:disabled) .arrow { transform: translateX(3px); }

@media (max-width: 480px) {
  .nav-continue {
    padding: 0.85rem 1.5rem;
    font-size: 0.85rem;
  }
}
</style>
VUEEOF

cat > src/components/shared/ChoiceCard.vue << 'VUEEOF'
<template>
  <button
    class="choice"
    :class="{ selected }"
    @click="$emit('select')"
  >
    <strong><slot name="label" /></strong>
    <span v-if="$slots.detail" class="choice-detail"><slot name="detail" /></span>
  </button>
</template>

<script setup>
defineProps({
  selected: { type: Boolean, default: false }
})
defineEmits(['select'])
</script>

<style scoped>
.choice {
  display: block;
  width: 100%;
  padding: 1.25rem 1.5rem;
  margin-bottom: 0.75rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  font-family: inherit;
  font-size: 0.95rem;
  line-height: 1.6;
  color: var(--ink);
  box-shadow: var(--shadow-soft);
  -webkit-tap-highlight-color: transparent;
}
.choice:hover {
  border-color: var(--ochre);
  box-shadow: var(--shadow-hover);
  transform: translateY(-1px);
}
.choice:active {
  transform: translateY(0);
}
.choice.selected {
  border-color: var(--ochre);
  background: var(--ochre-faint);
}
.choice strong { color: var(--ink); }
.choice-detail {
  display: block;
  font-size: 0.85rem;
  color: var(--ink-muted);
  margin-top: 0.35rem;
}

@media (max-width: 480px) {
  .choice {
    padding: 1rem 1.25rem;
    font-size: 0.9rem;
  }
  .choice-detail {
    font-size: 0.8rem;
  }
}
</style>
VUEEOF

cat > src/components/shared/ContentBlock.vue << 'VUEEOF'
<template>
  <div class="block" :class="variantClass">
    <span v-if="label" class="block-label">{{ label }}</span>
    <slot />
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  variant: {
    type: String,
    default: 'principle',
    validator: v => ['principle', 'insight', 'mirror', 'concession'].includes(v)
  },
  label: { type: String, default: '' }
})

const variantClass = computed(() => `block-${props.variant}`)
</script>

<style scoped>
.block {
  padding: 1.5rem 1.75rem;
  margin: 2rem 0;
  border-radius: 0 var(--radius) var(--radius) 0;
}
.block :deep(p) { line-height: 1.7; }
.block :deep(p + p) { margin-top: 0.75rem; }

.block-label {
  font-size: 0.7rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  display: block;
  margin-bottom: 0.75rem;
  opacity: 0.7;
}

.block-principle {
  background: var(--ochre-faint);
  border-left: 3px solid var(--ochre);
}
.block-principle :deep(p) {
  font-family: var(--serif);
  font-size: 1.05rem;
  color: var(--ink);
  font-style: italic;
}

.block-insight {
  background: var(--insight-bg);
  border-left: 3px solid var(--insight-green);
}
.block-insight :deep(p) { color: var(--insight-green); }
.block-insight .block-label { color: var(--insight-green); }

.block-mirror {
  background: var(--mirror-bg);
  border-left: 3px solid var(--mirror-blue);
}
.block-mirror :deep(p) { color: var(--mirror-blue); }
.block-mirror .block-label { color: var(--mirror-blue); }

.block-concession {
  background: var(--concede-bg);
  border-left: 3px solid var(--concede-warm);
}
.block-concession :deep(p) { color: var(--concede-warm); }
.block-concession .block-label { color: var(--concede-warm); }

@media (max-width: 480px) {
  .block {
    padding: 1.25rem 1.25rem;
    margin: 1.5rem 0;
  }
}
</style>
VUEEOF

cat > src/components/shared/ScenarioBox.vue << 'VUEEOF'
<template>
  <div class="scenario">
    <span v-if="label" class="scenario-label">{{ label }}</span>
    <slot />
  </div>
</template>

<script setup>
defineProps({
  label: { type: String, default: '' }
})
</script>

<style scoped>
.scenario {
  background: var(--cream);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius);
  padding: 2rem;
  margin: 2rem 0;
  box-shadow: var(--shadow-soft);
}
.scenario-label {
  font-size: 0.7rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--ochre);
  margin-bottom: 1rem;
  display: block;
}
.scenario :deep(p) { color: var(--ink); line-height: 1.8; }
.scenario :deep(p + p) { margin-top: 1rem; }

@media (max-width: 480px) {
  .scenario {
    padding: 1.5rem;
    margin: 1.5rem 0;
  }
}
</style>
VUEEOF

echo "  ✓ Fix 2b: Shared components mobile optimized"

# ── Mobile fixes for Experience pages ──

cat > src/pages/Experience01.vue << 'VUEEOF'
<template>
  <div class="exp-app" :class="{ 'dark-mode': isDark }">
    <div class="exp-container">
      <Transition name="screen-fade" mode="out-in">
        <component
          :is="currentComponent"
          :key="currentScreen"
          @advance="advance"
          @back="goBack"
          @choose="handleChoice"
        />
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { computed, watch, onUnmounted } from 'vue'
import { useScreenNav } from '@/composables/useScreenNav'
import { useJourneyStore } from '@/stores/journey'

import Opening from '@/components/experiences/exp01/Opening.vue'
import CommonGround from '@/components/experiences/exp01/CommonGround.vue'
import Scenario from '@/components/experiences/exp01/Scenario.vue'
import PersonalChoice from '@/components/experiences/exp01/PersonalChoice.vue'
import PoliticalChoice from '@/components/experiences/exp01/PoliticalChoice.vue'
import Mirror from '@/components/experiences/exp01/Mirror.vue'
import WhyTheGap from '@/components/experiences/exp01/WhyTheGap.vue'
import ThePrinciple from '@/components/experiences/exp01/ThePrinciple.vue'
import Invitation from '@/components/experiences/exp01/Invitation.vue'

const TOTAL_SCREENS = 9
const { currentScreen, advance, goBack } = useScreenNav(TOTAL_SCREENS)
const journey = useJourneyStore()

const screenComponents = [
  Opening, CommonGround, Scenario, PersonalChoice, PoliticalChoice,
  Mirror, WhyTheGap, ThePrinciple, Invitation
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

// Sync dark mode to body
watch(isDark, (dark) => {
  if (dark) {
    document.body.classList.add('dark-mode')
  } else {
    document.body.classList.remove('dark-mode')
  }
}, { immediate: true })

// CRITICAL: Clean up dark mode when leaving this page
onUnmounted(() => {
  document.body.classList.remove('dark-mode')
})

function handleChoice({ key, value }) {
  if (key === 'personal') journey.exp01.personal = value
  if (key === 'political') journey.exp01.political = value
  journey.persist()
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

.screen-fade-enter-from {
  opacity: 0;
  transform: translateY(16px);
}

.screen-fade-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}

@media (max-width: 480px) {
  .exp-app {
    padding: 1.5rem 1rem;
  }
}
</style>
VUEEOF

echo "  ✓ Fix 3a: Experience01 dark mode cleanup on unmount"

# ── Same fix for Experience 02 ──

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
import { ref, computed, watch, onUnmounted } from 'vue'
import { useJourneyStore } from '@/stores/journey'

import Opening from '@/components/experiences/exp02/Opening.vue'
import ChooseObjection from '@/components/experiences/exp02/ChooseObjection.vue'
import Steelman from '@/components/experiences/exp02/Steelman.vue'
import Response from '@/components/experiences/exp02/Response.vue'
import Concession from '@/components/experiences/exp02/Concession.vue'
import TheQuestion from '@/components/experiences/exp02/TheQuestion.vue'
import WhereNext from '@/components/experiences/exp02/WhereNext.vue'

const journey = useJourneyStore()

const currentScreen = ref(0)
const history = ref([0])

const screenComponents = [
  Opening, ChooseObjection, Steelman, Response, Concession, TheQuestion, WhereNext
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)
const screenKey = computed(() => `${currentScreen.value}-${journey.exp02.chosenObjection}`)

watch(isDark, (dark) => {
  if (dark) {
    document.body.classList.add('dark-mode')
  } else {
    document.body.classList.remove('dark-mode')
  }
}, { immediate: true })

// Clean up dark mode when leaving
onUnmounted(() => {
  document.body.classList.remove('dark-mode')
})

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
}

function restartWith(key) {
  journey.exp02.chosenObjection = key
  journey.persist()
  currentScreen.value = 2
  history.value = [0, 1, 2]
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

function handleShare() {
  const text = "I picked my strongest objection to a philosophical idea — and it got a more honest answer than I expected."
  const url = window.location.origin + '/experience/the-objection'

  if (navigator.share) {
    navigator.share({ title: 'The Objection You\'re Already Thinking', text, url })
  } else {
    navigator.clipboard.writeText(text + ' ' + url)
  }
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
  .exp-app {
    padding: 1.5rem 1rem;
  }
}
</style>
VUEEOF

echo "  ✓ Fix 3b: Experience02 dark mode cleanup on unmount"

# ── Mobile fixes for landing page ──

cat > src/pages/LandingPage.vue << 'VUEEOF'
<template>
  <div>
    <!-- Hero -->
    <section class="hero">
      <div class="hero-mark"></div>
      <h1 class="hero-headline">
        You live by a moral code<br>
        <em>you've never put into words.</em>
      </h1>
      <p class="hero-sub">A five-minute philosophical experiment</p>
      <router-link :to="{ name: 'exp01' }" class="hero-begin">
        Begin <span class="arrow">→</span>
      </router-link>
      <div class="hero-scroll-hint" ref="scrollHint">
        <span>Or learn more</span>
        <div class="scroll-line"></div>
      </div>
    </section>

    <!-- Context -->
    <section class="context">
      <div class="context-inner reveal">
        <div class="context-label">What this is</div>
        <p class="context-text">
          Most people hold <strong>one moral standard</strong> for their personal life
          and <strong>a completely different one</strong> for politics — without ever
          noticing the gap.
        </p>
        <p class="context-detail">
          This short experience uses a single thought experiment to surface
          that gap in your own thinking. It doesn't tell you what to believe.
          It shows you what you already believe — and asks one question
          you've probably never considered.
        </p>
        <router-link :to="{ name: 'exp01' }" class="context-cta">
          Start the experiment <span class="arrow">→</span>
        </router-link>
      </div>
    </section>

    <!-- Attributes -->
    <section class="attributes">
      <div class="attributes-inner reveal-stagger">
        <div class="attribute">
          <span class="attribute-number">01</span>
          <div class="attribute-title">Five minutes</div>
          <p class="attribute-desc">
            Two questions. One mirror. An insight
            that stays with you longer than it should.
          </p>
        </div>
        <div class="attribute">
          <span class="attribute-number">02</span>
          <div class="attribute-title">No right answers</div>
          <p class="attribute-desc">
            This isn't a quiz. There's no score, no grade,
            no personality type. Just your own thinking,
            reflected back.
          </p>
        </div>
        <div class="attribute">
          <span class="attribute-number">03</span>
          <div class="attribute-title">Worth sharing</div>
          <p class="attribute-desc">
            The best part is finding out how someone you
            disagree with answers the same questions.
          </p>
        </div>
      </div>
    </section>

    <!-- Closing -->
    <section class="closing">
      <p class="closing-headline reveal">
        Every person you've ever argued with about politics
        shares something fundamental with you.<br><br>
        This is how you find out what it is.
      </p>
      <router-link :to="{ name: 'exp01' }" class="closing-begin reveal">
        Begin the experiment <span class="arrow">→</span>
      </router-link>
    </section>

    <!-- Footer -->
    <footer class="footer">
      <div class="footer-inner">
        <div class="footer-left">Human Respect</div>
        <div class="footer-right">
          <router-link to="/about" class="footer-link">About</router-link>
          <a href="#" class="footer-link">Privacy</a>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue'
import { useScrollReveal } from '@/composables/useScrollReveal'

useScrollReveal()

const scrollHint = ref(null)
let scrollHidden = false

function handleScroll() {
  if (!scrollHidden && window.scrollY > 80 && scrollHint.value) {
    scrollHint.value.style.opacity = '0'
    scrollHint.value.style.transition = 'opacity 0.5s ease'
    scrollHidden = true
  }
}

onMounted(() => {
  // Ensure dark mode is off on landing page
  document.body.classList.remove('dark-mode')
  window.addEventListener('scroll', handleScroll, { passive: true })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
/* ── Hero ── */
.hero {
  min-height: 100vh;
  min-height: 100dvh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  padding: 4rem 2rem;
  position: relative;
}

.hero-mark {
  width: 32px;
  height: 1px;
  background: var(--ochre);
  margin-bottom: 3rem;
  opacity: 0;
  animation: fadeIn 1s ease 0.3s forwards;
}

.hero-headline {
  font-family: var(--serif);
  font-size: clamp(2.2rem, 5.5vw, 3.8rem);
  font-weight: 400;
  line-height: 1.2;
  letter-spacing: -0.025em;
  color: var(--ink);
  max-width: 720px;
  opacity: 0;
  animation: revealUp 1.2s cubic-bezier(0.22, 1, 0.36, 1) 0.5s forwards;
}

.hero-headline em {
  font-style: italic;
  font-weight: 300;
  color: var(--ink-soft);
}

.hero-sub {
  font-family: var(--sans);
  font-size: 0.95rem;
  font-weight: 400;
  color: var(--ink-muted);
  margin-top: 2.5rem;
  letter-spacing: 0.01em;
  opacity: 0;
  animation: fadeIn 1s ease 1.4s forwards;
}

.hero-begin {
  display: inline-flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 3.5rem;
  padding: 0.9rem 2.5rem;
  font-family: var(--serif);
  font-size: 1.05rem;
  font-weight: 500;
  letter-spacing: 0.03em;
  color: var(--ochre);
  background: transparent;
  border: 1px solid var(--ochre);
  border-radius: 100px;
  cursor: pointer;
  text-decoration: none;
  transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  opacity: 0;
  animation: fadeIn 0.8s ease 1.8s forwards;
  -webkit-tap-highlight-color: transparent;
}

.hero-begin:hover {
  background: var(--ochre);
  color: var(--cream);
  transform: translateY(-1px);
  box-shadow: 0 4px 20px rgba(154, 123, 79, 0.2);
}

.hero-begin .arrow {
  display: inline-block;
  transition: transform 0.3s ease;
}

.hero-begin:hover .arrow {
  transform: translateX(4px);
}

.hero-scroll-hint {
  position: absolute;
  bottom: 2.5rem;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  opacity: 0;
  animation: fadeIn 1s ease 3s forwards;
}

.hero-scroll-hint span {
  font-size: 0.65rem;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--ink-faint);
}

.scroll-line {
  width: 1px;
  height: 28px;
  background: linear-gradient(to bottom, var(--ink-faint), transparent);
  animation: pulseDown 2s ease-in-out infinite;
}

/* ── Context ── */
.context {
  padding: 8rem 2rem;
  display: flex;
  justify-content: center;
  background: var(--cream);
  border-top: 1px solid var(--paper-deep);
}

.context-inner { max-width: 560px; width: 100%; }

.context-label {
  font-size: 0.65rem;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: var(--ochre);
  margin-bottom: 2rem;
}

.context-text {
  font-family: var(--serif);
  font-size: 1.35rem;
  font-weight: 400;
  line-height: 1.65;
  color: var(--ink-soft);
}

.context-text strong { color: var(--ink); font-weight: 500; }

.context-detail {
  font-family: var(--sans);
  font-size: 0.88rem;
  line-height: 1.8;
  color: var(--ink-muted);
  margin-top: 2.5rem;
}

.context-cta {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 2.5rem;
  font-family: var(--serif);
  font-size: 1rem;
  font-weight: 500;
  color: var(--ochre);
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: border-color 0.3s ease;
}

.context-cta:hover { border-bottom-color: var(--ochre); }
.context-cta .arrow { display: inline-block; transition: transform 0.3s ease; }
.context-cta:hover .arrow { transform: translateX(4px); }

/* ── Attributes ── */
.attributes {
  padding: 6rem 2rem;
  display: flex;
  justify-content: center;
  background: var(--paper);
}

.attributes-inner {
  max-width: 720px;
  width: 100%;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 3rem;
}

.attribute { text-align: left; }

.attribute-number {
  font-family: var(--serif);
  font-size: 0.85rem;
  font-weight: 400;
  color: var(--ochre);
  margin-bottom: 0.75rem;
  display: block;
}

.attribute-title {
  font-family: var(--serif);
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.5rem;
  line-height: 1.3;
}

.attribute-desc {
  font-family: var(--sans);
  font-size: 0.8rem;
  color: var(--ink-muted);
  line-height: 1.65;
}

/* ── Closing ── */
.closing {
  padding: 8rem 2rem;
  text-align: center;
  background: var(--ink);
  color: var(--paper);
  position: relative;
}

.closing::before {
  content: '';
  position: absolute;
  top: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 1px;
  height: 60px;
  background: linear-gradient(to bottom, var(--paper-deep), var(--ink));
}

.closing-headline {
  font-family: var(--serif);
  font-size: clamp(1.4rem, 3.5vw, 2rem);
  font-weight: 300;
  font-style: italic;
  line-height: 1.45;
  color: var(--paper-warm);
  max-width: 480px;
  margin: 0 auto;
}

.closing-begin {
  display: inline-flex;
  align-items: center;
  gap: 0.6rem;
  margin-top: 3rem;
  padding: 0.85rem 2.5rem;
  font-family: var(--serif);
  font-size: 1rem;
  font-weight: 500;
  letter-spacing: 0.03em;
  color: var(--ochre-light);
  background: transparent;
  border: 1px solid rgba(184, 153, 94, 0.4);
  border-radius: 100px;
  text-decoration: none;
  transition: all 0.4s ease;
  -webkit-tap-highlight-color: transparent;
}

.closing-begin:hover {
  background: var(--ochre);
  color: var(--ink);
  border-color: var(--ochre);
}

.closing-begin .arrow { display: inline-block; transition: transform 0.3s ease; }
.closing-begin:hover .arrow { transform: translateX(4px); }

/* ── Footer ── */
.footer {
  padding: 3rem 2rem;
  background: var(--ink);
  border-top: 1px solid rgba(244, 240, 234, 0.06);
  display: flex;
  justify-content: center;
}

.footer-inner {
  max-width: 720px;
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-left {
  font-family: var(--serif);
  font-size: 0.85rem;
  font-weight: 400;
  color: rgba(244, 240, 234, 0.3);
}

.footer-right { display: flex; gap: 2rem; }

.footer-link {
  font-family: var(--sans);
  font-size: 0.72rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: rgba(244, 240, 234, 0.25);
  text-decoration: none;
  transition: color 0.3s ease;
}

.footer-link:hover { color: rgba(244, 240, 234, 0.6); }

/* ── Keyframes ── */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes revealUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes pulseDown {
  0%, 100% { opacity: 0.3; transform: scaleY(1); }
  50% { opacity: 0.7; transform: scaleY(1.2); transform-origin: top; }
}

/* ── Responsive ── */
@media (max-width: 680px) {
  .hero { padding: 3rem 1.5rem; }
  .context { padding: 5rem 1.5rem; }
  .attributes { padding: 4rem 1.5rem; }
  .attributes-inner {
    grid-template-columns: 1fr;
    gap: 2.5rem;
  }
  .attribute {
    padding-left: 1rem;
    border-left: 1px solid var(--paper-deep);
  }
  .closing { padding: 5rem 1.5rem; }
  .footer-inner {
    flex-direction: column;
    gap: 1.5rem;
    text-align: center;
  }
  .hero-scroll-hint { display: none; }
}

@media (max-width: 480px) {
  .hero { padding: 2.5rem 1.25rem; }
  .hero-headline { font-size: clamp(1.8rem, 7vw, 2.4rem); }
  .hero-begin { padding: 0.85rem 2rem; font-size: 1rem; }
  .context { padding: 3.5rem 1.25rem; }
  .context-text { font-size: 1.15rem; }
  .attributes { padding: 3rem 1.25rem; }
  .closing { padding: 3.5rem 1.25rem; }
  .closing-begin { padding: 0.85rem 2rem; }
}
</style>
VUEEOF

echo "  ✓ Fix 2c + 3c: Landing page mobile + dark mode cleanup"

echo ""
echo "✅ All fixes applied."
echo ""
echo "What changed:"
echo "  1. Experience 01 opening now says 'Let's find it. Two questions. One mirror.'"
echo "     instead of repeating the landing page headline."
echo "  2. Mobile breakpoints at 680px and 480px across all components."
echo "     Smaller padding, font sizes, and touch-friendly tap targets."
echo "  3. Both Experience pages call onUnmounted to remove dark-mode class from body."
echo "     Landing page also explicitly removes dark-mode on mount."
echo ""
echo "Push with: git add . && git commit -m 'fix: headlines, mobile, dark mode' && git push"
