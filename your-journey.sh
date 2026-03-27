#!/bin/bash
# /your-journey hub page + smart navigation
# 1. YourJourney.vue — persistent progress hub
# 2. SiteNav — wordmark links to /your-journey when journey exists
# 3. Opening screens — back button uses router history with smart fallback
# Run from humanrespect-app/ root

set -e

echo "🗺️  Building Your Journey hub..."

# ══════════════════════════════════════
# 1. YOUR JOURNEY PAGE
# ══════════════════════════════════════

cat > src/pages/YourJourney.vue << 'VUEEOF'
<template>
  <div class="page">
    <div class="page-container stagger" ref="el">

      <p class="caption">Your journey</p>
      <h1 class="display-large" style="margin-top: 0.5rem;">
        {{ hasAnyProgress ? greeting : 'Begin here.' }}
      </h1>
      <Divider />

      <!-- NO PROGRESS YET -->
      <div v-if="!hasAnyProgress" class="empty-state">
        <p class="body-text-large">The Philosophy of Human Respect is a series of experiences designed to help you discover, through your own reasoning, how voluntary cooperation relates to human flourishing.</p>
        <p class="body-text">Each experience takes 5-10 minutes. Start with the first one.</p>
        <div style="margin-top: 2rem;">
          <PathCard :to="{ name: 'exp01' }" :recommended="true">
            <template #title>The Question</template>
            <template #desc>A five-minute thought experiment that reveals something about your own moral reasoning.</template>
          </PathCard>
        </div>
      </div>

      <!-- HAS PROGRESS -->
      <template v-else>

        <!-- WHAT YOU'VE DISCOVERED -->
        <div v-if="completedList.length > 0" class="section">
          <h2 class="section-heading">What you've discovered</h2>

          <div class="completed-experiences">
            <div v-for="exp in completedList" :key="exp.name" class="completed-card">
              <div class="completed-header">
                <div class="completed-check">✓</div>
                <div>
                  <div class="completed-title">{{ exp.title }}</div>
                  <div class="completed-detail" v-if="exp.personalNote">{{ exp.personalNote }}</div>
                </div>
              </div>
              <router-link :to="{ name: exp.name }" class="revisit-link">Revisit →</router-link>
            </div>
          </div>
        </div>

        <!-- RECOMMENDED NEXT -->
        <div v-if="recommended" class="section">
          <h2 class="section-heading">Recommended next</h2>
          <PathCard :to="{ name: recommended.name }" :recommended="true">
            <template #title>{{ recommended.title }}</template>
            <template #desc>{{ recommended.desc }}</template>
          </PathCard>
        </div>

        <!-- AVAILABLE EXPERIENCES BY TIER -->
        <div v-if="availableByTier.foundation.length > 0" class="section">
          <h2 class="section-heading">Foundation</h2>
          <p class="section-note">Sequential experiences that build the philosophical framework.</p>
          <div class="experience-list">
            <PathCard
              v-for="exp in availableByTier.foundation"
              :key="exp.name"
              :to="{ name: exp.name }"
            >
              <template #title>{{ exp.title }}</template>
              <template #desc>{{ exp.desc }}</template>
            </PathCard>
          </div>
        </div>

        <div v-if="availableByTier.pillar.length > 0" class="section">
          <h2 class="section-heading">Pillars</h2>
          <p class="section-note">Explore the three domains of human integrity and the case for cooperation.</p>
          <div class="experience-list">
            <PathCard
              v-for="exp in availableByTier.pillar"
              :key="exp.name"
              :to="{ name: exp.name }"
            >
              <template #title>{{ exp.title }}</template>
              <template #desc>{{ exp.desc }}</template>
            </PathCard>
          </div>
        </div>

        <div v-if="availableByTier.practice.length > 0" class="section">
          <h2 class="section-heading">Practices</h2>
          <p class="section-note">Apply the philosophy to your actual life.</p>
          <div class="experience-list">
            <PathCard
              v-for="exp in availableByTier.practice"
              :key="exp.name"
              :to="{ name: exp.name }"
            >
              <template #title>{{ exp.title }}</template>
              <template #desc>{{ exp.desc }}</template>
            </PathCard>
          </div>
        </div>

        <!-- PROGRESS SUMMARY -->
        <div class="progress-bar-section">
          <div class="progress-label">{{ completedCount }} of {{ totalCount }} experiences completed</div>
          <div class="progress-track">
            <div class="progress-fill" :style="{ width: progressPct + '%' }"></div>
          </div>
        </div>

        <!-- NEWSLETTER -->
        <NewsletterSignup
          v-if="completedCount >= 2"
          source="your_journey"
          headline="Stay with it."
          description="A weekly email applying the Philosophy of Human Respect to real situations."
          button-text="Subscribe"
        />

      </template>

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
import PathCard from '@/components/shared/PathCard.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from '@/components/experiences/exp02/objectionData.js'

