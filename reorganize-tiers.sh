#!/bin/bash
# Reorganize tier structure
# Foundation (3 sequential) → Arguments (any order) → Pillars (any order) → Practices (any order)
# Run from humanrespect-app/ root

set -e

echo "🏗️  Reorganizing tier structure..."

# ══════════════════════════════════════
# 1. UPDATE JOURNEYNAV with 4-tier system
# Full rewrite to avoid sed issues
# ══════════════════════════════════════

cat > src/components/shared/JourneyNav.vue << 'VUEEOF'
<template>
  <div class="journey-nav" v-if="nextSteps.length > 0 || revisitSteps.length > 0">
    <p class="caption" style="margin-bottom: 1rem;">{{ nextLabel || 'Continue your journey' }}</p>

    <div class="steps">
      <PathCard
        v-for="(step, idx) in nextSteps"
        :key="step.name"
        :to="{ name: step.name }"
        :recommended="idx === 0"
      >
        <template #title>{{ step.title }}</template>
        <template #desc>{{ step.desc }}</template>
      </PathCard>
    </div>

    <div v-if="revisitSteps.length > 0" class="revisit-section">
      <p class="revisit-label">Revisit</p>
      <div class="steps">
        <PathCard
          v-for="step in revisitSteps"
          :key="step.name"
          :to="{ name: step.name }"
        >
          <template #title>{{ step.title }}</template>
          <template #desc>{{ step.revisitDesc || step.desc }}</template>
        </PathCard>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import PathCard from '@/components/shared/PathCard.vue'
import { useJourneyStore } from '@/stores/journey'

const props = defineProps({
  current: { type: String, required: true },
  nextLabel: { type: String, default: '' }
})

const journey = useJourneyStore()

const allExperiences = [
  // Foundation (sequential)
  { name: 'exp01', title: 'The Question', desc: 'A thought experiment that reveals the gap between personal and political morality.', revisitDesc: 'Revisit the thought experiment that started everything.', tier: 'foundation', order: 1 },
  { name: 'exp02', title: 'The Objection', desc: 'Pick your strongest objection. It gets steelmanned, responded to, and honestly conceded.', revisitDesc: 'Try a different objection or revisit your original one.', tier: 'foundation', order: 2 },
  { name: 'exp03', title: 'What Flourishing Means', desc: 'Discover the empirical grounding for the principle, from your own life experience.', revisitDesc: 'Revisit the Three Domains framework.', tier: 'foundation', order: 3 },
  // Arguments (any order after foundation)
  { name: 'exp04', title: 'The Realist Objection', desc: 'People are flawed. That is the strongest argument for voluntary cooperation over concentrated power.', revisitDesc: 'Revisit the incentive argument against coercive systems.', tier: 'argument', order: 4 },
  { name: 'exp05', title: 'Human Agency', desc: 'If you hire someone to steal, you bear responsibility. What changes when the intermediary is a government?', revisitDesc: 'Revisit the agency argument and the chain of authorization.', tier: 'argument', order: 5 },
  // Pillars (any order)
  { name: 'pillarA', title: 'Bodily Integrity', desc: 'Why safety is the precondition for all flourishing. Who faces force in your name?', revisitDesc: 'Revisit the first domain of human integrity.', tier: 'pillar', order: 6 },
  { name: 'pillarB', title: 'Temporal Integrity', desc: 'Time as the irreplaceable substance of life. How many hours do you give to taxes?', revisitDesc: 'Revisit the tax-hours calculation.', tier: 'pillar', order: 7 },
  { name: 'pillarC', title: 'Material Integrity', desc: 'Property as crystallized time. What have you not built because of insecurity?', revisitDesc: 'Revisit material integrity and the cost of insecurity.', tier: 'pillar', order: 8 },
  { name: 'pillarD', title: 'The Human Respect Method', desc: 'Your values are not the problem. The question is force or persuasion.', revisitDesc: 'Revisit the values exercise and the method question.', tier: 'pillar', order: 9 },
  { name: 'pillarE', title: 'Cooperation as Technology', desc: 'Real evidence that voluntary cooperation solves problems people assume require force.', revisitDesc: 'Explore voluntary alternatives for a different issue.', tier: 'pillar', order: 10 },
  // Practices (any order)
  { name: 'practice01', title: 'Political Footprint', desc: 'Map where force operates in your life vs. where you support it.', revisitDesc: 'See if your footprint has changed.', tier: 'practice', order: 11 },
  { name: 'practice02', title: 'Persuasion Practice', desc: 'Draft a persuasion-only approach to an issue you care about.', revisitDesc: 'Try a different issue this time.', tier: 'practice', order: 12 },
  { name: 'practice03', title: 'The Conversation', desc: 'A framework for discussing Human Respect with someone who disagrees.', revisitDesc: 'Refresh the four-move framework.', tier: 'practice', order: 13 },
  { name: 'practice04', title: 'Respect Audit', desc: 'Notice force vs. persuasion in your daily life for 7 days.', revisitDesc: 'Start another 7-day observation cycle.', tier: 'practice', order: 14 },
  { name: 'practice05', title: 'Design a Solution', desc: 'Pick a real problem. Solve it with zero coercion.', revisitDesc: 'Design a solution for a different problem.', tier: 'practice', order: 15 },
]

