<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">The starting point</p>
    <h2 class="display-medium">Every person you've ever met shares something fundamental with you.</h2>
    <Divider />
    <p class="body-text-large">Your closest friend. Your political opponent. The stranger you passed on the street. Every one of them woke up this morning trying to build a life that works — seeking some version of happiness, security, and meaning.</p>
    <p class="body-text">This is observation, not sentiment. The universal human drive to flourish is as real and consistent as any pattern in nature. Everything that follows builds on this single, shared foundation.</p>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
