<template>
  <figure class="rv">
    <video
      ref="el"
      class="rv-video"
      controls
      playsinline
      preload="metadata"
      :poster="`/videos/result-${result}.jpg`"
      :aria-label="`Your result, ${name}, as a one-minute video`"
      @play="onPlay"
      @ended="$emit('ended')"
    >
      <source :src="`/videos/result-${result}.mp4`" type="video/mp4">
      <track kind="captions" :src="`/videos/result-${result}.vtt`" srclang="en" label="English" default>
    </video>
    <figcaption class="rv-caption">The same result, read aloud. About a minute.</figcaption>
  </figure>
</template>

<script setup>
/**
 * The result as a short narrated video, for people who won't read it. The
 * files are served from /public/videos and made in the explainer-videos
 * repository, one per result key.
 */
const props = defineProps({
  result: { type: String, required: true },
  name: { type: String, required: true }
})
const emit = defineEmits(['play', 'ended'])

let played = false
function onPlay() {
  if (played) return
  played = true
  emit('play', props.result)
}
</script>

<style scoped>
.rv { margin: 1.6rem 0 0; }
.rv-video {
  display: block;
  width: 100%;
  aspect-ratio: 16 / 9;
  border-radius: 10px;
  background: var(--paper-deep);
  border: 1px solid var(--border-subtle);
}
.rv-caption {
  margin-top: 0.6rem;
  font-family: var(--sans);
  font-size: 0.82rem;
  letter-spacing: 0.02em;
  color: var(--ink-faint);
}
</style>
