<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your strongest pushback</p>
    <h2 class="display-medium">Which of these is closest to what you're thinking?</h2>
    <p class="body-text" style="margin-top: 1rem;">Pick the one that feels most true to you — the objection you'd make if we were having this conversation in person.</p>
    <div class="choices">
      <ChoiceCard
        :selected="journey.exp02.chosenObjection === 'social-contract'"
        @select="choose('social-contract')"
      >
        <template #label>"I consented to taxation by living in a democratic society."</template>
        <template #detail>It's not like theft — I agreed to this by participating in the system.</template>
      </ChoiceCard>
      <ChoiceCard
        :selected="journey.exp02.chosenObjection === 'people-will-die'"
        @select="choose('people-will-die')"
      >
        <template #label>"Without taxes, people will die."</template>
        <template #detail>Some things are too important to leave to voluntary charity.</template>
      </ChoiceCard>
      <ChoiceCard
        :selected="journey.exp02.chosenObjection === 'democracy'"
        @select="choose('democracy')"
      >
        <template #label>"A democratic vote makes it legitimate."</template>
        <template #detail>Collective self-governance is fundamentally different from personal theft.</template>
      </ChoiceCard>
      <ChoiceCard
        :selected="journey.exp02.chosenObjection === 'public-goods'"
        @select="choose('public-goods')"
      >
        <template #label>"Some things can't be funded voluntarily."</template>
        <template #detail>Roads, courts, defense — the free rider problem is real.</template>
      </ChoiceCard>
    </div>
    <NavBar
      :can-go-back="true"
      :disable-continue="!journey.exp02.chosenObjection"
      @back="$emit('back')"
      @continue="$emit('advance')"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import ChoiceCard from '@/components/shared/ChoiceCard.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'

const emit = defineEmits(['advance', 'back', 'choose-objection'])
const journey = useJourneyStore()
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function choose(key) {
  emit('choose-objection', key)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.choices { margin: 2rem 0 1rem; }
</style>
