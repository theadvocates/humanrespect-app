<template>
  <div class="page">
    <div class="page-container">
      <p class="caption">Watch</p>
      <h1 class="display-large" style="margin-top: 0.5rem;">The experiences, as videos.</h1>
      <Divider />
      <p class="body-text-large">The same arguments as the interactive experiences, narrated, in the order the series runs. Each part answers the question the one before it leaves.</p>

      <section v-for="part in parts" :key="part.file" class="part">
        <p class="part-number">Part {{ part.n }} · {{ part.minutes }} min</p>
        <h2 class="part-title">{{ part.title }}</h2>
        <ExperienceVideo
          :file="part.file"
          :label="`${part.title}, part ${part.n} of the series, as a narrated video`"
          @play="trackChoice('watch', 'video_play', { video: part.file })"
          @ended="trackChoice('watch', 'video_end', { video: part.file })"
        />
        <router-link :to="part.path" class="part-link">Work through it yourself instead</router-link>
      </section>

      <p class="body-text coming">Next in the series: {{ next }}. More parts are on the way.</p>
    </div>
  </div>
</template>

<script setup>
import Divider from '@/components/shared/Divider.vue'
import ExperienceVideo from '@/components/shared/ExperienceVideo.vue'
import { useAnalytics } from '@/composables/useAnalytics'

definePageMeta({ name: 'watch' })
usePageSeo('watch')
const { trackChoice } = useAnalytics()

// The parts that are finished, in series order (explainer-videos,
// series/humanrespect.yaml). Add a row when a part goes live.
const parts = [
  { n: 1, title: 'The Question', file: 'exp-the-question', path: '/experience/the-question', minutes: 3 },
  { n: 2, title: 'The Objection', file: 'exp-the-objection', path: '/experience/the-objection', minutes: 4 },
  { n: 3, title: 'What Flourishing Actually Means', file: 'exp-flourishing', path: '/experience/flourishing', minutes: 5 },
  { n: 4, title: 'Human Agency', file: 'exp-human-agency', path: '/experience/human-agency', minutes: 5 }
]
const next = 'Cooperation Is a Technology'
</script>

<style scoped>
.page { background: var(--paper); min-height: 100vh; }
.page-container { max-width: 760px; margin: 0 auto; padding: 5rem 1.5rem 4rem; }
.body-text-large { font-size: 1.1rem; line-height: 1.8; color: var(--ink-soft); margin-top: 1.25rem; max-width: 640px; }
.body-text { font-size: 1rem; line-height: 1.8; color: var(--ink-soft); }
.part { margin-top: 3.5rem; display: grid; gap: 0.9rem; }
.part-number { font-family: var(--sans); font-size: 0.75rem; letter-spacing: 0.12em; text-transform: uppercase; color: var(--ink-faint); margin: 0; }
.part-title { font-family: var(--serif); font-size: 1.6rem; font-weight: 500; color: var(--ink); margin: 0; text-wrap: balance; }
.part-link { font-family: var(--sans); font-size: 0.9rem; color: var(--ochre); text-decoration: none; justify-self: start; }
.part-link:hover { text-decoration: underline; }
.coming { margin-top: 3.5rem; color: var(--ink-muted); }
@media (max-width: 680px) {
  .page-container { padding: 4.5rem 1rem 3rem; }
  .part { margin-top: 2.75rem; }
}
</style>