const journey = useJourneyStore()
const el = ref(null)

onMounted(() => {
  document.body.classList.remove('dark-mode')
  requestAnimationFrame(() => el.value?.classList.add('animate'))
})

const allExperiences = [
  { name: 'exp01', title: 'The Question', desc: 'A thought experiment that reveals the gap between personal and political morality.', tier: 'foundation', order: 1 },
  { name: 'exp02', title: 'The Objection', desc: 'Pick your strongest objection. It gets steelmanned, responded to, and honestly conceded.', tier: 'foundation', order: 2 },
  { name: 'exp03', title: 'What Flourishing Means', desc: 'The empirical grounding for the principle, traced through your own life.', tier: 'foundation', order: 3 },
  { name: 'exp04', title: 'The Realist Objection', desc: 'People are flawed. That is the strongest argument for voluntary cooperation.', tier: 'foundation', order: 4 },
  { name: 'exp05', title: 'Human Agency', desc: 'If you hire someone to steal, you bear responsibility. What about voting?', tier: 'foundation', order: 5 },
  { name: 'pillarA', title: 'Bodily Integrity', desc: 'Why safety is the precondition for all flourishing.', tier: 'pillar', order: 6 },
  { name: 'pillarB', title: 'Temporal Integrity', desc: 'Time as the irreplaceable substance of life.', tier: 'pillar', order: 7 },
  { name: 'pillarC', title: 'Material Integrity', desc: 'Property as crystallized time. The cost of insecurity.', tier: 'pillar', order: 8 },
  { name: 'pillarD', title: 'The Human Respect Method', desc: 'Your values are not the problem. The question is force or persuasion.', tier: 'pillar', order: 9 },
  { name: 'pillarE', title: 'Cooperation as Technology', desc: 'Real evidence that voluntary cooperation works at scale.', tier: 'pillar', order: 10 },
  { name: 'practice01', title: 'Political Footprint', desc: 'Map where force operates in your life vs. where you support it.', tier: 'practice', order: 11 },
  { name: 'practice02', title: 'Persuasion Practice', desc: 'Draft a persuasion-only approach to an issue you care about.', tier: 'practice', order: 12 },
  { name: 'practice03', title: 'The Conversation', desc: 'A framework for discussing this with someone who disagrees.', tier: 'practice', order: 13 },
  { name: 'practice04', title: 'Respect Audit', desc: 'Notice force vs. persuasion in your daily life for 7 days.', tier: 'practice', order: 14 },
  { name: 'practice05', title: 'Design a Solution', desc: 'Pick a real problem. Solve it with zero coercion.', tier: 'practice', order: 15 },
]

const totalCount = allExperiences.length

function isCompleted(name) {
  if (name === 'exp01') return journey.exp01?.completed
  if (name === 'exp02') return journey.exp02?.completed
  if (name === 'exp03') return !!journey.completions?.exp03
  return !!journey.completions?.[name]
}

const hasAnyProgress = computed(() => {
  return journey.exp01?.completed || journey.exp02?.completed ||
    (journey.completions && Object.keys(journey.completions).length > 0) ||
    journey.visitor?.totalExperiences > 0
})

const completedCount = computed(() =>
  allExperiences.filter(e => isCompleted(e.name)).length
)

const progressPct = computed(() =>
  Math.round(100 * completedCount.value / totalCount)
)

const greeting = computed(() => {
  const count = completedCount.value
  if (count >= 14) return 'You have explored the full philosophy.'
  if (count >= 10) return 'You are deep into this.'
  if (count >= 5) return 'You are building something here.'
  if (count >= 2) return 'You have started something.'
  return 'Welcome back.'
})

function getPersonalNote(name) {
  if (name === 'exp01' && journey.mirrorPattern) {
    const patterns = {
      gap: 'You found the gap between personal and political morality.',
      'consistent-voluntary': 'You apply the same standard to personal and political life.',
      'consistent-coercive': 'You believe urgent need can override individual consent.',
      unusual: 'You hold yourself to a different standard than institutions.'
    }
    return patterns[journey.mirrorPattern] || null
  }
  if (name === 'exp02' && journey.exp02?.chosenObjection) {
    const obj = objections[journey.exp02.chosenObjection]
    return obj ? `You chose ${obj.title}` : null
  }
  return null
}

