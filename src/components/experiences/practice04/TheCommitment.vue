<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The commitment</p>
    <h2 class="display-medium">Six more days.</h2>
    <Divider />
    <p class="body-text-large">Before bed each night this week, take 60 seconds to notice one moment where force and persuasion were in play. You don't need to write it down (though it helps). You just need to notice.</p>

    <ContentBlock variant="insight">
      <p>By the end of seven days, you'll see the force/persuasion question everywhere — in conversations, in the news, in your own impulses. That's not the philosophy talking. That's your own observation, accumulated over a week of paying attention.</p>
    </ContentBlock>

    <ContentBlock variant="principle">
      <p>The Philosophy of Human Respect isn't something you adopt in a moment. It's something you discover gradually, as you notice the pattern between force and flourishing in your own daily life.</p>
    </ContentBlock>

    <div class="paths" style="margin-top: 2.5rem;">
      <p class="caption" style="margin-bottom: 1rem;">Continue practicing</p>
      <PathCard :to="{ name: 'practice05' }">
        <template #title>Design a Voluntary Solution</template>
        <template #desc>Pick a real problem in your community and solve it without force.</template>
      </PathCard>
      <PathCard :to="{ name: 'practice01' }">
        <template #title>Your Political Footprint</template>
        <template #desc>Map the coercion you currently support.</template>
      </PathCard>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import PathCard from '@/components/shared/PathCard.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
