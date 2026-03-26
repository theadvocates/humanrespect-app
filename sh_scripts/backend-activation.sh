#!/bin/bash
# Activates backend: Supabase persistence, analytics, newsletter
# Run from humanrespect-app/ root

set -e

echo "🔌 Activating backend..."

# ══════════════════════════════════════
# 1. FLIP THE SUPABASE SWITCH
# ══════════════════════════════════════

cat > src/stores/journey.js << 'JSEOF'
import { defineStore } from 'pinia'
import { supabase } from '@/lib/supabase'

const USE_SUPABASE = true

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
      this.trackEvent('exp01_completed', {
        personal, political, pattern: this.mirrorPattern
      })
    },

    completeExp02(objection, reflection) {
      this.exp02.chosenObjection = objection
      this.exp02.reflection = reflection
      this.exp02.completed = true
      this.exp02.completedAt = new Date().toISOString()
      this.visitor.totalExperiences++
      this.persist()
      this.trackEvent('exp02_completed', { objection })
    },

    recordVisit() {
      const now = new Date().toISOString()
      if (!this.visitor.firstVisit) this.visitor.firstVisit = now
      this.visitor.lastVisit = now
      if (!this.visitorId) this.visitorId = crypto.randomUUID()
      this.persist()
    },

    // ── localStorage (always active) ──
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

    // ── Supabase sync ──
    async syncToSupabase() {
      if (!this.visitorId) return
      try {
        await supabase.from('journeys').upsert({
          visitor_id: this.visitorId,
          exp01_personal: this.exp01.personal,
          exp01_political: this.exp01.political,
          exp01_completed: this.exp01.completed,
          exp01_completed_at: this.exp01.completedAt,
          mirror_pattern: this.mirrorPattern,
          exp02_objection: this.exp02.chosenObjection,
          exp02_completed: this.exp02.completed,
          exp02_completed_at: this.exp02.completedAt,
          total_experiences: this.visitor.totalExperiences,
          first_visit: this.visitor.firstVisit,
          last_visit: this.visitor.lastVisit,
          updated_at: new Date().toISOString()
        }, { onConflict: 'visitor_id' })
      } catch (e) {
        console.warn('Supabase sync failed:', e)
      }
    },

    // ── Analytics events ──
    async trackEvent(eventName, properties = {}) {
      if (!USE_SUPABASE) return
      if (!this.visitorId) return
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

echo "  ✓ Supabase switch flipped to TRUE"

# ══════════════════════════════════════
# 2. ANALYTICS COMPOSABLE (enhanced)
# ══════════════════════════════════════

cat > src/composables/useAnalytics.js << 'JSEOF'
import { useJourneyStore } from '@/stores/journey'

export function useAnalytics() {
  const journey = useJourneyStore()

  function trackScreenView(experienceId, screenId) {
    journey.trackEvent('screen_view', {
      experience: experienceId,
      screen: screenId,
      timestamp: new Date().toISOString()
    })
  }

  function trackChoice(experienceId, questionId, answer) {
    journey.trackEvent('choice_made', {
      experience: experienceId,
      question: questionId,
      answer,
      timestamp: new Date().toISOString()
    })
  }

  function trackCompletion(experienceId, data = {}) {
    journey.trackEvent('experience_completed', {
      experience: experienceId,
      ...data,
      timestamp: new Date().toISOString()
    })
  }

  function trackShare(method, experienceId) {
    journey.trackEvent('share', {
      method,
      experience: experienceId,
      timestamp: new Date().toISOString()
    })
  }

  function trackNewsletterSignup(source) {
    journey.trackEvent('newsletter_signup', {
      source,
      timestamp: new Date().toISOString()
    })
  }

  return {
    trackScreenView,
    trackChoice,
    trackCompletion,
    trackShare,
    trackNewsletterSignup
  }
}
JSEOF

echo "  ✓ Analytics composable enhanced"

# ══════════════════════════════════════
# 3. NEWSLETTER COMPONENT
# ══════════════════════════════════════

cat > src/components/shared/NewsletterSignup.vue << 'VUEEOF'
<template>
  <div class="newsletter-block">
    <div v-if="!submitted" class="newsletter-form">
      <p class="newsletter-label">{{ label }}</p>
      <p class="newsletter-desc">{{ description }}</p>
      <div class="input-row">
        <input
          type="email"
          class="email-input"
          v-model="email"
          placeholder="Your email address"
          @keydown.enter="submit"
        />
        <button
          class="submit-btn"
          :disabled="!isValid || submitting"
          @click="submit"
        >
          {{ submitting ? '...' : 'Subscribe' }}
        </button>
      </div>
      <p v-if="error" class="error-msg">{{ error }}</p>
      <p class="privacy-note">No spam. No selling data. One email per week. Unsubscribe anytime.</p>
    </div>
    <div v-else class="newsletter-success">
      <p class="success-msg">You're in. Watch for your first email.</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import { useAnalytics } from '@/composables/useAnalytics'
import { useJourneyStore } from '@/stores/journey'

const props = defineProps({
  label: { type: String, default: 'Get one idea per week' },
  description: { type: String, default: 'A weekly email exploring how the principle of Human Respect applies to the issues you care about.' },
  source: { type: String, default: 'unknown' }
})

const { trackNewsletterSignup } = useAnalytics()
const journey = useJourneyStore()

const email = ref('')
const submitting = ref(false)
const submitted = ref(false)
const error = ref('')

const isValid = computed(() => {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)
})

