<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">What it sounds like</p>
    <h2 class="display-medium">Two examples — one with a progressive, one with a conservative.</h2>
    <Divider />

    <ScenarioBox label="With a progressive friend">
      <p><em>"I care about poverty too, genuinely. The question I keep coming back to is whether forcing people to fund programs through taxes actually works better than voluntary cooperation. What if, instead of taxing people to fund welfare, we made it really easy to give — and really hard to waste what's given?"</em></p>
    </ScenarioBox>

    <ScenarioBox label="With a conservative friend">
      <p><em>"I agree that moral standards matter. I just wonder — does legislating morality actually make people more moral? Or does it make them compliant, and resentful? What if the strongest way to spread good values is to live them and persuade others, rather than force them?"</em></p>
    </ScenarioBox>

    <ContentBlock variant="concession" label="What to expect">
      <p>Most people won't agree right away. That's fine. You're not converting anyone in one conversation. You're planting a question — force or persuasion? — that comes back to them every time a political issue does.</p>
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
