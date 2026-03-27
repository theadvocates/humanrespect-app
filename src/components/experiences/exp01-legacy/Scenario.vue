<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">A thought experiment</p>
    <h2 class="display-medium">Imagine this.</h2>
    <ScenarioBox label="The situation">
      <p>Your neighbor <strong>Sarah</strong> is a single mother who just lost her job. She can't make rent this month. Her kids might go hungry.</p>
      <p>You want to help. Everyone on your street wants to help. That's not the question.</p>
      <p>The question is <em>how</em>.</p>
    </ScenarioBox>
    <p class="body-text">You know that another neighbor, <strong>James</strong>, has the money. He could easily cover Sarah's rent without any real hardship to himself. But he hasn't offered.</p>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
