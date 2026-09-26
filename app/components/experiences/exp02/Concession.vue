<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="4" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The hard part</p>
    <h2 class="display-medium">What is hard.</h2>
    <Divider />

    <p class="body-text-large">Not an exception to the principle. The part that takes work.</p>

    <ContentBlock variant="concession" :label="obj.concessionLabel">
      <!-- eslint-disable-next-line vue/no-v-html -- content is authored in a local data file, never user input. Revisit if it ever comes from a CMS. -->
      <p v-html="obj.concession"/>
    </ContentBlock>

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
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const obj = computed(() => objections[journey.exp02?.chosenObjection] || objections['doesnt-scale'])
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
