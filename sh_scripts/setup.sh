#!/bin/bash
# humanrespect.app — Vue Project Setup
# Run from your humanrespect-app/ project root
# Usage: bash setup.sh

set -e

echo "🏗️  Setting up humanrespect.app..."

# ── Create directory structure ──
mkdir -p src/styles
mkdir -p src/lib
mkdir -p src/stores
mkdir -p src/composables
mkdir -p src/components/shared
mkdir -p src/components/experiences/exp01
mkdir -p src/components/experiences/exp02
mkdir -p src/pages

echo "📁 Directories created"

# ══════════════════════════════════════
# STYLES
# ══════════════════════════════════════

cat > src/styles/tokens.css << 'CSSEOF'
:root {
    --ink: #1E1C19;
    --ink-soft: #3D3A34;
    --ink-muted: #6E6A62;
    --ink-faint: #A09B92;
    --paper: #F4F0EA;
    --paper-warm: #EDE8E0;
    --paper-deep: #E4DED5;
    --cream: #FAF8F5;
    --bg-dark: #1A1A2E;
    --text-inverse: #F0EBE3;

    --ochre: #9A7B4F;
    --ochre-light: #B8995E;
    --ochre-faint: rgba(154, 123, 79, 0.08);

    --insight-green: #2E5E4E;
    --insight-bg: #E8F0EC;
    --mirror-blue: #3A4A6B;
    --mirror-bg: #E8ECF3;
    --concede-warm: #7A4A2A;
    --concede-bg: #F3ECE5;

    --border-subtle: #E5E0D8;
    --shadow-soft: 0 2px 20px rgba(45, 42, 38, 0.06);
    --shadow-hover: 0 4px 30px rgba(45, 42, 38, 0.12);
    --radius: 8px;

    --serif: 'Cormorant', Georgia, 'Times New Roman', serif;
    --sans: 'Karla', 'Helvetica Neue', Helvetica, Arial, sans-serif;

    --transition: 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}
CSSEOF

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

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}

@media (max-width: 600px) {
    html { font-size: 16px; }
}
CSSEOF

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

.dark-mode .body-text,
.dark-mode .body-text-large {
    color: rgba(240, 235, 227, 0.65);
}

.dark-mode .caption {
    color: rgba(240, 235, 227, 0.35);
}

.dark-mode .display-large,
.dark-mode .display-medium {
    color: var(--text-inverse);
}
CSSEOF

echo "🎨 Styles created"

# ══════════════════════════════════════
# COMPOSABLES
# ══════════════════════════════════════

cat > src/composables/useScrollReveal.js << 'JSEOF'
import { onMounted, onUnmounted } from 'vue'

export function useScrollReveal() {
  let observer = null

  onMounted(() => {
    observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible')
        }
      })
    }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' })

    document.querySelectorAll('.reveal, .reveal-stagger').forEach(el => {
      observer.observe(el)
    })
  })

  onUnmounted(() => {
    if (observer) observer.disconnect()
  })
}
JSEOF

cat > src/composables/useScreenNav.js << 'JSEOF'
import { ref, nextTick } from 'vue'

export function useScreenNav(totalScreens) {
  const currentScreen = ref(0)
  const history = ref([0])
  const isTransitioning = ref(false)

  async function advance() {
    if (isTransitioning.value) return
    if (currentScreen.value < totalScreens - 1) {
      isTransitioning.value = true
      currentScreen.value++
      history.value.push(currentScreen.value)
      await nextTick()
      window.scrollTo({ top: 0, behavior: 'smooth' })
      setTimeout(() => { isTransitioning.value = false }, 400)
    }
  }

  async function goBack() {
    if (isTransitioning.value) return
    if (history.value.length > 1) {
      isTransitioning.value = true
      history.value.pop()
      currentScreen.value = history.value[history.value.length - 1]
      await nextTick()
      window.scrollTo({ top: 0, behavior: 'smooth' })
      setTimeout(() => { isTransitioning.value = false }, 400)
    }
  }

  function goTo(index) {
    currentScreen.value = index
    history.value = Array.from({ length: index + 1 }, (_, i) => i)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  return { currentScreen, history, advance, goBack, goTo, isTransitioning }
}
JSEOF

echo "🔧 Composables created"

# ══════════════════════════════════════
# SHARED COMPONENTS
# ══════════════════════════════════════

cat > src/components/shared/Divider.vue << 'VUEEOF'
<template>
  <div class="divider" :class="{ centered }"></div>
</template>

<script setup>
defineProps({
  centered: { type: Boolean, default: false }
})
</script>

<style scoped>
.divider {
  width: 40px;
  height: 1px;
  background: var(--ochre);
  margin: 2rem 0;
  opacity: 0.4;
}
.divider.centered {
  margin: 2rem auto;
}
</style>
VUEEOF

cat > src/components/shared/StepDots.vue << 'VUEEOF'
<template>
  <div class="step-indicator">
    <div
      v-for="i in total"
      :key="i"
      class="step-dot"
      :class="{
        active: i - 1 === current,
        completed: i - 1 < current
      }"
    />
  </div>
