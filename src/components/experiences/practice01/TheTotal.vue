<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">What this reveals</p>
    <h2 class="display-medium">Every check mark is a place where you support using force against peaceful people.</h2>
    <Divider />

    <p class="body-text-large">This isn't meant to make you feel bad. It's meant to make the invisible <em>visible</em>. Most people don't think of these policies as "force" because the force is hidden behind bureaucratic language, payroll deductions, and the normalization of "that's just how things work."</p>

    <ContentBlock variant="mirror">
      <p>But behind every one of those policies is a simple reality: if someone refuses to comply, people with guns will eventually come to enforce it. That's what makes it force rather than cooperation. Not the intention behind it — the mechanism that backs it up.</p>
    </ContentBlock>

    <p class="body-text">The purpose of this exercise isn't to demand you oppose everything you checked. It's to see your political footprint clearly — the total amount of coercion you currently support — so you can make conscious choices about where you want it to shrink.</p>

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
