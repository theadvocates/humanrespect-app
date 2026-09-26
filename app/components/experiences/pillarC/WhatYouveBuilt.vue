<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">A personal inventory</p>
    <h2 class="display-medium">Think of something you worked hard to earn.</h2>
    <Divider />

    <p class="body-text-large">A home. A car. A savings account. A business. A tool you use every day. Hold it in your mind.</p>

    <p class="body-text">Now count the hours. Not the price tag. The mornings you got up when you didn't want to. The evenings you worked instead of resting. The years of discipline and patience that produced the money that became that thing.</p>

    <p class="body-text">When someone takes your property without consent, they consume hours of your past and diminish the possibilities of your future. A theft of property is a theft of life.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
