<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question behind the footprint</p>
    <h2 class="display-medium">For each area — whether you support it or not — ask one question.</h2>
    <Divider />

    <p class="body-text-large">Could this be done without force? Could the same goal be achieved through persuasion, voluntary funding, or cooperative action?</p>

    <p class="body-text">For some areas, the answer might be "I don't see how." That's honest. Not every problem has an obvious voluntary solution. But notice the difference between "it can't be done voluntarily" and "I haven't seen how it could be done voluntarily." Those are very different claims.</p>

    <ContentBlock variant="insight">
      <p>People once said the same thing about mail delivery, roads, education, and disaster relief. All of these now have functioning voluntary alternatives alongside or instead of government versions. The category of "this requires force" has been shrinking for centuries.</p>
    </ContentBlock>

    <ContentBlock variant="principle">
      <p>The philosophy doesn't ask you to oppose everything on your list. It asks you to hold each one up to the light and ask: is force truly necessary here, or have I simply never considered the alternative?</p>
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
