#!/bin/bash
# Adds completion indicators across the site
# Run from humanrespect-app/ root

set -e

echo "✅ Adding completion indicators..."

# ══════════════════════════════════════
# 1. UPDATE PATHCARD with optional completed state
# ══════════════════════════════════════

cat > src/components/shared/PathCard.vue << 'VUEEOF'
<template>
  <component
    :is="to ? 'router-link' : 'a'"
    :to="to || undefined"
    :href="href || undefined"
    class="path-card"
    :class="{ completed, disabled }"
    v-bind="$attrs"
  >
    <div class="path-card-content">
      <div class="path-card-header">
        <span v-if="completed" class="completed-badge">✓ Done</span>
      </div>
      <div class="path-card-title"><slot name="title" /></div>
      <div class="path-card-desc"><slot name="desc" /></div>
    </div>
    <span class="path-arrow" v-if="!disabled">→</span>
  </component>
</template>

<script setup>
defineProps({
  to: { type: [Object, String], default: null },
  href: { type: String, default: null },
  completed: { type: Boolean, default: false },
  disabled: { type: Boolean, default: false }
})
</script>

<style scoped>
.path-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem 1.5rem;
  margin-bottom: 0.75rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  text-decoration: none;
  color: var(--ink);
  transition: all 0.25s ease;
  box-shadow: var(--shadow-soft);
  -webkit-tap-highlight-color: transparent;
}

.path-card:hover {
  border-color: var(--ochre);
  box-shadow: var(--shadow-hover);
  transform: translateY(-1px);
}

.path-card:active {
  transform: translateY(0);
}

.path-card.completed {
  background: var(--paper);
  border-color: var(--border-subtle);
  opacity: 0.75;
}

.path-card.completed:hover {
  opacity: 1;
  border-color: var(--ochre);
}

.path-card.disabled {
  opacity: 0.4;
  pointer-events: none;
}

.path-card-content {
  flex: 1;
  min-width: 0;
}

.path-card-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.completed-badge {
  display: inline-block;
  font-size: 0.65rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--insight-green);
  background: var(--insight-bg);
  padding: 0.2rem 0.5rem;
  border-radius: 3px;
  margin-bottom: 0.35rem;
}

.path-card-title {
  font-family: var(--serif);
  font-size: 1.05rem;
  font-weight: 500;
  color: var(--ink);
  line-height: 1.35;
}

.path-card.completed .path-card-title {
  color: var(--ink-muted);
}

.path-card-desc {
  font-family: var(--sans);
  font-size: 0.82rem;
  color: var(--ink-muted);
  margin-top: 0.3rem;
  line-height: 1.55;
}

.path-arrow {
  flex-shrink: 0;
  font-size: 1rem;
  color: var(--ochre);
  margin-left: 1rem;
  transition: transform 0.2s ease;
}

.path-card:hover .path-arrow {
  transform: translateX(3px);
}

@media (max-width: 480px) {
  .path-card {
    padding: 1rem 1.25rem;
  }
}
</style>
VUEEOF

echo "  ✓ PathCard updated with completed state"

# ══════════════════════════════════════
# 2. UPDATE JOURNEYNAV to pass completed prop
# ══════════════════════════════════════

cat > src/components/shared/JourneyNav.vue << 'VUEEOF'
<template>
  <div class="journey-nav">
    <!-- Suggested next steps (not yet completed) -->
    <div v-if="nextSteps.length" class="nav-section">
      <p class="caption" style="margin-bottom: 1rem;">{{ nextLabel }}</p>
      <PathCard
        v-for="step in nextSteps"
        :key="step.name"
        :to="{ name: step.name }"
      >
        <template #title>{{ step.title }}</template>
        <template #desc>{{ step.desc }}</template>
      </PathCard>
    </div>

    <!-- Already completed (revisit) -->
    <div v-if="revisitSteps.length" class="nav-section" style="margin-top: 2rem;">
      <p class="caption" style="margin-bottom: 1rem;">Revisit</p>
      <PathCard
        v-for="step in revisitSteps"
        :key="step.name"
        :to="{ name: step.name }"
        :completed="true"
      >
        <template #title>{{ step.title }}</template>
        <template #desc>{{ step.revisitDesc || step.desc }}</template>
      </PathCard>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import PathCard from '@/components/shared/PathCard.vue'
import { useJourneyStore } from '@/stores/journey'

const props = defineProps({
  current: { type: String, required: true },
  nextLabel: { type: String, default: 'Continue your journey' }
})

const journey = useJourneyStore()

