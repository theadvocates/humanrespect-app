<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Taking your objection seriously</p>
    <h2 class="display-medium">{{ obj.title }}</h2>
    <Divider />
    <p class="body-text-large">Before responding, we need to state your objection in its strongest form. Not a caricature. Not a straw man. The real argument, as a thoughtful person would make it.</p>
    <ContentBlock variant="mirror" label="Your objection, at its strongest">
      <p>{{ obj.steelman }}</p>
    </ContentBlock>
    <p class="body-text">If this doesn't capture your position well enough, that's fair — these are complex ideas. But this is the version we're going to engage with, because this is the version that deserves a serious answer.</p>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const obj = computed(() => objections[journey.exp02.chosenObjection] || objections['social-contract'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
