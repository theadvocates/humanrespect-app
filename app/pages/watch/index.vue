<template>
  <div class="page">
    <div class="page-container">
      <p class="caption">Watch</p>
      <h1 class="display-large" style="margin-top: 0.5rem;">The experiences, as videos.</h1>
      <Divider />
      <p class="body-text-large">The same arguments as the interactive experiences, narrated, in the order the series runs. Each part answers the question the one before it leaves.</p>

      <!-- One page per part, with the video as its main content and the
           narration as a transcript. The index links to them rather than
           playing them here, so each video has one page that is about it. -->
      <ol class="parts">
        <li v-for="part in VIDEOS" :key="part.slug" class="part">
          <router-link :to="`/watch/${part.slug}`" class="part-poster-link" :aria-label="`${part.title}, part ${part.n}`">
            <img class="part-poster" :src="`/videos/${part.file}.jpg`" :alt="`${part.title}: opening picture`" width="1920" height="1080" loading="lazy">
          </router-link>
          <div class="part-text">
            <p class="part-number">Part {{ part.n }} · {{ part.minutes }} min</p>
            <h2 class="part-title"><router-link :to="`/watch/${part.slug}`">{{ part.title }}</router-link></h2>
            <p class="part-description">{{ part.description }}</p>
          </div>
        </li>
      </ol>

      <p class="body-text coming">Next in the series: {{ NEXT_PART }}. More parts are on the way.</p>
    </div>
  </div>
</template>

<script setup>
import Divider from '@/components/shared/Divider.vue'
import { VIDEOS, NEXT_PART } from '@/utils/videos'

definePageMeta({ name: 'watch' })
usePageSeo('watch')
</script>

<style scoped>
.page { background: var(--paper); min-height: 100vh; }
.page-container { max-width: 760px; margin: 0 auto; padding: 5rem 1.5rem 4rem; }
.body-text-large { font-size: 1.1rem; line-height: 1.8; color: var(--ink-soft); margin-top: 1.25rem; max-width: 640px; }
.body-text { font-size: 1rem; line-height: 1.8; color: var(--ink-soft); }
.parts { list-style: none; margin: 3rem 0 0; padding: 0; display: grid; gap: 2.5rem; }
.part { display: grid; grid-template-columns: 220px 1fr; gap: 1.5rem; align-items: start; }
.part-poster-link { display: block; border-radius: 8px; overflow: hidden; background: #17171F; border: 1px solid var(--ink-faint); }
.part-poster { display: block; width: 100%; height: auto; aspect-ratio: 16 / 9; object-fit: cover; }
.part-text { display: grid; gap: 0.5rem; }
.part-number { font-family: var(--sans); font-size: 0.75rem; letter-spacing: 0.12em; text-transform: uppercase; color: var(--ink-faint); margin: 0; }
.part-title { font-family: var(--serif); font-size: 1.5rem; font-weight: 500; color: var(--ink); margin: 0; text-wrap: balance; }
.part-title a { color: inherit; text-decoration: none; }
.part-title a:hover { text-decoration: underline; text-decoration-color: var(--ochre); }
.part-description { font-size: 0.95rem; line-height: 1.7; color: var(--ink-soft); margin: 0; }
.coming { margin-top: 3.5rem; color: var(--ink-muted); }
@media (max-width: 680px) {
  .page-container { padding: 4.5rem 1rem 3rem; }
  .part { grid-template-columns: 1fr; gap: 0.9rem; }
  .parts { gap: 2.25rem; }
}
</style>
