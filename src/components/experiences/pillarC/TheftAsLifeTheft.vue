<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">What theft really is</p>
    <h2 class="display-medium">Theft destroys the bridge between past effort and future flourishing.</h2>
    <Divider />

    <p class="body-text-large">When people think of theft, they imagine the loss of things. But the real harm occurs deeper.</p>

    <p class="body-text">Theft sends a devastating message to the victim: the time you spent working doesn't matter. Your plans for tomorrow don't matter. Your autonomy over your own life doesn't matter.</p>

    <ContentBlock variant="mirror">
      <p>This is why even small acts of theft feel violating — out of proportion to the material value lost. It's not about the thing. It's about the implicit claim that someone else has a right to the hours of your life you invested in earning it.</p>
    </ContentBlock>

    <p class="body-text">And this is why, in every culture across history, theft has been condemned — not because societies coincidentally agree, but because the violation of material integrity predictably disrupts flourishing for individuals and communities alike.</p>

    <ContentBlock variant="insight">
      <p>Property as crystallized time gives us an <em>existential</em> grounding for why theft is wrong — not a legalistic or ideological one. Taking someone's property without consent is consuming their past and diminishing their future. It is, in a real sense, a theft of life.</p>
    </ContentBlock>

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
