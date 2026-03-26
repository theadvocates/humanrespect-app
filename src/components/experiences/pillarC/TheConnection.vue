<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The connection you haven't made</p>
    <h2 class="display-medium">Think of something you worked hard to earn.</h2>
    <Divider />

    <p class="body-text-large">A home. A car. A savings account. A business. A tool you use every day. Hold it in your mind.</p>

    <p class="body-text">Now ask yourself: how many <em>hours</em> of your life did that thing cost? Not the price tag — the hours. The mornings you got up when you didn't want to. The evenings you worked instead of resting. The years of discipline, patience, and effort that produced the money that became that thing.</p>

    <ScenarioBox label="The reframe">
      <p>That object isn't just a possession. It's <strong>crystallized time</strong> — your life converted into durable form. The chair required someone's hours. The dollar represents exchanged effort. The home represents years of mornings.</p>
      <p>Property is the bridge between your past effort and your future possibilities. It stores what you've done so it can power what you'll do next.</p>
    </ScenarioBox>

    <ContentBlock variant="principle">
      <p>This is why property isn't about materialism. It's about respecting the time — the irreplaceable life-hours — that someone invested to create, earn, or build what they have.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
