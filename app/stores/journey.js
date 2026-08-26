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

    /**
     * Writes progress through the sync_journey function rather than upserting
     * the table directly. A direct .upsert() emits INSERT ... ON CONFLICT DO
     * UPDATE, which PostgreSQL will only run if a SELECT policy makes the
     * conflicting row visible — and any such policy would expose every
     * visitor's answers to anyone holding the anon key. The function does the
     * upsert internally with RLS bypassed, so anon needs no read access at all.
     */
    async syncToSupabase() {
      if (!this.visitorId) return
      const supabase = await getSupabase()
      if (!supabase) return
      try {
        const { error } = await supabase.rpc('sync_journey', {
          p_visitor_id: this.visitorId,
          p_completions: this.completions,
          p_completion_times: this.completionTimes,
          p_last_experience: this.lastExperience,
          p_furthest_tier: this.furthestTier,
          p_total_experiences: this.visitor.totalExperiences,
          p_first_visit: this.visitor.firstVisit,
          p_last_visit: this.visitor.lastVisit
        })
        if (error) console.warn('Journey sync failed:', error.message)
      } catch (e) {
        console.warn('Journey sync failed:', e)
      }
    },

    applyRemote(row) {
      if (!row) return

      this.completions = { ...this.completions, ...(row.completions || {}) }
      this.completionTimes = { ...this.completionTimes, ...(row.completion_times || {}) }
      this.exp01.completed = this.exp01.completed || !!this.completions.exp01
      this.exp02.completed = this.exp02.completed || !!this.completions.exp02

      if (row.visitor_id) this.visitorId = row.visitor_id
      if (row.last_experience) this.lastExperience = row.last_experience
      if (row.furthest_tier) {
        const remote = row.furthest_tier
        if (TIER_ORDER[remote] > TIER_ORDER[this.furthestTier]) this.furthestTier = remote
      }
      if (row.first_visit) this.visitor.firstVisit = row.first_visit
      this.visitor.totalExperiences = Object.values(this.completions).filter(Boolean).length

      try {
        localStorage.setItem('hr-journey', JSON.stringify(this.$state))
      } catch (e) { /* silent */ }
    },

    async trackEvent(eventName, properties = {}) {
      if (import.meta.server || !this.visitorId) return
      const supabase = await getSupabase()
      if (!supabase) return
      try {
        await supabase.rpc('record_event', {
          p_visitor_id: this.visitorId,
          p_event_name: eventName,
          p_properties: properties
        })
      } catch (e) { /* best-effort */ }
    }
  }
})
