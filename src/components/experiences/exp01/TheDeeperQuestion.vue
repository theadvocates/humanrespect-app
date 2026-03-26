<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">The deeper question</p>
    <h2 class="display-medium">{{ hasGap ? 'Why do we make this exception?' : 'Most people hold two moral codes without realizing it.' }}</h2>
    <p class="body-text-large">{{ hasGap
      ? "You wouldn't personally take James's money. But when a politician does the same thing and calls it taxation, it feels different. Why?"
      : "They would never personally take a neighbor's money — but they routinely vote for governments to take their neighbors' money for causes they believe in. Why?"
    }}</p>
    <p class="body-text">We've been taught that democratic authorization transforms the act. That voting for something makes it fundamentally different from doing it yourself. That the collective can do what the individual cannot.</p>
    <p class="body-text">But the Philosophy of Human Respect observes that the money still leaves James's pocket. He still didn't choose to give it. And his capacity to flourish still decreases — regardless of who authorized the taking.</p>
    <ContentBlock variant="principle">
      <p>The philosophy holds that the effect on the person being acted upon doesn't change based on who authorized the action. If this is true, the implications are profound.</p>
    </ContentBlock>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const hasGap = computed(() => journey.mirrorPattern === 'gap')
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
