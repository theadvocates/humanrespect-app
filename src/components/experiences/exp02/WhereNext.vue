<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="7" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Where this leads</p>
    <h2 class="display-medium">You examined one objection. There are others.</h2>
    <Divider />
    <p class="body-text-large">Each objection gets the same treatment — steelmanned, responded to, conceded where honesty requires.</p>

    <div v-if="unexploredObjections.length" style="margin-top: 2rem;">
      <p class="caption" style="margin-bottom: 1rem;">Explore another objection</p>
      <PathCard v-for="key in unexploredObjections" :key="key" href="#" @click.prevent="$emit('restart-with', key)">
        <template #title>{{ allObjections[key].title }}</template>
        <template #desc>Explore this objection with the same honesty.</template>
      </PathCard>
    </div>

    <div v-if="exploredObjections.length" style="margin-top: 1.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Already explored</p>
      <PathCard v-for="key in exploredObjections" :key="key" href="#" :completed="true" @click.prevent="$emit('restart-with', key)">
        <template #title>{{ allObjections[key].title }}</template>
        <template #desc>Revisit this objection.</template>
      </PathCard>
    </div>

    <div v-if="allExplored" style="margin-top: 2rem;">
      <ContentBlock variant="insight">
        <p>You've explored all four objections. You've seen each one steelmanned, responded to, and honestly conceded. That's rare — most people stop at the first one that confirms their existing view.</p>
      </ContentBlock>
    </div>

    <JourneyNav current="exp02" next-label="Continue your journey" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections as allObjections } from './objectionData.js'

defineEmits(['restart-with'])
const journey = useJourneyStore()

const allKeys = Object.keys(allObjections)

const unexploredObjections = computed(() =>
  allKeys.filter(k => !journey.exp02.exploredObjections.includes(k))
)

const exploredObjections = computed(() =>
  allKeys.filter(k => journey.exp02.exploredObjections.includes(k))
)

const allExplored = computed(() =>
  allKeys.every(k => journey.exp02.exploredObjections.includes(k))
)

const el = ref(null)
onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
  journey.completeExp02(journey.exp02.chosenObjection, null)
})
</script>

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
