<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Now scale it up</p>
    <h2 class="display-medium">When millions of people disagree about healthcare, education, drug policy, and immigration, the system we've built to resolve those disagreements uses force.</h2>
    <Divider />

    <p class="body-text-large">Pass a law. Compel compliance. Fine or imprison those who refuse. The people on the receiving end of that force are human beings — every bit as complex, as dignified, and as resentful of being overridden as the person you were thinking about a moment ago.</p>

    <ContentBlock variant="mirror">
      <p>In your personal life, you chose persuasion because you understand what force does to people and relationships. In collective life, you participate in a system that uses force on millions of people who never agreed to it — and expects cooperation in return.</p>
    </ContentBlock>

    <p class="body-text">The disagreements are real. The stakes are real. The people who disagree with you about policy are as convinced they're right as you are. And the method you already know works best in your personal life — persuasion, compromise, voluntary cooperation — is the one method the political system doesn't use.</p>

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
