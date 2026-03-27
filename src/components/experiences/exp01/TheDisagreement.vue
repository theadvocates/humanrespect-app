<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Start with what you know</p>
    <h2 class="display-medium">Think about the last real disagreement you had with someone you care about.</h2>
    <Divider />

    <p class="body-text-large">Not a trivial argument about where to eat. A genuine difference about something that mattered. Maybe it was about money, or how to raise a child, or a decision that would affect both of your lives. A moment where you were certain you were right and they were equally certain they were.</p>

    <p class="body-text">Hold that disagreement in your mind. Remember how it felt. Remember what was at stake.</p>

    <ScenarioBox label="What makes this worth examining">
      <p>You had a real conflict with a real person. You cared about the outcome. You believed you were right. And you had to decide how to handle it.</p>
    </ScenarioBox>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
