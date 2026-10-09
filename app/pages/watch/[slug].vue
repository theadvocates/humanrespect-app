<template>
  <div class="page">
    <article class="page-container">
      <p class="caption"><router-link to="/watch" class="caption-link">Watch</router-link> · Part {{ video.n }} · {{ video.minutes }} min</p>
      <h1 class="display-large" style="margin-top: 0.5rem;">{{ video.title }}</h1>
      <Divider />
      <p class="body-text-large">{{ video.description }}</p>

      <ExperienceVideo
        ref="player"
        class="player"
        :file="video.file"
        :label="`${video.title}, part ${video.n} of the series, as a narrated video`"
        @play="trackChoice('watch', 'video_play', { video: video.file })"
        @ended="trackChoice('watch', 'video_end', { video: video.file })"
      />

      <nav class="after" aria-label="This part">
        <router-link v-if="video.path" :to="video.path" class="after-link">Work through it yourself instead</router-link>
        <router-link v-if="next" :to="`/watch/${next.slug}`" class="after-link">Next: {{ next.title }}</router-link>
        <p v-else class="after-note">Next in the series: {{ NEXT_PART }}. It is on the way.</p>
      </nav>

      <section class="transcript">
        <h2 class="transcript-title">Transcript</h2>
        <p class="transcript-note">The narration, in full. A time jumps the video there.</p>
        <div v-for="p in transcript" :key="p.t" class="para">
          <button type="button" class="stamp" :aria-label="`Play from ${clock(p.t)}`" @click="player?.seek(p.t)">{{ clock(p.t) }}</button>
          <p class="para-text">{{ p.text }}</p>
        </div>
      </section>

      <nav class="series" aria-label="The series">
        <p class="series-title">The series, in order</p>
        <ol class="series-list">
          <li v-for="v in VIDEOS" :key="v.slug" :class="{ current: v.slug === video.slug }">
            <router-link v-if="v.slug !== video.slug" :to="`/watch/${v.slug}`">{{ v.n }}. {{ v.title }}</router-link>
            <span v-else aria-current="page">{{ v.n }}. {{ v.title }}</span>
          </li>
        </ol>
      </nav>
    </article>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import Divider from '@/components/shared/Divider.vue'
import ExperienceVideo from '@/components/shared/ExperienceVideo.vue'
import { useAnalytics } from '@/composables/useAnalytics'
import { VIDEOS, NEXT_PART, videoBySlug, isoDuration } from '@/utils/videos'
import { parseTranscript, clock } from '@/utils/transcript'
import { SITE_URL } from '@/utils/seo'

// The captions files, read at build time, so the transcript is the same text
// the player shows and cannot drift from it. Keyed by file stem.
const CAPTIONS = Object.fromEntries(
  Object.entries(import.meta.glob('~~/public/videos/exp-*.vtt', { query: '?raw', import: 'default', eager: true }))
    .map(([path, text]) => [path.split('/').pop().replace(/\.vtt$/, ''), text])
)

const route = useRoute()
const video = videoBySlug(route.params.slug)
if (!video) {
  throw createError({ statusCode: 404, statusMessage: 'No such part', fatal: true })
}

const next = VIDEOS.find((v) => v.n === video.n + 1) || null
const transcript = parseTranscript(CAPTIONS[video.file] || '')
const { trackChoice } = useAnalytics()
const player = ref(null)

const url = `${SITE_URL}/watch/${video.slug}`
usePageSeo('watch', {
  title: video.title,
  description: video.description,
  image: `${SITE_URL}/videos/${video.file}.jpg`,
  imageWidth: 1920,
  imageHeight: 1080,
  // The page's main content is the video, so the structured data says so:
  // what it is, how long, when it went up, and what is said in it.
  schema: [
    {
      '@type': 'VideoObject',
      '@id': `${url}#video`,
      name: video.title,
      description: video.description,
      url,
      thumbnailUrl: [`${SITE_URL}/videos/${video.file}.jpg`],
      contentUrl: `${SITE_URL}/videos/${video.file}.mp4`,
      uploadDate: video.uploadDate,
      duration: isoDuration(video.seconds),
      inLanguage: 'en-US',
      isFamilyFriendly: true,
      position: video.n,
      isPartOf: { '@id': `${SITE_URL}/#website` },
      publisher: { '@id': `${SITE_URL}/#organization` },
      transcript: transcript.map((p) => p.text).join('\n\n')
    }
  ]
})
</script>

<style scoped>
.page { background: var(--paper); min-height: 100vh; }
.page-container { max-width: 760px; margin: 0 auto; padding: 5rem 1.5rem 4rem; }
.caption-link { color: inherit; text-decoration: none; }
.caption-link:hover { text-decoration: underline; }
.body-text-large { font-size: 1.1rem; line-height: 1.8; color: var(--ink-soft); margin-top: 1.25rem; max-width: 640px; }
.player { margin-top: 2.5rem; }
.after { margin-top: 1.25rem; display: flex; flex-wrap: wrap; gap: 0.5rem 2rem; }
.after-link { font-family: var(--sans); font-size: 0.9rem; color: var(--ochre); text-decoration: none; }
.after-link:hover { text-decoration: underline; }
.after-note { font-family: var(--sans); font-size: 0.9rem; color: var(--ink-muted); margin: 0; }
.transcript { margin-top: 4rem; }
.transcript-title { font-family: var(--serif); font-size: 1.5rem; font-weight: 500; color: var(--ink); margin: 0; }
.transcript-note { font-family: var(--sans); font-size: 0.85rem; color: var(--ink-faint); margin: 0.4rem 0 1.75rem; }
.para { display: grid; grid-template-columns: 3.25rem 1fr; gap: 0.75rem; align-items: baseline; margin-bottom: 1.25rem; max-width: 680px; }
.stamp { font-family: var(--sans); font-variant-numeric: tabular-nums; font-size: 0.8rem; color: var(--ochre); background: none; border: none; padding: 0; cursor: pointer; text-align: left; min-height: 0; }
.stamp:hover { text-decoration: underline; }
.para-text { font-size: 1.02rem; line-height: 1.8; color: var(--ink-soft); margin: 0; }
.series { margin-top: 4rem; border-top: 1px solid var(--ink-faint); padding-top: 1.75rem; }
.series-title { font-family: var(--sans); font-size: 0.75rem; letter-spacing: 0.12em; text-transform: uppercase; color: var(--ink-faint); margin: 0 0 0.75rem; }
.series-list { list-style: none; margin: 0; padding: 0; display: grid; gap: 0.4rem; font-size: 0.95rem; }
.series-list a { color: var(--ochre); text-decoration: none; }
.series-list a:hover { text-decoration: underline; }
.series-list .current span { color: var(--ink); }
@media (max-width: 680px) {
  .page-container { padding: 4.5rem 1rem 3rem; }
  .para { grid-template-columns: 2.9rem 1fr; gap: 0.5rem; }
}
</style>