function isCompleted(name) {
  if (name === 'exp01') return !!journey.exp01?.completed
  if (name === 'exp02') return !!journey.exp02?.completed
  return !!journey.completions?.[name]
}

const others = computed(() => allExperiences.filter(e => e.name !== props.current))

const nextSteps = computed(() => {
  const incomplete = others.value.filter(e => !isCompleted(e.name))
  if (incomplete.length === 0) return []

  const currentExp = allExperiences.find(e => e.name === props.current)
  const currentTier = currentExp?.tier || 'foundation'

  // Smart ordering based on where we are
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
})

function getTierPriority(currentTier) {
  switch (currentTier) {
    case 'foundation':
      return ['foundation', 'argument', 'pillar', 'practice']
    case 'argument':
      return ['argument', 'pillar', 'practice', 'foundation']
    case 'pillar':
      return ['pillar', 'argument', 'practice', 'foundation']
    case 'practice':
      return ['practice', 'pillar', 'argument', 'foundation']
    default:
      return ['foundation', 'argument', 'pillar', 'practice']
  }
}
</script>

<style scoped>
.journey-nav { margin-top: 3rem; }
.steps { display: flex; flex-direction: column; gap: 0.5rem; }
.revisit-section { margin-top: 2rem; }
.revisit-label { font-size: 0.72rem; letter-spacing: 0.1em; text-transform: uppercase; color: var(--ink-faint); margin-bottom: 0.5rem; }
</style>
VUEEOF

echo "  ✓ JourneyNav rewritten with 4-tier system"

