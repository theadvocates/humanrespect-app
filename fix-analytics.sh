#!/bin/bash
# Update journey store + analytics for new Exp01, Exp02, and 4-tier structure
# Run from humanrespect-app/ root
# PREREQUISITE: Run the SQL migration in Supabase first!

set -e

echo "🔧 Updating journey store + analytics..."

cat > src/stores/journey.js << 'JSEOF'
import { defineStore } from 'pinia'
import { supabase } from '@/lib/supabase'

const USE_SUPABASE = true

const TIER_ORDER = { none: 0, foundation: 1, argument: 2, pillar: 3, practice: 4 }

function getTier(expId) {
  if (['exp01', 'exp02', 'exp03'].includes(expId)) return 'foundation'
  if (['exp04', 'exp05'].includes(expId)) return 'argument'
  if (expId.startsWith('pillar')) return 'pillar'
  if (expId.startsWith('practice')) return 'practice'
  return 'none'
}

export const useJourneyStore = defineStore('journey', {
  state: () => ({
    visitorId: null,
    exp01: {
      completed: false,
      methods: [],
      wouldForce: null,
      whyNot: [],
      completedAt: null
    },
    exp02: {
      completed: false,
      chosenObjection: null,
      exploredObjections: [],
      verdict: null,
      concessionCredibility: null,
      completedAt: null
    },
    completions: {},
    completionTimes: {},
    lastExperience: null,
    furthestTier: 'none',
    visitor: {
      firstVisit: null,
      totalExperiences: 0,
      lastVisit: null
    }
  }),

  getters: {
    foundationComplete: (state) => state.exp01.completed && state.exp02.completed && !!state.completions.exp03,
    completionCount: (state) => Object.values(state.completions).filter(Boolean).length,
    isCompleted: (state) => (expId) => {
      if (expId === 'exp01') return !!state.exp01.completed
      if (expId === 'exp02') return !!state.exp02.completed
      return !!state.completions[expId]
    },
    hasExploredObjection: (state) => (key) => state.exp02.exploredObjections.includes(key)
  },

  actions: {
    completeExp01(data = {}) {
      this.exp01.methods = data.methods || []
      this.exp01.wouldForce = data.would_force || null
      this.exp01.whyNot = data.why_not || []
      this.exp01.completed = true
      this.exp01.completedAt = new Date().toISOString()
      this.markComplete('exp01')
    },

    completeExp02(objection, verdict = null) {
      this.exp02.chosenObjection = objection
      this.exp02.completed = true
      this.exp02.completedAt = new Date().toISOString()
      if (objection && !this.exp02.exploredObjections.includes(objection)) {
        this.exp02.exploredObjections.push(objection)
      }
      if (verdict) this.exp02.verdict = verdict
      this.markComplete('exp02')
    },

    markComplete(expId) {
      if (!this.completions[expId]) {
        this.completions[expId] = true
        this.completionTimes[expId] = new Date().toISOString()
        this.visitor.totalExperiences = Object.values(this.completions).filter(Boolean).length
      }
      this.lastExperience = expId
      const tier = getTier(expId)
      if (TIER_ORDER[tier] > TIER_ORDER[this.furthestTier]) {
        this.furthestTier = tier
      }
      this.persist()
      this.trackEvent('experience_completed', {
        experience: expId,
        tier,
        total_completed: this.visitor.totalExperiences
      })
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
        if (saved) {
          const parsed = JSON.parse(saved)
          if (!parsed.completions) parsed.completions = {}
          if (!parsed.completionTimes) parsed.completionTimes = {}
          if (!parsed.furthestTier) parsed.furthestTier = 'none'
          if (!parsed.exp01) parsed.exp01 = { completed: false, methods: [], wouldForce: null, whyNot: [], completedAt: null }
          if (!parsed.exp02) parsed.exp02 = { completed: false, chosenObjection: null, exploredObjections: [], verdict: null, concessionCredibility: null, completedAt: null }
          if (!parsed.exp02.exploredObjections) {
            parsed.exp02.exploredObjections = parsed.exp02.chosenObjection ? [parsed.exp02.chosenObjection] : []
          }
          // Migrate old exp01 format (personal/political) to new format
          if (parsed.exp01.personal !== undefined && parsed.exp01.methods === undefined) {
            parsed.exp01 = { completed: parsed.exp01.completed || false, methods: [], wouldForce: null, whyNot: [], completedAt: parsed.exp01.completedAt || null }
          }
          this.$patch(parsed)
        }
      } catch (e) { /* fresh start */ }
    },

    async syncToSupabase() {
      if (!this.visitorId) return
      try {
        await supabase.from('journeys').upsert({
          visitor_id: this.visitorId,
          exp01_completed: this.exp01.completed,
          exp01_completed_at: this.exp01.completedAt,
          exp01_methods: this.exp01.methods,
          exp01_would_force: this.exp01.wouldForce,
          exp01_why_not: this.exp01.whyNot,
          exp02_objection: this.exp02.chosenObjection,
          exp02_completed: this.exp02.completed,
          exp02_completed_at: this.exp02.completedAt,
          exp02_verdict: this.exp02.verdict,
          exp02_concession_credibility: this.exp02.concessionCredibility,
          exp03_completed: !!this.completions.exp03,
          exp03_completed_at: this.completionTimes.exp03 || null,
          completions: this.completions,
          last_experience: this.lastExperience,
          furthest_tier: this.furthestTier,
          total_experiences: this.visitor.totalExperiences,
          first_visit: this.visitor.firstVisit,
          last_visit: this.visitor.lastVisit,
          updated_at: new Date().toISOString()
        }, { onConflict: 'visitor_id' })
      } catch (e) {
        console.warn('Supabase sync failed:', e)
      }
    },

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

echo "  ✓ journey.js updated"

# ══════════════════════════════════════
# UPDATE ANALYTICS COMPOSABLE
# Fix trackCompletion to handle new exp01/exp02
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
    if (experienceId === 'exp01') {
      journey.completeExp01(data)
    } else if (experienceId === 'exp02') {
      journey.completeExp02(data.objection, data.verdict)
    } else {
      journey.markComplete(experienceId)
    }
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

echo "  ✓ useAnalytics.js updated"

# ══════════════════════════════════════
# FIX YOUR JOURNEY PAGE — remove mirrorPattern reference
# ══════════════════════════════════════

# The YourJourney page references journey.mirrorPattern for personal notes
# This getter no longer exists. Replace with new exp01 data.
sed -i '' "s/if (name === 'exp01' && journey.mirrorPattern)/if (name === 'exp01' \&\& journey.exp01?.completed)/" src/pages/YourJourney.vue 2>/dev/null
sed -i '' "s/const patterns = {/\/\/ New exp01 doesn't have mirror pattern/" src/pages/YourJourney.vue 2>/dev/null

# Actually, let's just rewrite the getPersonalNote function cleanly
# This is in both YourJourney.vue - we need to handle it carefully

echo "  ⚠ Check YourJourney.vue getPersonalNote function manually"
echo "    Replace mirrorPattern references with:"
echo "    if (name === 'exp01' && journey.exp01?.wouldForce) {"
echo "      return journey.exp01.wouldForce === 'no'"
echo "        ? 'You chose persuasion over force — and articulated why.'"
echo "        : 'You explored what happens when force feels justified.'"
echo "    }"

echo ""
echo "✅ Journey store + analytics updated!"
echo ""
echo "Changes:"
echo "  journey.js:"
echo "    - exp01 state: methods[], wouldForce, whyNot (replaces personal/political)"
echo "    - exp02 state: added verdict, concessionCredibility"
echo "    - getTier: now includes 'argument' tier for exp04/exp05"
echo "    - syncToSupabase: writes new columns, drops old ones"
echo "    - hydrate: migrates old localStorage format to new"
echo "    - Removed mirrorPattern getter"
echo ""
echo "  useAnalytics.js:"
echo "    - trackCompletion: routes exp01→completeExp01, exp02→completeExp02"
echo ""
echo "PREREQUISITES (run in Supabase SQL Editor first!):"
echo "  ALTER TABLE journeys DROP COLUMN IF EXISTS exp01_personal;"
echo "  ALTER TABLE journeys DROP COLUMN IF EXISTS exp01_political;"
echo "  ALTER TABLE journeys DROP COLUMN IF EXISTS mirror_pattern;"
echo "  ALTER TABLE journeys ADD COLUMN IF NOT EXISTS exp01_methods text[];"
echo "  ALTER TABLE journeys ADD COLUMN IF NOT EXISTS exp01_would_force text;"
echo "  ALTER TABLE journeys ADD COLUMN IF NOT EXISTS exp01_why_not text[];"
echo "  ALTER TABLE journeys ADD COLUMN IF NOT EXISTS exp02_verdict text;"
echo "  ALTER TABLE journeys ADD COLUMN IF NOT EXISTS exp02_concession_credibility text;"
echo "  TRUNCATE TABLE events;"
echo "  TRUNCATE TABLE journeys;"
echo "  TRUNCATE TABLE newsletter_subscribers;"
echo ""
echo "ALSO: Clear localStorage in your browser (DevTools → Application → Local Storage)"
echo ""
echo "TEST BUILD:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'fix: journey store + analytics for new exp01/exp02' && git push"
