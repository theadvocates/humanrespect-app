<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your own experience</p>
    <h2 class="display-medium">Recall a time you felt physically unsafe.</h2>
    <Divider />
    <p class="body-text-large">Not necessarily violence — even the <em>credible possibility</em> of harm. A dark street. A threatening person. A moment where your body told you something was wrong.</p>
    <p class="body-text">You don't need to share the details. Just hold that memory and notice what happened to your thinking.</p>

    <ScenarioBox label="What your brain did">
      <p>When the amygdala senses threat, it triggers a cascade: cortisol floods the system, the prefrontal cortex — the part responsible for creativity, empathy, planning, and problem-solving — goes partially offline. Your world narrows to the immediate threat.</p>
      <p>This isn't weakness. It's biology. The nervous system is designed to prioritize survival over flourishing. But the cost is real: in that state, you cannot create, cooperate, plan, or connect. You can only react.</p>
    </ScenarioBox>

    <ContentBlock variant="principle">
      <p>This is why bodily safety isn't just one nice thing among many. It is the precondition for all other forms of flourishing. Without it, the brain literally cannot enter the states that support growth, creativity, trust, or meaning.</p>
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
