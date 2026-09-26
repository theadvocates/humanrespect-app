<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">What it sounds like</p>
    <h2 class="display-medium">Two examples — one with a progressive, one with a conservative.</h2>
    <Divider />

    <ScenarioBox label="With a progressive friend">
      <p><em>"I care about poverty too. But decades of spending have barely moved the poverty rate, and the programs punish people for earning more: cross an income line and the help vanishes. The giving that used to do this work got crowded out. What if we made it easy to give and hard to waste what's given?"</em></p>
    </ScenarioBox>

    <ScenarioBox label="With a conservative friend">
      <p><em>"I agree that moral standards matter. But Prohibition didn't make America virtuous; it made bootleggers rich and turned drinkers into criminals. The drug war did the same. Laws make people compliant or resentful, not good. Good values spread when people live them and persuade others."</em></p>
    </ScenarioBox>

    <ContentBlock variant="concession" label="What to expect">
      <p>You're not converting anyone in one conversation. You're planting a question — force or persuasion? — that comes back to them every time a political issue does.</p>
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
