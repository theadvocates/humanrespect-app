<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Now apply it</p>
    <h2 class="display-medium">What changes when the intermediary is a government?</h2>
    <Divider />

    <p class="body-text-large">You just established that hiring someone to take, threaten, or coerce makes you morally responsible for the taking, the threatening, and the coercing. The intermediary doesn't absorb the moral weight.</p>

    <ScenarioBox label="The parallel">
      <p>When you vote for a politician who promises to tax your neighbor, regulate your neighbor's business, or imprison your neighbor for choices you disapprove of, you are hiring an agent to act on your behalf.</p>
      <p>The politician is the intermediary. The police are the enforcement mechanism. But you — the voter — are the principal. You authorized it.</p>
    </ScenarioBox>

    <p class="body-text">The mechanism is more complex. The chain of authority is longer. The language is more polished. But the structure is identical: one person authorizes force against another person's body, property, or time, carried out by an agent.</p>

    <ContentBlock variant="mirror">
      <p>In Experience 01, you saw that most people wouldn't personally take James's money but would vote for a politician to do it. Now the question is sharper: if hiring a private individual to take James's money makes you responsible for the theft, does hiring a public official to do the same thing make you any less responsible?</p>
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
