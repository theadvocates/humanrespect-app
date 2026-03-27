<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">The same question, differently</p>
    <h2 class="display-medium">Now imagine the same situation — but at the scale of a city.</h2>
    <ScenarioBox label="The policy">
      <p>Thousands of people like Sarah need help. A politician proposes a new tax on people like James — taking a portion of their income to fund housing assistance for families in crisis.</p>
      <p>Same money. Same cause. Same people. The only thing that changes is <em>who does the taking</em>.</p>
    </ScenarioBox>
    <div class="choices">
      <ChoiceCard :selected="journey.exp01.political === 'yes'" @select="choose('yes')">
        <template #label>Yes, I'd support this policy.</template>
        <template #detail>This is what democratic government is for — pooling resources to help people who need it.</template>
      </ChoiceCard>
      <ChoiceCard :selected="journey.exp01.political === 'no'" @select="choose('no')">
        <template #label>No, I'd oppose this policy.</template>
        <template #detail>Even through government, taking someone's money without their individual consent is wrong. We should find voluntary ways to help.</template>
      </ChoiceCard>
    </div>
    <NavBar :can-go-back="true" :disable-continue="!journey.exp01.political" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import ChoiceCard from '@/components/shared/ChoiceCard.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'

const emit = defineEmits(['advance', 'back', 'choose'])
const journey = useJourneyStore()
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function choose(value) {
  emit('choose', { key: 'political', value })
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.choices { margin: 2.5rem 0 1rem; }
</style>
