import { defineStore } from 'pinia'
import { getSupabase } from '@/lib/supabase'

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
      if (import.meta.server) return
      try {
        localStorage.setItem('hr-journey', JSON.stringify(this.$state))
      } catch (e) { /* silent */ }
      this.syncToSupabase()
    },

    hydrate() {
      if (import.meta.server) return
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
      const supabase = getSupabase()
      if (!supabase) return
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
      if (import.meta.server || !this.visitorId) return
      const supabase = getSupabase()
      if (!supabase) return
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