# ══════════════════════════════════════
# 2. UPDATE YOUR JOURNEY PAGE with 4 sections
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

        <!-- FOUNDATION (if any incomplete) -->
        <div v-if="availableByTier.foundation.length > 0" class="section">
          <h2 class="section-heading">Foundation</h2>
          <p class="section-note">Sequential experiences that build the philosophical framework.</p>
          <div class="experience-list">
            <PathCard v-for="exp in availableByTier.foundation" :key="exp.name" :to="{ name: exp.name }">
              <template #title>{{ exp.title }}</template>
              <template #desc>{{ exp.desc }}</template>
            </PathCard>
          </div>
        </div>

        <!-- ARGUMENTS (if any incomplete) -->
        <div v-if="availableByTier.argument.length > 0" class="section">
          <h2 class="section-heading">Arguments</h2>
          <p class="section-note">Standalone arguments that deepen the case. Explore in any order.</p>
          <div class="experience-list">
            <PathCard v-for="exp in availableByTier.argument" :key="exp.name" :to="{ name: exp.name }">
              <template #title>{{ exp.title }}</template>
              <template #desc>{{ exp.desc }}</template>
            </PathCard>
          </div>
        </div>

        <!-- PILLARS (if any incomplete) -->
        <div v-if="availableByTier.pillar.length > 0" class="section">
          <h2 class="section-heading">Pillars</h2>
          <p class="section-note">The three domains of human integrity and the case for cooperation.</p>
          <div class="experience-list">
            <PathCard v-for="exp in availableByTier.pillar" :key="exp.name" :to="{ name: exp.name }">
              <template #title>{{ exp.title }}</template>
              <template #desc>{{ exp.desc }}</template>
            </PathCard>
          </div>
        </div>

        <!-- PRACTICES (if any incomplete) -->
        <div v-if="availableByTier.practice.length > 0" class="section">
          <h2 class="section-heading">Practices</h2>
          <p class="section-note">Apply the philosophy to your actual life.</p>
          <div class="experience-list">
            <PathCard v-for="exp in availableByTier.practice" :key="exp.name" :to="{ name: exp.name }">
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
  { name: 'exp01', title: 'The Question', tier: 'foundation', order: 1, desc: 'A thought experiment revealing the gap between personal and political morality.' },
  { name: 'exp02', title: 'The Objection', tier: 'foundation', order: 2, desc: 'Pick your strongest objection. It gets steelmanned and honestly conceded.' },
  { name: 'exp03', title: 'What Flourishing Means', tier: 'foundation', order: 3, desc: 'The empirical grounding for the principle, traced through your own life.' },
  { name: 'exp04', title: 'The Realist Objection', tier: 'argument', order: 4, desc: 'People are flawed. That is the strongest argument for voluntary cooperation.' },
  { name: 'exp05', title: 'Human Agency', tier: 'argument', order: 5, desc: 'If you hire someone to steal, you bear responsibility. What about voting?' },
  { name: 'pillarA', title: 'Bodily Integrity', tier: 'pillar', order: 6, desc: 'Why safety is the precondition for all flourishing.' },
  { name: 'pillarB', title: 'Temporal Integrity', tier: 'pillar', order: 7, desc: 'Time as the irreplaceable substance of life.' },
  { name: 'pillarC', title: 'Material Integrity', tier: 'pillar', order: 8, desc: 'Property as crystallized time. The cost of insecurity.' },
  { name: 'pillarD', title: 'The Human Respect Method', tier: 'pillar', order: 9, desc: 'Your values are not the problem. The question is force or persuasion.' },
  { name: 'pillarE', title: 'Cooperation as Technology', tier: 'pillar', order: 10, desc: 'Real evidence that voluntary cooperation works at scale.' },
  { name: 'practice01', title: 'Political Footprint', tier: 'practice', order: 11, desc: 'Map where force operates in your life vs. where you support it.' },
  { name: 'practice02', title: 'Persuasion Practice', tier: 'practice', order: 12, desc: 'Draft a persuasion-only approach to an issue you care about.' },
  { name: 'practice03', title: 'The Conversation', tier: 'practice', order: 13, desc: 'A framework for discussing this with someone who disagrees.' },
  { name: 'practice04', title: 'Respect Audit', tier: 'practice', order: 14, desc: 'Notice force vs. persuasion in your daily life for 7 days.' },
  { name: 'practice05', title: 'Design a Solution', tier: 'practice', order: 15, desc: 'Pick a real problem. Solve it with zero coercion.' },
]

const totalCount = allExperiences.length

