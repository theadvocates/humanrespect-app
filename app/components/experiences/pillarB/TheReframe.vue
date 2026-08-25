<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Seeing it differently</p>
    <h2 class="display-medium">Property is time made physical.</h2>
    <Divider />

    <p class="body-text-large">Every object you own, every dollar you've saved, every asset you've built represents something deeper than its material form. It represents the <em>hours of your life</em> you exchanged to acquire it.</p>

    <ScenarioBox label="Consider">
      <p>A chair required someone's hours of labor. A dollar represents exchanged effort. A home represents years of saving — thousands of mornings getting up and going to work. A business represents decades of risk, creativity, and discipline.</p>
      <p>These aren't just things. They're <strong>crystallized time</strong> — life converted into durable form.</p>
    </ScenarioBox>

    <ContentBlock variant="principle">
      <p>When someone takes your property without consent, they aren't just taking a thing. They're consuming hours of your past — time you invested, time you can never get back — and diminishing the possibilities of your future.</p>
    </ContentBlock>

    <p class="body-text">This reframes the entire question of property. Your resources are the physical form of your irreplaceable life-hours. To respect someone's property is to respect the time they spent earning it — which is to respect their life itself.</p>

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

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
