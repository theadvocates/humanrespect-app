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