const allExperiences = [
  { name: 'exp01', title: 'The Question', desc: 'A five-minute thought experiment that reveals the gap between personal and political morality.', revisitDesc: 'Revisit the thought experiment that started everything.', tier: 'foundation', order: 1 },
  { name: 'exp02', title: 'The Objection', desc: 'Pick your strongest objection. It gets steelmanned, responded to, and honestly conceded.', revisitDesc: 'Try a different objection — or revisit your original one.', tier: 'foundation', order: 2 },
  { name: 'exp03', title: 'What Flourishing Actually Means', desc: 'Discover the empirical grounding for the principle — from your own life experience.', revisitDesc: 'Revisit the Six Pillars and Three Domains framework.', tier: 'foundation', order: 3 },
  { name: 'pillarA', title: 'Your Body Is Not Negotiable', desc: 'Bodily integrity — why safety is the precondition for all flourishing.', revisitDesc: 'Revisit the first domain of human integrity.', tier: 'pillar', order: 4 },
  { name: 'pillarB', title: 'Your Time Is Your Life', desc: 'Time as the irreplaceable substance of life — the philosophy\'s most original insight.', revisitDesc: 'Revisit the tax-hours calculation and the hierarchy of irreversibility.', tier: 'pillar', order: 5 },
  { name: 'pillarC', title: 'What You Built Is Who You Were', desc: 'Property as crystallized time — why material integrity matters for flourishing.', revisitDesc: 'Revisit material integrity and the meaning of theft.', tier: 'pillar', order: 6 },
  { name: 'pillarD', title: 'The Method Is the Message', desc: 'Your values aren\'t the problem. The question is force or persuasion.', revisitDesc: 'Revisit the values exercise and the method question.', tier: 'pillar', order: 7 },
  { name: 'pillarE', title: 'Cooperation Is a Technology', desc: 'Real evidence that voluntary cooperation solves problems people assume require force.', revisitDesc: 'Explore voluntary alternatives for a different issue.', tier: 'pillar', order: 8 },
  { name: 'practice01', title: 'Your Political Footprint', desc: 'Map where you currently support coercion in your life.', revisitDesc: 'See if your footprint has changed.', tier: 'practice', order: 9 },
  { name: 'practice02', title: 'The Persuasion Practice', desc: 'Take an issue you care about and design a persuasion-only approach.', revisitDesc: 'Try a different issue this time.', tier: 'practice', order: 10 },
  { name: 'practice03', title: 'The Conversation', desc: 'A framework for discussing Human Respect with someone who disagrees.', revisitDesc: 'Refresh the four-move framework before your next conversation.', tier: 'practice', order: 11 },
  { name: 'practice04', title: 'The Respect Audit', desc: 'Track where you choose persuasion vs. force for 7 days.', revisitDesc: 'Start another 7-day cycle of awareness.', tier: 'practice', order: 12 },
  { name: 'practice05', title: 'Design a Voluntary Solution', desc: 'Pick a real problem in your community and solve it without force.', revisitDesc: 'Design a solution for a different community problem.', tier: 'practice', order: 13 },
]

const isCompleted = (name) => {
  if (name === 'exp01') return journey.exp01.completed
  if (name === 'exp02') return journey.exp02.completed
  return !!journey.completions[name]
}

const others = computed(() => allExperiences.filter(e => e.name !== props.current))

const nextSteps = computed(() => {
  const incomplete = others.value.filter(e => !isCompleted(e.name))
  if (incomplete.length === 0) return []

  const currentTier = allExperiences.find(e => e.name === props.current)?.tier
  const tierPriority = getTierPriority(currentTier)

  return incomplete
    .sort((a, b) => {
      const aPri = tierPriority.indexOf(a.tier)
      const bPri = tierPriority.indexOf(b.tier)
      if (aPri !== bPri) return aPri - bPri
      return a.order - b.order
    })
    .slice(0, 3)
})

const revisitSteps = computed(() => {
  return others.value
    .filter(e => isCompleted(e.name))
    .sort((a, b) => a.order - b.order)
    .slice(0, 2)
})

function getTierPriority(currentTier) {
  switch (currentTier) {
    case 'foundation': return ['foundation', 'pillar', 'practice']
    case 'pillar': return ['pillar', 'practice', 'foundation']
    case 'practice': return ['practice', 'pillar', 'foundation']
    default: return ['foundation', 'pillar', 'practice']
  }
}
</script>

<style scoped>
.journey-nav { margin-top: 2.5rem; }
</style>
VUEEOF

