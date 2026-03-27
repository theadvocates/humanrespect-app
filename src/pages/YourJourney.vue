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
  { name: 'exp01', title: 'The Question', tier: 'foundation', order: 1, desc: 'You already know that force damages relationships. The question is why we abandon that principle at scale.' },
  { name: 'exp03', title: 'What Flourishing Means', tier: 'foundation', order: 2, desc: 'Pick your strongest objection. It gets steelmanned and honestly conceded.' },
  { name: 'exp02', title: 'The Objection', tier: 'foundation', order: 3, desc: 'The empirical grounding for the principle, traced through your own life.' },
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