const completedList = computed(() =>
  allExperiences
    .filter(e => isCompleted(e.name))
    .map(e => ({ ...e, personalNote: getPersonalNote(e.name) }))
)

const recommended = computed(() => {
  const incomplete = allExperiences.filter(e => !isCompleted(e.name))
  if (incomplete.length === 0) return null
  // Foundation first, in order
  const nextFoundation = incomplete.find(e => e.tier === 'foundation')
  if (nextFoundation) return nextFoundation
  // Then pillars
  const nextPillar = incomplete.find(e => e.tier === 'pillar')
  if (nextPillar) return nextPillar
  // Then practices
  return incomplete.find(e => e.tier === 'practice') || null
})

const availableByTier = computed(() => {
  const incomplete = allExperiences.filter(e => !isCompleted(e.name))
  return {
    foundation: incomplete.filter(e => e.tier === 'foundation'),
    pillar: incomplete.filter(e => e.tier === 'pillar'),
    practice: incomplete.filter(e => e.tier === 'practice'),
  }
})
</script>

<style scoped>
.page { background: var(--paper); min-height: 100vh; }
.page-container { max-width: 640px; margin: 0 auto; padding: 5rem 1.5rem 4rem; }

.section { margin-top: 3rem; }
.section-heading { font-family: var(--serif); font-size: 1.2rem; font-weight: 500; color: var(--ink); margin-bottom: 0.5rem; }
.section-note { font-size: 0.82rem; color: var(--ink-faint); margin-bottom: 1rem; line-height: 1.5; }

.empty-state { margin-top: 1.5rem; }

/* Completed experiences */
.completed-experiences { display: flex; flex-direction: column; gap: 0.5rem; margin-top: 0.75rem; }
.completed-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.85rem 1.1rem;
  background: var(--cream);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius);
}
.completed-header { display: flex; gap: 0.75rem; align-items: flex-start; flex: 1; }
.completed-check {
  flex-shrink: 0;
  width: 20px; height: 20px;
  border-radius: 50%;
  background: var(--insight-bg);
  color: var(--insight-green);
  font-size: 0.65rem;
  display: flex; align-items: center; justify-content: center;
  margin-top: 2px;
}
.completed-title { font-family: var(--serif); font-size: 0.92rem; font-weight: 500; color: var(--ink); }
.completed-detail { font-size: 0.75rem; color: var(--ink-faint); margin-top: 0.15rem; font-style: italic; }
.revisit-link {
  flex-shrink: 0;
  font-size: 0.75rem;
  color: var(--ochre);
  text-decoration: none;
  font-family: var(--sans);
  transition: opacity 0.2s;
}
.revisit-link:hover { opacity: 0.7; }

/* Experience list */
.experience-list { display: flex; flex-direction: column; gap: 0.5rem; }

/* Progress bar */
.progress-bar-section { margin-top: 3rem; padding-top: 2rem; border-top: 1px solid var(--border-subtle); }
.progress-label { font-size: 0.78rem; color: var(--ink-faint); margin-bottom: 0.5rem; }
.progress-track { height: 6px; background: var(--paper-warm); border-radius: 3px; overflow: hidden; }
.progress-fill { height: 100%; background: var(--ochre); border-radius: 3px; transition: width 0.6s ease; }

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
  .completed-card { flex-direction: column; align-items: flex-start; gap: 0.5rem; }
  .revisit-link { align-self: flex-end; }
}
</style>
VUEEOF

echo "  ✓ YourJourney.vue"

# ══════════════════════════════════════
# 2. ADD ROUTE
# ══════════════════════════════════════

if ! grep -q "your-journey" src/router/index.js 2>/dev/null; then
  sed -i '' "/path: '\/milestone'/a\\
  { path: '/your-journey', name: 'your-journey', component: () => import('@/pages/YourJourney.vue') },
" src/router/index.js
  echo "  ✓ Route added"
else
  echo "  ✓ Route already exists"
fi

# Add route meta
if ! grep -q "your-journey" src/router/meta.js 2>/dev/null; then
  sed -i '' "/milestone:/a\\
  'your-journey': {\\
    title: 'Your Journey — Human Respect',\\
    description: 'Track your progress through the Philosophy of Human Respect.'\\
  },
