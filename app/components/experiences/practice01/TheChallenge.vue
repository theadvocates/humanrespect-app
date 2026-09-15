<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question behind the footprint</p>
    <h2 class="display-medium">For each area — whether you support it or not — ask one question.</h2>
    <Divider />

    <p class="body-text-large">Could this be done without force? Could the same goal be reached through persuasion, voluntary funding, or people working together?</p>

    <p class="body-text">For some, the honest answer is "I don't see how." Not every problem has an obvious voluntary solution. But "it can't be done without force" and "I haven't seen it done without force" are different claims.</p>

    <ContentBlock variant="insight">
      <p>Private carriers deliver packages worldwide. Private toll roads and neighborhood roads exist. Private schools and homeschooling educate millions of children. Charities carry much of disaster relief. Each works alongside a government version that people once assumed was the only way.</p>
    </ContentBlock>

    <ContentBlock variant="principle">
      <p>The philosophy doesn't ask you to oppose everything on your list. It asks you to hold each one up to the light and ask: is force really necessary here, or have I just never looked for the alternative?</p>
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