</template>

<script setup>
defineProps({
  current: { type: Number, required: true },
  total: { type: Number, required: true }
})
</script>

<style scoped>
.step-indicator {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-bottom: 2.5rem;
}
.step-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--border-subtle);
  transition: all 0.3s ease;
}
.step-dot.active {
  background: var(--ochre);
  transform: scale(1.3);
}
.step-dot.completed {
  background: var(--ochre-light);
}
.dark-mode .step-dot { background: rgba(255,255,255,0.15); }
.dark-mode .step-dot.active { background: var(--ochre-light); }
</style>
VUEEOF

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
  margin-top: 3rem;
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
  padding: 0.5rem 0;
  transition: color 0.2s ease;
}
.nav-back:hover { color: var(--ink); }
.nav-back:disabled { opacity: 0; cursor: default; }
.nav-continue {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.75rem;
  background: var(--ochre);
  color: white;
  border: none;
  border-radius: 100px;
  font-family: inherit;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.25s ease;
}
.nav-continue:hover { background: var(--ochre-light); transform: translateY(-1px); }
.nav-continue:disabled { opacity: 0.35; cursor: not-allowed; transform: none; }
.nav-continue .arrow { transition: transform 0.2s ease; }
.nav-continue:hover:not(:disabled) .arrow { transform: translateX(3px); }
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
}
.choice:hover {
  border-color: var(--ochre);
  box-shadow: var(--shadow-hover);
  transform: translateY(-1px);
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
</style>
VUEEOF

cat > src/components/shared/PathCard.vue << 'VUEEOF'
<template>
  <component
    :is="href ? 'a' : 'router-link'"
    :href="href"
    :to="to"
    class="path-card"
    @click="$emit('click', $event)"
  >
    <div class="path-title"><slot name="title" /></div>
    <div class="path-desc"><slot name="desc" /></div>
  </component>
</template>

<script setup>
defineProps({
  href: { type: String, default: null },
  to: { type: [String, Object], default: null }
})
defineEmits(['click'])
</script>

<style scoped>
.path-card {
  display: block;
  width: 100%;
  padding: 1.5rem;
  margin-bottom: 1rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.25s ease;
  text-align: left;
  text-decoration: none;
  color: inherit;
}
.path-card:hover {
  border-color: var(--ochre);
  box-shadow: var(--shadow-hover);
  transform: translateY(-2px);
}
.path-title {
  font-family: var(--serif);
  font-size: 1.05rem;
  color: var(--ink);
  margin-bottom: 0.35rem;
}
.path-desc {
  font-size: 0.85rem;
  color: var(--ink-muted);
  line-height: 1.6;
}
</style>
VUEEOF

echo "🧱 Shared components created"

# ══════════════════════════════════════
# PINIA STORE
# ══════════════════════════════════════

cat > src/stores/journey.js << 'JSEOF'
import { defineStore } from 'pinia'
import { supabase } from '@/lib/supabase'

const USE_SUPABASE = false

export const useJourneyStore = defineStore('journey', {
  state: () => ({
    visitorId: null,
    exp01: {
      completed: false,
      personal: null,
      political: null,
      completedAt: null
    },
    exp02: {
      completed: false,
      chosenObjection: null,
      reflection: null,
      completedAt: null
    },
    visitor: {
      firstVisit: null,
      totalExperiences: 0,
      lastVisit: null
    }
  }),

  getters: {
    mirrorPattern: (state) => {
      const { personal, political } = state.exp01
      if (!personal || !political) return null
      if (personal === 'no' && political === 'yes') return 'gap'
      if (personal === 'no' && political === 'no') return 'consistent-voluntary'
      if (personal === 'yes' && political === 'yes') return 'consistent-coercive'
      return 'unusual'
    },
    foundationComplete: (state) => state.exp01.completed && state.exp02.completed,
    suggestedNext: (state) => {
      if (!state.exp01.completed) return 'exp01'
      if (!state.exp02.completed) return 'exp02'
      return 'library'
    }
  },

  actions: {
    completeExp01(personal, political) {
      this.exp01.personal = personal
      this.exp01.political = political
      this.exp01.completed = true
      this.exp01.completedAt = new Date().toISOString()
      this.visitor.totalExperiences++
      this.persist()
    },
    completeExp02(objection, reflection) {
      this.exp02.chosenObjection = objection
      this.exp02.reflection = reflection
      this.exp02.completed = true
      this.exp02.completedAt = new Date().toISOString()
      this.visitor.totalExperiences++
      this.persist()
    },
    recordVisit() {
      const now = new Date().toISOString()
      if (!this.visitor.firstVisit) this.visitor.firstVisit = now
      this.visitor.lastVisit = now
      if (!this.visitorId) this.visitorId = crypto.randomUUID()
      this.persist()
    },
    persist() {
      try {
        localStorage.setItem('hr-journey', JSON.stringify(this.$state))
      } catch (e) { /* silent */ }
      if (USE_SUPABASE) this.syncToSupabase()
    },
    hydrate() {
      try {
        const saved = localStorage.getItem('hr-journey')
        if (saved) this.$patch(JSON.parse(saved))
      } catch (e) { /* fresh start */ }
    },
    async syncToSupabase() {
      if (!this.visitorId) return
      try {
        await supabase.from('journeys').upsert({
          visitor_id: this.visitorId,
          exp01_personal: this.exp01.personal,
          exp01_political: this.exp01.political,
          exp01_completed: this.exp01.completed,
          mirror_pattern: this.mirrorPattern,
          exp02_objection: this.exp02.chosenObjection,
          exp02_completed: this.exp02.completed,
          total_experiences: this.visitor.totalExperiences,
          first_visit: this.visitor.firstVisit,
          last_visit: this.visitor.lastVisit,
          updated_at: new Date().toISOString()
        }, { onConflict: 'visitor_id' })
      } catch (e) { console.warn('Supabase sync failed:', e) }
    },
    async trackEvent(eventName, properties = {}) {
      if (!USE_SUPABASE) return
      try {
        await supabase.from('events').insert({
          visitor_id: this.visitorId,
          event_name: eventName,
          properties,
          created_at: new Date().toISOString()
        })
      } catch (e) { /* best-effort */ }
    }
  }
})
JSEOF

echo "💾 Store created"

# ══════════════════════════════════════
# ROUTER
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

echo "🧭 Router created"

# ══════════════════════════════════════
# MAIN.JS + APP.VUE
# ══════════════════════════════════════

cat > src/main.js << 'JSEOF'
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import { useJourneyStore } from './stores/journey'

import './styles/tokens.css'
import './styles/base.css'
import './styles/typography.css'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)