" src/router/meta.js
  echo "  ✓ Route meta added"
else
  echo "  ✓ Route meta already exists"
fi

# ══════════════════════════════════════
# 3. UPDATE SITENAV — smart wordmark destination
# ══════════════════════════════════════

cat > src/components/shared/SiteNav.vue << 'VUEEOF'
<template>
  <nav
    class="site-nav"
    :class="{
      minimal: isExperience,
      'nav-hidden': shouldHide,
      'nav-visible': !shouldHide
    }"
  >
    <div class="nav-inner">
      <router-link :to="wordmarkDest" class="nav-wordmark">Human Respect</router-link>
      <div v-if="!isExperience" class="nav-links">
        <router-link to="/about" class="nav-link">About</router-link>
        <router-link to="/privacy" class="nav-link">Privacy</router-link>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import { useJourneyStore } from '@/stores/journey'

const route = useRoute()
const journey = useJourneyStore()
const scrolled = ref(false)
const scrollingUp = ref(false)
const lastScrollY = ref(0)
const isMobile = ref(false)

const isExperience = computed(() => {
  const path = route.path
  return path.startsWith('/experience/') ||
         path.startsWith('/pillar/') ||
         path.startsWith('/practice/')
})

const isHome = computed(() => route.path === '/')

const hasProgress = computed(() => {
  return journey.exp01?.completed || journey.exp02?.completed ||
    (journey.completions && Object.keys(journey.completions).length > 0) ||
    journey.visitor?.totalExperiences > 0
})

const wordmarkDest = computed(() => {
  if (hasProgress.value) return '/your-journey'
  return '/'
})

const shouldHide = computed(() => {
  if (isHome.value && !scrolled.value) return true
  if (isExperience.value && isMobile.value) return !scrollingUp.value
  return false
})

function handleScroll() {
  const currentY = window.scrollY
  scrolled.value = currentY > 200
  scrollingUp.value = currentY < lastScrollY.value && currentY > 60
  lastScrollY.value = currentY
}

function checkMobile() {
  isMobile.value = window.innerWidth <= 680
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  window.addEventListener('resize', checkMobile, { passive: true })
  checkMobile()
  handleScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  window.removeEventListener('resize', checkMobile)
})
</script>

<style scoped>
.site-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  padding: 0.75rem 1.5rem;
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.nav-inner { max-width: 960px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; }
.nav-wordmark { font-family: var(--serif); font-size: 0.9rem; font-weight: 500; color: var(--ink-muted); text-decoration: none; letter-spacing: 0.02em; transition: color 0.2s ease; }
.nav-wordmark:hover { color: var(--ink); }
.nav-links { display: flex; gap: 1.5rem; }
.nav-link { font-family: var(--sans); font-size: 0.72rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--ink-faint); text-decoration: none; transition: color 0.2s ease; }
.nav-link:hover { color: var(--ink-muted); }

.nav-hidden { opacity: 0; transform: translateY(-100%); pointer-events: none; }
.nav-visible { opacity: 1; transform: translateY(0); pointer-events: auto; }

.site-nav.minimal { opacity: 0.3; }
.site-nav.minimal:hover { opacity: 0.8; }

@media (max-width: 680px) {
  .site-nav.minimal { opacity: 1; background: rgba(244, 240, 234, 0.92); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); padding: 0.6rem 1rem; }
  .site-nav.minimal .nav-wordmark { font-size: 0.8rem; color: var(--ink-muted); }
}

:global(body.dark-mode) .nav-wordmark { color: rgba(240, 235, 227, 0.3); }
:global(body.dark-mode) .nav-wordmark:hover { color: rgba(240, 235, 227, 0.65); }
:global(body.dark-mode) .nav-link { color: rgba(240, 235, 227, 0.2); }
:global(body.dark-mode) .nav-link:hover { color: rgba(240, 235, 227, 0.5); }
@media (max-width: 680px) {
  :global(body.dark-mode) .site-nav.minimal { background: rgba(26, 26, 46, 0.92); }
}
@media (max-width: 480px) {
  .site-nav { padding: 0.6rem 1rem; }
  .nav-wordmark { font-size: 0.82rem; }
  .nav-links { gap: 1rem; }
}
</style>
VUEEOF

echo "  ✓ SiteNav updated — wordmark goes to /your-journey when progress exists"

# ══════════════════════════════════════
# 4. SMART BACK BUTTON ON OPENING SCREENS
# Create a composable that handles back navigation
# ══════════════════════════════════════

