#!/bin/bash
# Updates the journey store to track all 14 experience completions
# Run AFTER the SQL migration above
# Run from humanrespect-app/ root

set -e

cat > src/stores/journey.js << 'JSEOF'
import { defineStore } from 'pinia'
import { supabase } from '@/lib/supabase'

const USE_SUPABASE = true

const ALL_EXPERIENCES = [
  'exp01', 'exp02', 'exp03',
  'pillarA', 'pillarB', 'pillarC', 'pillarD', 'pillarE',
  'practice01', 'practice02', 'practice03', 'practice04', 'practice05'
]

function getTier(expId) {
  if (expId.startsWith('exp')) return 'foundation'
  if (expId.startsWith('pillar')) return 'pillar'
  if (expId.startsWith('practice')) return 'practice'
  return 'none'
}

const TIER_ORDER = { none: 0, foundation: 1, pillar: 2, practice: 3 }

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
    mirrorPattern: (state) => {
      const { personal, political } = state.exp01
      if (!personal || !political) return null
      if (personal === 'no' && political === 'yes') return 'gap'
      if (personal === 'no' && political === 'no') return 'consistent-voluntary'
      if (personal === 'yes' && political === 'yes') return 'consistent-coercive'
      return 'unusual'
    },
    foundationComplete: (state) => state.exp01.completed && state.exp02.completed && state.completions.exp03,
    completionCount: (state) => Object.values(state.completions).filter(Boolean).length,
    isCompleted: (state) => (expId) => !!state.completions[expId]
  },

  actions: {
    // ── Experience-specific completions ──
    completeExp01(personal, political) {
      this.exp01.personal = personal
      this.exp01.political = political
      this.exp01.completed = true
      this.exp01.completedAt = new Date().toISOString()
      this.markComplete('exp01')
    },

    completeExp02(objection, reflection) {
      this.exp02.chosenObjection = objection
      this.exp02.reflection = reflection
      this.exp02.completed = true
      this.exp02.completedAt = new Date().toISOString()
      this.markComplete('exp02')
    },

    // ── Universal completion tracker ──
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

    // ── Visit recording ──
    recordVisit() {
      const now = new Date().toISOString()
      if (!this.visitor.firstVisit) this.visitor.firstVisit = now
      this.visitor.lastVisit = now
      if (!this.visitorId) this.visitorId = crypto.randomUUID()
      this.persist()
    },

    // ── localStorage ──
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
          // Ensure completions objects exist even from old localStorage
          if (!parsed.completions) parsed.completions = {}
          if (!parsed.completionTimes) parsed.completionTimes = {}
          if (!parsed.furthestTier) parsed.furthestTier = 'none'
          this.$patch(parsed)
        }
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

echo "✅ Journey store updated with full completion tracking."
echo ""
echo "New capabilities:"
echo "  • completions{} — tracks which of all 14 experiences are done"
echo "  • completionTimes{} — when each was completed"
echo "  • lastExperience — most recently completed experience"
echo "  • furthestTier — deepest engagement level (none/foundation/pillar/practice)"
echo "  • markComplete(expId) — universal method any experience can call"
echo ""
echo "Push with: git add . && git commit -m 'store: full journey tracking across all experiences' && git push"
