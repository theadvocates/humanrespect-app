<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="5" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">We don't end with an answer. We end with a question.</h2>
    <Divider />

    <ContentBlock variant="principle">
      <!-- eslint-disable-next-line vue/no-v-html -- content is authored in a local data file, never user input. Revisit if it ever comes from a CMS. -->
      <p v-html="obj.question"/>
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
const obj = computed(() => objections[journey.exp02?.chosenObjection] || objections['doesnt-scale'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
