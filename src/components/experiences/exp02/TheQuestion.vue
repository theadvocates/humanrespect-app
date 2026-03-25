<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question that remains</p>
    <h2 class="display-medium">We don't end with an answer. We end with a question.</h2>
    <Divider />
    <p class="body-text-large">You came in with an objection. You've seen it taken seriously, responded to, and the limits of that response honestly acknowledged. Now there's a question left.</p>
    <ContentBlock variant="principle">
      <p v-html="obj.question"></p>
    </ContentBlock>
    <p class="body-text">This isn't rhetorical. It's a question worth sitting with — maybe for a few days. The Philosophy of Human Respect doesn't ask you to accept it today. It asks you to carry the question and see if the world starts looking different.</p>
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
