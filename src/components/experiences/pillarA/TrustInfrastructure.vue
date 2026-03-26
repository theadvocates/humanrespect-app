<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The invisible infrastructure</p>
    <h2 class="display-medium">Trust is the most valuable thing a society produces.</h2>
    <Divider />

    <p class="body-text-large">Trust is invisible — like oxygen. You don't notice it until it's gone. But every exchange, relationship, agreement, and institution depends on it.</p>

    <p class="body-text">In high-trust environments, people share openly, communities self-organize, social innovation accelerates, conflict shrinks, and prosperity becomes possible. In low-trust environments, every interaction carries friction — suspicion, verification, protection, litigation.</p>

    <ContentBlock variant="insight">
      <p>Trust reduces the <em>cost</em> of cooperation. When you trust the people around you, collaboration is effortless. When you don't, every joint action requires contracts, enforcement, surveillance, and overhead. This is why high-trust societies are wealthier — not because they have more resources, but because cooperation is cheaper.</p>
    </ContentBlock>

    <p class="body-text">And trust cannot coexist with violence. A single act of aggression can destroy relationships, families, neighborhoods, or entire communities. Violence doesn't just break bones — it breaks the invisible infrastructure that makes cooperation possible.</p>

    <ContentBlock variant="principle">
      <p>The absence of violence is not a neutral state. It is a positive good — the precondition for curiosity, play, experimentation, growth, and the pursuit of a meaningful life. Bodily integrity is not merely moral. It is generative. It produces possibilities.</p>
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
