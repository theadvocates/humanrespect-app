#!/bin/bash
# Fix dark mode readability across the app
# Run from humanrespect-app/ root

set -e

# ── Fix 1: Update typography.css dark mode rules ──
cat > src/styles/typography.css << 'CSSEOF'
.display-large {
    font-family: var(--serif);
    font-size: clamp(2rem, 5vw, 3rem);
    line-height: 1.2;
    letter-spacing: -0.02em;
    font-weight: 400;
}

.display-medium {
    font-family: var(--serif);
    font-size: clamp(1.5rem, 3.5vw, 2rem);
    line-height: 1.3;
    letter-spacing: -0.01em;
    font-weight: 400;
}

.body-text {
    font-size: 1rem;
    line-height: 1.8;
    color: var(--ink-soft);
}

.body-text-large {
    font-size: 1.1rem;
    line-height: 1.8;
    color: var(--ink-soft);
}

.caption {
    font-size: 0.8rem;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--ink-faint);
}

/* Dark mode: boost contrast and weight */
.dark-mode .display-large,
.dark-mode .display-medium {
    color: #F0EBE3;
    font-weight: 500;
    -webkit-font-smoothing: antialiased;
}

.dark-mode .display-large em,
.dark-mode .display-medium em {
    color: rgba(240, 235, 227, 0.85);
    font-weight: 400;
}

.dark-mode .body-text,
.dark-mode .body-text-large {
    color: rgba(240, 235, 227, 0.75);
}

.dark-mode .caption {
    color: rgba(240, 235, 227, 0.45);
}
CSSEOF

echo "✅ typography.css updated"

# ── Fix 2: Update Experience01 Opening component ──
cat > src/components/experiences/exp01/Opening.vue << 'VUEEOF'
<template>
  <div class="opening stagger" ref="el">
    <span class="overline">A five-minute philosophical experiment</span>
    <h1 class="display-large headline">
      You live by a moral code<br><em>you've never put into words.</em>
    </h1>
    <Divider :centered="true" />
    <p class="subtitle">
      In the next few minutes, you'll discover what that code is — and a question
      about it you've probably never thought to ask.
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

echo "✅ Opening.vue updated"

# ── Fix 3: Update Experience01.vue to properly handle dark/light transitions ──
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
import { computed, watch } from 'vue'
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

// Only the opening screen is dark
const isDark = computed(() => currentScreen.value === 0)

// Sync dark mode to body for global styles
watch(isDark, (dark) => {
  if (dark) {
    document.body.classList.add('dark-mode')
  } else {
    document.body.classList.remove('dark-mode')
  }
}, { immediate: true })

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
</style>
VUEEOF

echo "✅ Experience01.vue updated"

echo ""
echo "🎨 Dark mode readability fixes applied."
echo "   - Headline text now brighter (#F0EBE3 instead of muted)"
echo "   - Font weight bumped to 500 on dark backgrounds"
echo "   - Body text raised to 75% opacity (was 65%)"
echo "   - Dark/light transitions sync to both component and body"
echo ""
echo "Refresh your browser to see the changes."