// Hydrate store from localStorage on startup
const journey = useJourneyStore()
journey.hydrate()
journey.recordVisit()

app.mount('#app')
JSEOF

cat > src/App.vue << 'VUEEOF'
<template>
  <router-view v-slot="{ Component }">
    <transition name="page-fade" mode="out-in">
      <component :is="Component" />
    </transition>
  </router-view>
</template>

<style>
.page-fade-enter-active,
.page-fade-leave-active {
  transition: opacity 0.3s ease;
}
.page-fade-enter-from,
.page-fade-leave-to {
  opacity: 0;
}
</style>
VUEEOF

echo "⚙️  Main entry + App shell created"

# ══════════════════════════════════════
# PAGES
# ══════════════════════════════════════

cat > src/pages/NotFound.vue << 'VUEEOF'
<template>
  <div class="not-found">
    <div class="not-found-inner">
      <h1 class="display-medium">This page doesn't exist.</h1>
      <p class="body-text" style="margin-top: 1rem;">But the thought experiment does.</p>
      <router-link to="/" class="home-link">Return home →</router-link>
    </div>
  </div>
</template>

<style scoped>
.not-found {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 2rem;
}
.not-found-inner { max-width: 400px; }
.home-link {
  display: inline-block;
  margin-top: 2rem;
  font-family: var(--serif);
  font-size: 1rem;
  color: var(--ochre);
  border-bottom: 1px solid transparent;
  transition: border-color 0.3s ease;
}
.home-link:hover { border-bottom-color: var(--ochre); }
</style>
VUEEOF

