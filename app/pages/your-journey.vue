<template>
  <div class="page">
    <div class="page-container">
      <p class="caption">Your journey</p>
      <h1 class="display-large" style="margin-top: 0.5rem;">{{ heading }}</h1>
      <Divider />

      <!-- Someone who arrives here without having done the Turn has skipped
           the one-minute version of the whole argument. Send them there
           rather than opening with a wall of fifteen cards. -->
      <div v-if="!hasAnyProgress" class="intro">
        <p class="body-text-large">
          Everything here is optional. The question on the home page takes about
          a minute and contains the core of it; the rest is evidence,
          objections, and what to do about it.
        </p>
        <NuxtLink to="/" class="start-card">
          <span class="start-label">Start here</span>
          <span class="start-title">The question</span>
          <span class="start-meta">About a minute · no account needed</span>
        </NuxtLink>
        <p class="body-text intro-note">
          Or skip ahead — the full catalogue is below. Nothing is gated and
          nothing has to be done in order.
        </p>
      </div>

      <template v-else>
        <p class="body-text-large summary-line">
          You've finished <strong>{{ completedCount }}</strong> of
          {{ total }} experiences — about {{ minutesDone }} minutes of the
          roughly {{ minutesTotal }} here.
        </p>

        <div v-if="recommended" class="section">
          <h2 class="section-heading">Pick up here</h2>
          <NuxtLink :to="{ name: recommended.route }" class="start-card">
            <span class="start-label">Recommended next</span>
            <span class="start-title">{{ recommended.title }}</span>
            <span class="start-meta">{{ recommended.minutes }} minutes</span>
          </NuxtLink>
        </div>

        <div v-if="done.length" class="section">
          <h2 class="section-heading">What you've worked through</h2>
          <ul class="done-list">
            <li v-for="e in done" :key="e.id" class="done-item">
              <span class="done-check" aria-hidden="true">✓</span>
              <span class="done-title">{{ e.title }}</span>
              <NuxtLink :to="{ name: e.route }" class="done-again">Revisit</NuxtLink>
            </li>
          </ul>
        </div>
      </template>

      <!-- The full catalogue, always visible. Grouping is by commitment rather
           than by the old abstract tier names, and every card carries its real
           time cost — an unlabelled one is what makes people bail. -->
      <div v-for="tier in TIER_ORDER" :key="tier" class="section">
        <h2 class="section-heading">{{ TIERS[tier].label }}</h2>
        <p class="section-note">{{ TIERS[tier].note }}</p>
        <ul class="exp-list">
          <li v-for="e in byTier(tier)" :key="e.id">
            <NuxtLink :to="{ name: e.route }" class="exp" :class="{ finished: isDone(e.id) }">
              <span class="exp-main">
                <span class="exp-title">
                  <span v-if="isDone(e.id)" class="exp-check" aria-hidden="true">✓</span>
                  {{ e.title }}
                </span>
                <span class="exp-short">{{ e.short }}</span>
              </span>
              <span class="exp-time">{{ e.minutes }} min</span>
            </NuxtLink>
          </li>
        </ul>
      </div>

      <div class="progress-block">
        <div class="progress-track" role="progressbar" :aria-valuenow="pct" aria-valuemin="0" aria-valuemax="100">
          <div class="progress-fill" :style="{ width: pct + '%' }"/>
        </div>
        <p class="progress-label">{{ completedCount }} of {{ total }} complete</p>
      </div>

      <NewsletterSignup
        v-if="completedCount >= 2"
        source="your_journey"
        headline="Stay with it."
        description="A short email now and then, applying the philosophy to a real situation."
        button-text="Subscribe"
      />
    </div>
  </div>
</template>

<script setup>
import Divider from '@/components/shared/Divider.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import { useJourneyStore } from '@/stores/journey'
import { EXPERIENCES, TIERS, TIER_ORDER, byTier, totalMinutes } from '@/utils/experiences'

definePageMeta({ name: 'your-journey' })
usePageSeo('your-journey')

// Personalised to the visitor; nothing here is useful in search results.
useHead({ meta: [{ name: 'robots', content: 'noindex, follow' }] })

const journey = useJourneyStore()

const total = EXPERIENCES.length
const minutesTotal = totalMinutes()

function isDone(id) {
  if (id === 'exp01') return !!journey.exp01?.completed
  if (id === 'exp02') return !!journey.exp02?.completed
  return !!journey.completions?.[id]
}

const done = computed(() => EXPERIENCES.filter((e) => isDone(e.id)))
const completedCount = computed(() => done.value.length)
const minutesDone = computed(() => done.value.reduce((n, e) => n + e.minutes, 0))
const pct = computed(() => Math.round((completedCount.value / total) * 100))