echo "  ✓ JourneyNav passes completed prop to revisit cards"

# ══════════════════════════════════════
# 3. UPDATE EXP02 to track explored objections
#    and show completion state on objection cards
# ══════════════════════════════════════

# First update the journey store to track explored objections
cat > src/stores/journey.js << 'JSEOF'
import { defineStore } from 'pinia'
import { supabase } from '@/lib/supabase'

const USE_SUPABASE = true

const TIER_ORDER = { none: 0, foundation: 1, pillar: 2, practice: 3 }

function getTier(expId) {
  if (expId.startsWith('exp')) return 'foundation'
  if (expId.startsWith('pillar')) return 'pillar'
  if (expId.startsWith('practice')) return 'practice'
  return 'none'
}

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
      exploredObjections: [],
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
    isCompleted: (state) => (expId) => !!state.completions[expId],
    hasExploredObjection: (state) => (key) => state.exp02.exploredObjections.includes(key)
  },

  actions: {
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
      // Track this specific objection as explored
      if (objection && !this.exp02.exploredObjections.includes(objection)) {
        this.exp02.exploredObjections.push(objection)
      }
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
          if (!parsed.exp02?.exploredObjections) {
            if (!parsed.exp02) parsed.exp02 = {}
            parsed.exp02.exploredObjections = parsed.exp02.chosenObjection ? [parsed.exp02.chosenObjection] : []
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

echo "  ✓ Journey store updated with exploredObjections tracking"

# ── Update Exp02 WhereNext to show explored state ──
cat > src/components/experiences/exp02/WhereNext.vue << 'VUEEOF'
<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">You examined one objection. There are others.</h2>
    <Divider />
    <p class="body-text-large">Each objection gets the same treatment — steelmanned, responded to, conceded where honesty requires.</p>

    <div v-if="unexploredObjections.length" style="margin-top: 2rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore another objection</p>
      <PathCard v-for="key in unexploredObjections" :key="key" href="#" @click.prevent="$emit('restart-with', key)">
        <template #title>{{ allObjections[key].title }}</template>
        <template #desc>Explore this objection with the same honesty.</template>
      </PathCard>
    </div>

    <div v-if="exploredOtherObjections.length" style="margin-top: 1.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Already explored</p>
      <PathCard v-for="key in exploredOtherObjections" :key="key" href="#" :completed="true" @click.prevent="$emit('restart-with', key)">
        <template #title>{{ allObjections[key].title }}</template>
        <template #desc>Revisit this objection.</template>
      </PathCard>
    </div>

    <div v-if="allExplored" style="margin-top: 2rem;">
      <ContentBlock variant="insight">
        <p>You've explored all four objections. You've seen each one steelmanned, responded to, and honestly conceded. That's rare — most people stop at the first one that confirms their existing view.</p>
      </ContentBlock>
    </div>

    <JourneyNav current="exp02" next-label="Continue your journey" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections as allObjections } from './objectionData.js'

defineEmits(['restart-with'])
const journey = useJourneyStore()

const allKeys = Object.keys(allObjections)
const otherKeys = computed(() => allKeys.filter(k => k !== journey.exp02.chosenObjection))

const unexploredObjections = computed(() =>
  otherKeys.value.filter(k => !journey.exp02.exploredObjections.includes(k))
)

const exploredOtherObjections = computed(() =>
  otherKeys.value.filter(k => journey.exp02.exploredObjections.includes(k))
)

const allExplored = computed(() =>
  allKeys.every(k => journey.exp02.exploredObjections.includes(k))
)

const el = ref(null)
onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  journey.completeExp02(journey.exp02.chosenObjection, null)
})
</script>

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
VUEEOF

echo "  ✓ Exp02 WhereNext shows explored/unexplored state"

echo ""
echo "✅ Completion indicators added everywhere!"
echo ""
echo "What changed:"
echo "  • PathCard has a 'completed' prop — shows a green '✓ Done' badge,"
echo "    slightly faded background, muted title text"
echo "  • JourneyNav passes completed=true to all revisit cards"
echo "  • Exp02 tracks which objections you've explored (not just the latest)"
echo "  • Exp02 WhereNext splits objections into 'Explore another' vs 'Already explored'"
echo "  • When all 4 objections are explored, shows a congratulatory insight"
echo "  • Old localStorage data is migrated — if you had a chosenObjection,"
echo "    it's added to exploredObjections on hydrate"
echo ""
echo "Push with: git add . && git commit -m 'ux: completion indicators + explored tracking' && git push"
