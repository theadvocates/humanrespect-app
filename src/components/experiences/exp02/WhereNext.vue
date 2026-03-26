<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">You examined one objection. There are others.</h2>
    <Divider />
    <p class="body-text-large">Each objection gets the same treatment — steelmanned, responded to, conceded where honesty requires.</p>

    <div style="margin-top: 2rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore another objection</p>
      <PathCard v-for="key in otherObjections" :key="key" href="#" @click.prevent="$emit('restart-with', key)">
        <template #title>{{ allObjections[key].title }}</template>
        <template #desc>Explore this objection with the same honesty.</template>
      </PathCard>
    </div>

    <JourneyNav current="exp02" next-label="Or continue your journey" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import PathCard from '@/components/shared/PathCard.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections as allObjections } from './objectionData.js'

defineEmits(['restart-with'])
const journey = useJourneyStore()
const otherObjections = computed(() => Object.keys(allObjections).filter(k => k !== journey.exp02.chosenObjection))
const el = ref(null)
onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  journey.completeExp02(journey.exp02.chosenObjection, null)
})
</script>

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
