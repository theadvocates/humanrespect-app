<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">What honesty requires</p>
    <h2 class="display-medium">What the philosophy can't claim.</h2>
    <Divider />
    <p class="body-text-large">A philosophy that only gives you the strong parts of its argument and hides the difficult parts isn't trustworthy. So here's what intellectual honesty requires us to say.</p>
    <ContentBlock variant="concession" label="The honest concession">
      <p v-html="obj.concession"></p>
    </ContentBlock>
    <p class="body-text">You may find this concession sufficient reason to reject the philosophy entirely. That's your right, and it's the kind of decision the philosophy itself asks you to make — freely, without coercion.</p>
    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from './objectionData.js'

defineEmits(['advance', 'back'])
const journey = useJourneyStore()
const obj = computed(() => objections[journey.exp02.chosenObjection] || objections['social-contract'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
