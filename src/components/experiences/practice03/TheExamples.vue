<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">What it sounds like</p>
    <h2 class="display-medium">Two examples — one with a progressive, one with a conservative.</h2>
    <Divider />

    <ScenarioBox label="With a progressive friend">
      <p><em>"I care about poverty too. Genuinely. The question I keep coming back to is whether forcing people to fund programs through taxes actually solves it better than encouraging voluntary cooperation. Like, what if instead of taxing people to fund welfare, we made it really easy to give — and really hard for bureaucracies to waste it?"</em></p>
    </ScenarioBox>

    <ScenarioBox label="With a conservative friend">
      <p><em>"I agree that moral standards matter. I just wonder — does legislating morality actually make people more moral? Or does it just make them compliant while resentful? What if the most powerful way to spread good values is to live them and persuade others — instead of forcing them?"</em></p>
    </ScenarioBox>

    <ContentBlock variant="concession" label="What to expect">
      <p>Most people won't agree immediately. That's fine. You're not trying to convert them in one conversation. You're planting a question — force or persuasion? — that will come back to them every time they encounter a political issue. The seed grows on its own.</p>
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
