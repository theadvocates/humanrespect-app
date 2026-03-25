<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="9" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your instinct</p>
    <h2 class="display-medium">Would you personally walk into James's house, take $1,200 from his savings, and give it to Sarah?</h2>
    <p class="body-text" style="margin-top: 1rem;">Remember: Sarah genuinely needs it. James can afford it. The cause is compassionate.</p>
    <div class="choices">
      <ChoiceCard :selected="journey.exp01.personal === 'no'" @select="choose('no')">
        <template #label>No.</template>
        <template #detail>Taking someone's money without their permission is wrong — even for a good cause. I'd find another way to help Sarah.</template>
      </ChoiceCard>
      <ChoiceCard :selected="journey.exp01.personal === 'yes'" @select="choose('yes')">
        <template #label>Yes.</template>
        <template #detail>Sarah's need is urgent enough. If James won't help voluntarily, taking the money to save her family is justified.</template>
      </ChoiceCard>
    </div>
    <NavBar :can-go-back="true" :disable-continue="!journey.exp01.personal" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ChoiceCard from '@/components/shared/ChoiceCard.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'

const emit = defineEmits(['advance', 'back', 'choose'])
const journey = useJourneyStore()
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function choose(value) {
  emit('choose', { key: 'personal', value })
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.choices { margin: 2.5rem 0 1rem; }
</style>
