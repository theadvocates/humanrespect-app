<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question behind the footprint</p>
    <h2 class="display-medium">For each area — whether you support it or not — ask one question.</h2>
    <Divider />

    <p class="body-text-large">Could this be done without force? Could the same goal be reached through persuasion, voluntary funding, or people working together?</p>

    <p class="body-text">For some, the answer will be "I don't see how." Voluntary solutions aren't designed in advance. They emerge from people who each know something a planner can't. And a tax-funded version crowds out the alternatives, because everyone is already paying for it. Their absence is evidence of crowding out, not impossibility.</p>

    <ContentBlock variant="insight">
      <p>Private carriers deliver packages worldwide. Private roads exist. Private schools and homeschooling educate millions of children. Charities carry much of disaster relief. Each often beats the government version on cost and service, which is why people choose it while still paying for both.</p>
    </ContentBlock>

    <ContentBlock variant="principle">
      <p>Each item on your list costs happiness, harmony, and prosperity. The question isn't whether the goal is good. It's what the force is costing, and what the voluntary version would be.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
