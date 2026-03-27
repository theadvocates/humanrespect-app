<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">A personal inventory</p>
    <h2 class="display-medium">Think of something you worked hard to earn.</h2>
    <Divider />

    <p class="body-text-large">A home. A car. A savings account. A business. A tool you use every day. Hold it in your mind.</p>

    <p class="body-text">Now count the hours. Not the price tag. The mornings you got up when you didn't want to. The evenings you worked instead of resting. The years of discipline and patience that produced the money that became that thing.</p>

    <ScenarioBox label="The reframe">
      <p>That object is <strong>crystallized time</strong>. Your life converted into durable form. The chair required someone's hours. The dollar represents exchanged effort. The home represents years of mornings.</p>
      <p>Property bridges your past effort and your future possibilities. It stores what you've done so it can power what you'll do next.</p>
    </ScenarioBox>

    <p class="body-text">When someone takes your property without consent, they consume hours of your past and diminish the possibilities of your future. In a real sense, a theft of property is a theft of life.</p>

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