async function submit() {
  if (!isValid.value || submitting.value) return

  submitting.value = true
  error.value = ''

  try {
    const { error: dbError } = await supabase
      .from('newsletter_subscribers')
      .insert({
        email: email.value.toLowerCase().trim(),
        source: props.source,
        visitor_id: journey.visitorId,
        subscribed_at: new Date().toISOString()
      })

    if (dbError) {
      if (dbError.code === '23505') {
        // Duplicate email — treat as success
        submitted.value = true
      } else {
        error.value = 'Something went wrong. Please try again.'
        console.warn('Newsletter signup error:', dbError)
      }
    } else {
      submitted.value = true
      trackNewsletterSignup(props.source)
    }
  } catch (e) {
    error.value = 'Something went wrong. Please try again.'
    console.warn('Newsletter signup error:', e)
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped>
.newsletter-block {
  margin: 2rem 0;
  padding: 2rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
}

.newsletter-label {
  font-family: var(--serif);
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.35rem;
}

.newsletter-desc {
  font-size: 0.85rem;
  color: var(--ink-muted);
  line-height: 1.6;
  margin-bottom: 1.25rem;
}

.input-row {
  display: flex;
  gap: 0.5rem;
}

.email-input {
  flex: 1;
  padding: 0.75rem 1rem;
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  font-family: var(--sans);
  font-size: 0.9rem;
  color: var(--ink);
  background: white;
  outline: none;
  transition: border-color 0.2s;
}

.email-input:focus {
  border-color: var(--ochre);
}

.email-input::placeholder {
  color: var(--ink-faint);
}

.submit-btn {
  padding: 0.75rem 1.5rem;
  background: var(--ochre);
  color: white;
  border: none;
  border-radius: var(--radius);
  font-family: var(--sans);
  font-size: 0.9rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s ease;
  white-space: nowrap;
  -webkit-tap-highlight-color: transparent;
}

.submit-btn:hover:not(:disabled) {
  background: var(--ochre-light);
}

.submit-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.privacy-note {
  font-size: 0.72rem;
  color: var(--ink-faint);
  margin-top: 0.75rem;
  font-style: italic;
}

.error-msg {
  font-size: 0.8rem;
  color: var(--concede-warm);
  margin-top: 0.5rem;
}

.newsletter-success {
  text-align: center;
  padding: 1rem 0;
}

.success-msg {
  font-family: var(--serif);
  font-size: 1.05rem;
  color: var(--insight-green);
  font-style: italic;
}

@media (max-width: 480px) {
  .newsletter-block { padding: 1.5rem; }
  .input-row { flex-direction: column; }
  .submit-btn { width: 100%; }
}
</style>
VUEEOF

echo "  ✓ NewsletterSignup component created"

# ══════════════════════════════════════
# 4. ADD NEWSLETTER TO KEY CLOSING SCREENS
# ══════════════════════════════════════

# Update Experience 01 Invitation to include newsletter
cat > src/components/experiences/exp01/Invitation.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="8" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">The question you take with you.</h2>
    <Divider />
    <p class="body-text-large">You already live by the principle of Human Respect in most of your life. You don't steal from neighbors. You don't threaten coworkers. You solve problems through conversation, persuasion, and voluntary agreement.</p>
    <p class="body-text-large">The question is whether you'll extend that same principle to how you think about politics and society.</p>
    <p class="closing-question">What if every social problem you care about could be addressed through cooperation instead of force — and what if the solutions would actually work better?</p>
    <ContentBlock variant="insight">
      <p>This isn't a question that gets answered in five minutes. It's a question that changes how you see every political argument, every policy debate, every election — for the rest of your life.</p>
    </ContentBlock>
    <p class="body-text" style="text-align: center; margin-top: 2rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>

    <div class="continue-paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue exploring</p>
      <PathCard :to="{ name: 'exp02' }">
        <template #title>You probably have a "but..."</template>
        <template #desc>Pick your strongest objection. We'll take it seriously, respond honestly, and tell you what the philosophy can't claim.</template>
      </PathCard>
      <PathCard :to="{ name: 'exp03' }">
        <template #title>What flourishing actually means</template>
        <template #desc>The empirical grounding — why the principle is true, discovered from your own life experience.</template>
      </PathCard>
      <PathCard href="#" @click.prevent="share">
        <template #title>Share this experience</template>
        <template #desc>{{ shareDesc }}</template>
      </PathCard>
    </div>

    <NewsletterSignup source="exp01_invitation" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import { useJourneyStore } from '@/stores/journey'
import { useAnalytics } from '@/composables/useAnalytics'

const journey = useJourneyStore()
const { trackShare, trackCompletion } = useAnalytics()
const el = ref(null)
const shareDesc = ref('Send this thought experiment to someone you disagree with politically. See what they discover.')

onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  journey.completeExp01(journey.exp01.personal, journey.exp01.political)
  trackCompletion('exp01', { pattern: journey.mirrorPattern })
})

