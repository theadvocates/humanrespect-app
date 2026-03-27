<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="7" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">The pattern has a name</p>
    <h2 class="display-medium">The Principle of Human Respect</h2>
    <Divider />
    <p class="body-text-large">Across every culture and era, a consistent pattern holds: human well-being is sensitive to how people treat each other. Specifically, it is sensitive to the presence or absence of force.</p>
    <ContentBlock variant="principle">
      <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
    </ContentBlock>
    <p class="body-text">This holds whether the force comes from a mugger, a dictator, a majority vote, or a well-intentioned policy. The mechanism doesn't change the effect.</p>
    <p class="body-text">And the inverse holds too. Wherever people interact through persuasion and voluntary cooperation — in friendships, in markets, in communities that choose to help each other — flourishing increases.</p>
    <p class="body-text">The thought experiment points toward a statement about cause and effect: <em>how</em> we pursue good outcomes matters as much as the outcomes themselves.</p>
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

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