cat > src/composables/useSmartBack.js << 'JSEOF'
import { useRouter } from 'vue-router'
import { useJourneyStore } from '@/stores/journey'

export function useSmartBack() {
  const router = useRouter()
  const journey = useJourneyStore()

  function goBack() {
    // If there's browser history, use it
    if (window.history.length > 1) {
      router.back()
    } else {
      // No history — smart fallback
      const hasProgress = journey.exp01?.completed || journey.exp02?.completed ||
        (journey.completions && Object.keys(journey.completions).length > 0)

      if (hasProgress) {
        router.push('/your-journey')
      } else {
        router.push('/')
      }
    }
  }

  return { goBack }
}
JSEOF

echo "  ✓ useSmartBack composable"

# ══════════════════════════════════════
# 5. UPDATE NAVBAR — add smartBack mode for opening screens
# ══════════════════════════════════════

# Check current NavBar
NAVBAR_FILE="src/components/shared/NavBar.vue"
if [ -f "$NAVBAR_FILE" ]; then
  # Check if it already has smartBack
  if ! grep -q "smartBack" "$NAVBAR_FILE" 2>/dev/null; then
    cat > "$NAVBAR_FILE" << 'VUEEOF'
<template>
  <div class="nav-bar">
    <button class="nav-back" :disabled="!canGoBack" @click="handleBack">
      ← Back
    </button>
    <button class="nav-continue" :disabled="disableContinue" @click="$emit('continue')">
      <span>Continue</span>
      <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
import { useSmartBack } from '@/composables/useSmartBack'

const props = defineProps({
  canGoBack: { type: Boolean, default: true },
  disableContinue: { type: Boolean, default: false },
  smartBack: { type: Boolean, default: false }
})

const emit = defineEmits(['back', 'continue'])
const { goBack: smartGoBack } = useSmartBack()

function handleBack() {
  if (props.smartBack) {
    smartGoBack()
  } else {
    emit('back')
  }
}
</script>

<style scoped>
.nav-bar {
  margin-top: 3rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 1.5rem;
  border-top: 1px solid var(--border-subtle);
}
.nav-back {
  font-family: var(--sans);
  font-size: 0.82rem;
  color: var(--ink-faint);
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.5rem 0;
  transition: color 0.2s;
}
.nav-back:hover { color: var(--ink-muted); }
.nav-back:disabled { opacity: 0; cursor: default; }
.nav-continue {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-family: var(--serif);
  font-size: 0.95rem;
  font-weight: 500;
  color: white;
  background: var(--ochre);
  border: none;
  border-radius: 100px;
  padding: 0.65rem 1.5rem;
  cursor: pointer;
  transition: all 0.25s ease;
  -webkit-tap-highlight-color: transparent;
}
.nav-continue:hover { transform: translateX(2px); }
.nav-continue:disabled { opacity: 0.35; cursor: not-allowed; transform: none; }
.nav-continue .arrow { transition: transform 0.2s ease; }
.nav-continue:hover:not(:disabled) .arrow { transform: translateX(3px); }
</style>
VUEEOF
    echo "  ✓ NavBar updated with smartBack prop"
  else
    echo "  ✓ NavBar already has smartBack"
  fi
fi

echo ""
echo "✅ Your Journey hub + smart navigation complete!"
echo ""
echo "Changes:"
echo "  1. /your-journey page — persistent progress hub"
echo "     Shows completed experiences with personalized notes"
echo "     Recommends next experience based on progress"
echo "     Lists all available experiences by tier"
echo "     Progress bar showing X of 15 completed"
echo "     Newsletter signup after 2+ completions"
echo ""
echo "  2. SiteNav wordmark — smart destination"
echo "     First-time visitors (no progress): links to /"
echo "     Returning visitors (any progress): links to /your-journey"
echo ""
echo "  3. useSmartBack composable"
echo "     Browser history exists: router.back()"
echo "     No history + has progress: /your-journey"
echo "     No history + no progress: /"
echo ""
echo "  4. NavBar smartBack prop"
echo "     Pass :smart-back='true' on opening screens"
echo "     to enable smart back navigation instead of emit('back')"
echo ""
echo "NOTE: To activate smart back on opening screens,"
echo "add :smart-back='true' to the NavBar on each experience's"
echo "first content screen (screen index 1, after the dark opening)."
echo "This is optional — the composable is available for future use."
echo ""
echo "TEST BUILD:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'ux: your-journey hub + smart navigation' && git push"