cat > src/pages/AboutPage.vue << 'VUEEOF'
<template>
  <div class="about">
    <div class="about-inner">
      <h1 class="display-medium">About Human Respect</h1>
      <div style="width: 40px; height: 1px; background: var(--ochre); margin: 2rem 0; opacity: 0.4;"></div>
      <p class="body-text-large">The Philosophy of Human Respect was articulated by Chris J. Rufer. It begins with an observation about human nature — that happiness, harmony, and prosperity decrease when people experience the initiation of violence or the theft of their property through force or fraud — and asks what a society built on voluntary cooperation might look like.</p>
      <p class="body-text" style="margin-top: 1.5rem;">This platform explores that question through interactive experiences designed to surface your own moral reasoning, not to tell you what to think.</p>
      <router-link to="/" class="home-link" style="display: inline-block; margin-top: 2rem; font-family: var(--serif); color: var(--ochre);">← Back to home</router-link>
    </div>
  </div>
</template>

<style scoped>
.about {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
}
.about-inner { max-width: 560px; }
</style>
VUEEOF

echo "📄 Pages created"

# ══════════════════════════════════════
# CLOUDFLARE PAGES CONFIG
# ══════════════════════════════════════

cat > public/_redirects << 'EOF'
/* /index.html 200
EOF

cat > public/_headers << 'EOF'
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
EOF

echo "☁️  Cloudflare config created"

# ══════════════════════════════════════
# UPDATE INDEX.HTML
# ══════════════════════════════════════

cat > index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Human Respect</title>
    <meta name="description" content="A five-minute philosophical experiment that reveals something about your own moral reasoning you've probably never noticed.">
    <meta property="og:title" content="You live by a moral code you've never put into words.">
    <meta property="og:description" content="A five-minute philosophical experiment. Discover the principle that governs your life — and the one exception you've never examined.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://humanrespect.app">
    <meta name="twitter:card" content="summary_large_image">
    <link rel="icon" href="/favicon.ico">
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.js"></script>
  </body>
</html>
HTMLEOF

echo "📝 index.html updated"

# ══════════════════════════════════════
# CLEANUP DEFAULT VUE FILES
# ══════════════════════════════════════

rm -rf src/components/icons 2>/dev/null
rm -f src/components/HelloWorld.vue 2>/dev/null
rm -f src/components/TheWelcome.vue 2>/dev/null
rm -f src/components/WelcomeItem.vue 2>/dev/null
rm -f src/views/HomeView.vue 2>/dev/null
rm -f src/views/AboutView.vue 2>/dev/null
rm -rf src/views 2>/dev/null
rm -f src/assets/logo.svg 2>/dev/null
rm -f src/assets/base.css 2>/dev/null
rm -f src/assets/main.css 2>/dev/null

echo "🧹 Default Vue starter files cleaned up"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Files created:"
echo "  src/styles/tokens.css, base.css, typography.css"
echo "  src/composables/useScrollReveal.js, useScreenNav.js"
echo "  src/components/shared/ (7 components)"
echo "  src/stores/journey.js"
echo "  src/router/index.js"
echo "  src/main.js, App.vue"
echo "  src/pages/NotFound.vue, AboutPage.vue"
echo "  public/_redirects, _headers"
echo "  index.html"
echo ""
echo "Next: We need to add LandingPage.vue and Experience01.vue"
echo "Run 'npm run dev' to verify no errors."