const hasAnyProgress = computed(() => completedCount.value > 0)

// The next unfinished experience in curriculum order — foundation first, then
// arguments, then pillars, then practices.
const recommended = computed(() => {
  for (const tier of TIER_ORDER) {
    const next = byTier(tier).find((e) => !isDone(e.id))
    if (next) return next
  }
  return null
})

const heading = computed(() => {
  const n = completedCount.value
  if (n === 0) return 'Begin wherever you like.'
  if (n >= total) return "You've been through all of it."
  if (n >= 10) return 'You are deep into this.'
  if (n >= 5) return 'You are building something here.'
  return 'Welcome back.'
})
</script>

<style scoped>
.page { min-height: 100vh; background: var(--paper); }
.page-container { max-width: 44rem; margin: 0 auto; padding: 6rem 1.5rem 5rem; }

.intro { margin-bottom: 1rem; }
.intro-note { margin-top: 1.5rem; color: var(--ink-muted); font-size: 0.92rem; }
.summary-line { margin-bottom: 0.5rem; }
.summary-line strong { color: var(--ink); font-weight: 500; }

.section { margin-top: 3.25rem; }
.section-heading {
  font-family: var(--serif);
  font-size: 1.45rem;
  font-weight: 500;
  color: var(--ink);
  margin: 0 0 0.4rem;
}
.section-note {
  font-family: var(--sans);
  font-size: 0.9rem;
  color: var(--ink-muted);
  margin: 0 0 1.25rem;
}

.start-card {
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
  padding: 1.2rem 1.5rem;
  margin-top: 1.5rem;
  background: var(--cream);
  border: 1.5px solid var(--ochre-light);
  border-radius: var(--radius);
  text-decoration: none;
  transition: border-color 0.25s ease, transform 0.25s ease;
}
.start-card:hover { border-color: var(--ochre); transform: translateX(3px); }
.start-label {
  font-family: var(--sans);
  font-size: 0.68rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--ochre);
}
.start-title { font-family: var(--serif); font-size: 1.3rem; color: var(--ink); }
.start-meta { font-family: var(--sans); font-size: 0.84rem; color: var(--ink-muted); }

.exp-list, .done-list { list-style: none; padding: 0; margin: 0; }
.exp-list li { margin-bottom: 0.6rem; }

.exp {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1.25rem;
  padding: 1rem 1.35rem;
  background: var(--cream);
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  text-decoration: none;
  transition: border-color 0.2s ease, transform 0.2s ease;
}
.exp:hover { border-color: var(--ochre); transform: translateX(3px); }
.exp.finished { background: transparent; }
.exp-main { display: flex; flex-direction: column; gap: 0.25rem; min-width: 0; }
.exp-title {
  font-family: var(--serif);
  font-size: 1.12rem;
  color: var(--ink);
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.exp-check { color: var(--insight-green); font-size: 0.85rem; }
.exp-short {
  font-family: var(--sans);
  font-size: 0.88rem;
  line-height: 1.6;
  color: var(--ink-muted);
}
.exp-time {
  flex: 0 0 auto;
  font-family: var(--sans);
  font-size: 0.76rem;
  letter-spacing: 0.05em;
  color: var(--ink-faint);
  white-space: nowrap;
  padding-top: 0.25rem;
}

.done-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.6rem 0;
  border-bottom: 1px solid var(--border-subtle);
}
.done-check { color: var(--insight-green); font-size: 0.85rem; }
.done-title { font-family: var(--serif); font-size: 1.05rem; color: var(--ink); flex: 1; }
.done-again {
  font-family: var(--sans);
  font-size: 0.78rem;
  color: var(--ochre);
  text-decoration: none;
  border-bottom: 1px solid transparent;
}
.done-again:hover { border-bottom-color: var(--ochre); }

.progress-block { margin-top: 3.5rem; }
.progress-track { height: 2px; background: var(--paper-deep); border-radius: 2px; overflow: hidden; }
.progress-fill { height: 100%; background: var(--ochre); transition: width 0.6s ease; }
.progress-label {
  margin-top: 0.75rem;
  font-family: var(--sans);
  font-size: 0.8rem;
  color: var(--ink-muted);
}

@media (prefers-reduced-motion: reduce) {
  .exp:hover, .start-card:hover { transform: none; }
}

@media (max-width: 640px) {
  .page-container { padding: 5rem 1.15rem 3rem; }
  .exp { flex-direction: column; gap: 0.5rem; }
  .exp-time { padding-top: 0; }
}
</style>