function isCompleted(name) {
  if (name === 'exp01') return !!journey.exp01?.completed
  if (name === 'exp02') return !!journey.exp02?.completed
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
  // Then arguments
  const nextArgument = incomplete.find(e => e.tier === 'argument')
  if (nextArgument) return nextArgument
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
    argument: incomplete.filter(e => e.tier === 'argument'),
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

.completed-experiences { display: flex; flex-direction: column; gap: 0.5rem; margin-top: 0.75rem; }
.completed-card { display: flex; justify-content: space-between; align-items: center; padding: 0.85rem 1.1rem; background: var(--cream); border: 1px solid var(--border-subtle); border-radius: var(--radius); }
.completed-header { display: flex; gap: 0.75rem; align-items: flex-start; flex: 1; }
.completed-check { flex-shrink: 0; width: 20px; height: 20px; border-radius: 50%; background: var(--insight-bg); color: var(--insight-green); font-size: 0.65rem; display: flex; align-items: center; justify-content: center; margin-top: 2px; }
.completed-title { font-family: var(--serif); font-size: 0.92rem; font-weight: 500; color: var(--ink); }
.completed-detail { font-size: 0.75rem; color: var(--ink-faint); margin-top: 0.15rem; font-style: italic; }
.revisit-link { flex-shrink: 0; font-size: 0.75rem; color: var(--ochre); text-decoration: none; font-family: var(--sans); transition: opacity 0.2s; }
.revisit-link:hover { opacity: 0.7; }

.experience-list { display: flex; flex-direction: column; gap: 0.5rem; }

.progress-bar-section { margin-top: 3rem; padding-top: 2rem; border-top: 1px solid var(--border-subtle); }
.progress-label { font-size: 0.78rem; color: var(--ink-faint); margin-bottom: 0.5rem; }
.progress-track { height: 6px; background: var(--paper-warm); border-radius: 3px; overflow: hidden; }
.progress-fill { height: 100%; background: var(--ochre); border-radius: 3px; transition: width 0.6s ease; }

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

echo "  ✓ YourJourney.vue updated with 4 tiers"

# ══════════════════════════════════════
# 3. UPDATE MILESTONE PAGE — point to arguments + pillars
# ══════════════════════════════════════

cat > src/pages/MilestonePage.vue << 'VUEEOF'
<template>
  <div class="page">
    <div class="page-container stagger" ref="el">

      <div class="milestone-badge">Foundation complete</div>

      <h1 class="display-large" style="margin-top: 1rem; text-align: center;">
        You've built the framework.
      </h1>

      <Divider :centered="true" />

      <p class="body-text-large" style="text-align: center; max-width: 520px; margin: 1.5rem auto 0;">
        Three experiences. Three discoveries. A foundation for seeing every political question differently.
      </p>

      <div class="discoveries">
        <div class="discovery">
          <div class="discovery-num">01</div>
          <div class="discovery-content">
            <div class="discovery-title">The gap</div>
            <p class="discovery-desc" v-if="journey.mirrorPattern === 'gap'">You hold one moral standard for personal life and a different one for politics. Most people do. Now you've seen it.</p>
            <p class="discovery-desc" v-else-if="journey.mirrorPattern === 'consistent-voluntary'">You apply the same moral standard to personal and political life. You're already living by the principle most people haven't noticed.</p>
            <p class="discovery-desc" v-else>You examined your own moral reasoning and found a pattern worth understanding.</p>
          </div>
        </div>

        <div class="discovery">
          <div class="discovery-num">02</div>
          <div class="discovery-content">
            <div class="discovery-title">The objection</div>
            <p class="discovery-desc" v-if="journey.exp02.chosenObjection">You chose "{{ objectionTitle }}" and saw it steelmanned, responded to, and honestly conceded.</p>
            <p class="discovery-desc" v-else>You tested the philosophy against your strongest objection.</p>
          </div>
        </div>

        <div class="discovery">
          <div class="discovery-num">03</div>
          <div class="discovery-content">
            <div class="discovery-title">The grounding</div>
            <p class="discovery-desc">You traced the principle through your own life and found that flourishing tracks with the three domains: body, resources, and time.</p>
          </div>
        </div>
      </div>

      <div style="margin-top: 3rem;">
        <h2 class="display-medium" style="text-align: center;">What the philosophy asks of you.</h2>
        <Divider :centered="true" />

        <ContentBlock variant="principle">
          <p>Not agreement. Not conversion. Not a political identity. Just a question you carry with you: in this situation, am I reaching for force or persuasion? And could the outcome be better if I chose differently?</p>
        </ContentBlock>
      </div>

      <div style="margin-top: 3rem;">
        <h2 class="display-medium" style="text-align: center;">Three paths forward.</h2>
        <Divider :centered="true" />

        <p class="body-text">The foundation is complete. From here, the philosophy opens up in three directions.</p>

        <div class="path-section">
          <div class="path-label">Arguments</div>
          <p class="path-desc">Standalone arguments that deepen the case. Why human nature is the argument <em>for</em> the philosophy. Why you bear moral responsibility for the force you authorize.</p>
        </div>

        <div class="path-section">
          <div class="path-label">Pillars</div>
          <p class="path-desc">The three domains of human integrity explored in depth, plus the method question and the evidence for cooperation.</p>
        </div>

        <div class="path-section">
          <div class="path-label">Practices</div>
          <p class="path-desc">Apply the philosophy to your actual life. Map your political footprint, practice persuasion, design voluntary solutions.</p>
        </div>
      </div>

      <JourneyNav current="milestone" next-label="Continue your journey" />

      <NewsletterSignup
        source="milestone"
        headline="The questions don't stop here."
        description="One short email per week applying the Philosophy of Human Respect to a real situation."
        success-message="You're in. The first question arrives this week."
      />

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
import ContentBlock from '@/components/shared/ContentBlock.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from '@/components/experiences/exp02/objectionData.js'

const journey = useJourneyStore()
const el = ref(null)

onMounted(() => {
  document.body.classList.remove('dark-mode')
  requestAnimationFrame(() => el.value?.classList.add('animate'))
})

const objectionTitle = computed(() => {
  const key = journey.exp02.chosenObjection
  return key && objections[key] ? objections[key].title : ''
})
</script>

<style scoped>
.page { background: var(--paper); min-height: 100vh; }
.page-container { max-width: 640px; margin: 0 auto; padding: 5rem 1.5rem 4rem; }

.milestone-badge { text-align: center; font-size: 0.68rem; letter-spacing: 0.12em; text-transform: uppercase; color: var(--insight-green); background: var(--insight-bg); display: block; padding: 0.35rem 1rem; border-radius: 100px; font-weight: 600; width: fit-content; margin: 0 auto; }

.discoveries { margin: 3rem 0; display: flex; flex-direction: column; gap: 1.5rem; }
.discovery { display: flex; gap: 1.25rem; align-items: flex-start; }
.discovery-num { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.discovery-content {}
.discovery-title { font-family: var(--serif); font-size: 1.1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.25rem; }
.discovery-desc { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.65; margin: 0; }

.path-section { margin-top: 1.25rem; padding: 1rem 1.25rem; background: var(--cream); border-radius: var(--radius); border: 1px solid var(--border-subtle); }
.path-label { font-family: var(--serif); font-size: 0.95rem; font-weight: 500; color: var(--ink); margin-bottom: 0.25rem; }
.path-desc { font-size: 0.85rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }

.page-footer { padding: 3rem 1.5rem; background: var(--ink); display: flex; justify-content: center; }
.footer-inner { max-width: 640px; width: 100%; display: flex; justify-content: space-between; align-items: center; }
.footer-left { font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: rgba(244, 240, 234, 0.3); }
.footer-right { display: flex; gap: 2rem; }
.footer-link { font-family: var(--sans); font-size: 0.72rem; letter-spacing: 0.08em; text-transform: uppercase; color: rgba(244, 240, 234, 0.25); text-decoration: none; transition: color 0.3s ease; }
.footer-link:hover { color: rgba(244, 240, 234, 0.6); }

@media (max-width: 480px) {
  .page-container { padding: 3.5rem 1.25rem 3rem; }
  .footer-inner { flex-direction: column; gap: 1.5rem; text-align: center; }
}
</style>
VUEEOF

echo "  ✓ MilestonePage updated — three paths forward"

echo ""
echo "✅ Tier reorganization complete!"
echo ""
echo "New structure:"
echo "  Foundation (3, sequential): The Question → The Objection → Flourishing"
echo "  Arguments (2, any order): The Realist Objection, Human Agency"
echo "  Pillars (5, any order): Body, Time, Resources, Method, Cooperation"
echo "  Practices (5, any order): Footprint, Persuasion, Conversation, Audit, Design"
echo ""
echo "What changed:"
echo "  - JourneyNav: full rewrite with 4-tier priority system"
echo "  - YourJourney: 4 sections instead of 3"
echo "  - Milestone: 'three paths forward' (arguments, pillars, practices)"
echo "  - Recommendation logic: foundation → arguments → pillars → practices"
echo ""
echo "TEST BUILD:"
echo "  npm run build"
echo ""
echo "If build passes:"
echo "  git add . && git commit -m 'ux: 4-tier structure (foundation, arguments, pillars, practices)' && git push"