function share() {
  const text = "I just went through a 5-minute thought experiment that showed me something I'd never noticed about my own political beliefs."
  const url = window.location.origin + '/experience/the-question'

  if (navigator.share) {
    navigator.share({ title: 'The Question That Changes Everything', text, url })
    trackShare('native', 'exp01')
  } else {
    navigator.clipboard.writeText(text + ' ' + url).then(() => {
      shareDesc.value = 'Link copied to clipboard.'
      trackShare('clipboard', 'exp01')
      setTimeout(() => {
        shareDesc.value = 'Send this thought experiment to someone you disagree with politically. See what they discover.'
      }, 2000)
    })
  }
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.closing-question {
  font-family: var(--serif);
  font-size: clamp(1.3rem, 3vw, 1.6rem);
  line-height: 1.5;
  color: var(--ink);
  text-align: center;
  margin: 2rem 0;
  font-style: italic;
}
</style>
VUEEOF

echo "  ✓ Exp01 Invitation updated with newsletter + analytics"

# ══════════════════════════════════════
# 5. CLOUDFLARE WEB ANALYTICS
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
    <!-- Cloudflare Web Analytics -->
    <!-- Replace BEACON_TOKEN with your actual token from Cloudflare Dashboard > Analytics > Web Analytics -->
    <script defer src='https://static.cloudflareinsights.com/beacon.min.js' data-cf-beacon='{"token": "BEACON_TOKEN"}'></script>
  </body>
</html>
HTMLEOF

echo "  ✓ index.html updated with Cloudflare Web Analytics placeholder"

# ══════════════════════════════════════
# 6. ADD ANALYTICS TO KEY SCREEN COMPONENTS
# ══════════════════════════════════════

# Update Experience01.vue to track screen views
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

const TOTAL_SCREENS = 9
const screenNames = ['opening', 'common-ground', 'scenario', 'personal-choice', 'political-choice', 'mirror', 'why-the-gap', 'the-principle', 'invitation']

const { currentScreen, advance: rawAdvance, goBack } = useScreenNav(TOTAL_SCREENS)
const journey = useJourneyStore()
const { trackScreenView, trackChoice } = useAnalytics()

const screenComponents = [
  Opening, CommonGround, Scenario, PersonalChoice, PoliticalChoice,
  Mirror, WhyTheGap, ThePrinciple, Invitation
]

const currentComponent = computed(() => screenComponents[currentScreen.value])
const isDark = computed(() => currentScreen.value === 0)

// Track screen views
watch(currentScreen, (idx) => {
  trackScreenView('exp01', screenNames[idx])
})

watch(isDark, (dark) => {
  if (dark) document.body.classList.add('dark-mode')
  else document.body.classList.remove('dark-mode')
}, { immediate: true })

onUnmounted(() => document.body.classList.remove('dark-mode'))

function advance() {
  rawAdvance()
}

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

echo "  ✓ Experience01.vue updated with analytics tracking"

echo ""
echo "✅ Backend activated!"
echo ""
echo "What's now live:"
echo "  ✓ Supabase persistence (USE_SUPABASE = true)"
echo "  ✓ Journey data syncs to 'journeys' table"
echo "  ✓ Analytics events write to 'events' table"
echo "  ✓ Newsletter signups write to 'newsletter_subscribers' table"
echo "  ✓ Newsletter component added to Experience 01 closing"
echo "  ✓ Screen views and choices tracked in Experience 01"
echo "  ✓ Cloudflare Web Analytics placeholder in index.html"
echo ""
echo "═══════════════════════════════════════"
echo "  REMAINING MANUAL STEPS:"
echo "═══════════════════════════════════════"
echo ""
echo "1. CLOUDFLARE WEB ANALYTICS TOKEN:"
echo "   Go to Cloudflare Dashboard → Analytics & Logs → Web Analytics"
echo "   Click 'Add a site' → enter humanrespect.app"
echo "   Copy the beacon token"
echo "   Edit index.html and replace BEACON_TOKEN with your actual token"
echo ""
echo "2. CLOUDFLARE PAGES ENV VARS (if not already set):"
echo "   Go to Workers & Pages → humanrespect-app → Settings → Environment Variables"
echo "   Add:"
echo "     VITE_SUPABASE_URL = https://jnspwumpiqbfqlveduzz.supabase.co"
echo "     VITE_SUPABASE_ANON_KEY = (your anon key)"
echo ""
echo "3. PUSH AND DEPLOY:"
echo "   git add . && git commit -m 'backend: supabase + analytics + newsletter' && git push"
echo ""
echo "4. VERIFY DATA FLOW:"
echo "   Visit humanrespect.app, go through Experience 01"
echo "   Check Supabase Table Editor → 'journeys' table (should see a row)"
echo "   Check 'events' table (should see screen_view and choice_made events)"
echo ""
