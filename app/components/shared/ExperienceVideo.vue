<template>
  <!-- An experience as a short narrated video, offered beside the interactive
       version for people who would rather watch. The files are served from
       /public/videos and made in the explainer-videos repository. Any music
       credit a licence requires is on the video's own end card. -->
  <figure class="xv">
    <figcaption v-if="$slots.default" class="xv-caption"><slot /></figcaption>
    <video
      class="xv-video"
      controls
      playsinline
      preload="none"
      :poster="`/videos/${file}.jpg`"
      :aria-label="label"
      @play="onPlay"
      @ended="$emit('ended')"
    >
      <source :src="`/videos/${file}.mp4`" type="video/mp4">
      <track kind="captions" :src="`/videos/${file}.vtt`" srclang="en" label="English" default>
    </video>
  </figure>
</template>

<script setup>
const props = defineProps({
  /** The file stem in /public/videos, e.g. "exp-the-question". */
  file: { type: String, required: true },
  label: { type: String, required: true }
})
const emit = defineEmits(['play', 'ended'])

// A pause and resume is one viewing, not two.
let played = false
function onPlay() {
  if (played) return
  played = true
  emit('play', props.file)
}
</script>

<style scoped>
.xv { margin: 0; display: grid; gap: 0.8rem; }
.xv-video {
  display: block;
  width: 100%;
  aspect-ratio: 16 / 9;
  border-radius: 10px;
  background: #17171F;
  border: 1px solid rgba(240, 235, 227, 0.12);
}
.xv-caption {
  font-family: var(--sans);
  font-size: 0.82rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: rgba(240, 235, 227, 0.55);
}
</style>
