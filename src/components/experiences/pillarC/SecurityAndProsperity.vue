<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The quiet engine</p>
    <h2 class="display-medium">Material security is what makes everything else possible.</h2>
    <Divider />

    <p class="body-text-large">When people can't trust that their possessions will remain theirs, something predictable happens.</p>

    <div class="contrast">
      <div class="contrast-block insecure">
        <div class="contrast-label">When property is insecure</div>
        <p>People conceal wealth instead of investing it. They avoid long-term planning. They become less generous, restrict cooperation, reduce innovation, and increase defensive behavior. The result: economic stagnation, social fragmentation, and the breakdown of mutual trust.</p>
      </div>
      <div class="contrast-block secure">
        <div class="contrast-label">When property is respected</div>
        <p>People plan for the future. They invest, build, create, share, and take risks. They're more generous — because secure people give more freely than insecure ones. The result: innovation, prosperity, and deepening social trust.</p>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Economists have documented this consistently: societies with stronger property norms experience higher GDP, better environmental stewardship, stronger innovation, and deeper levels of trust. Material integrity is not a luxury of wealthy societies — it is what <em>makes</em> societies wealthy.</p>
    </ContentBlock>

    <p class="body-text">Material security is the quiet engine of flourishing. Most people don't think about it — like the foundation of a house, it's invisible when it's working. But remove it, and everything built on top collapses.</p>

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
.contrast { margin: 2rem 0; display: flex; flex-direction: column; gap: 1rem; }
.contrast-block { padding: 1.5rem; border-radius: var(--radius); border: 1.5px solid var(--border-subtle); }
.contrast-block.insecure { background: var(--concede-bg); border-color: var(--concede-warm); }
.contrast-block.secure { background: var(--insight-bg); border-color: var(--insight-green); }
.contrast-label { font-family: var(--serif); font-size: 1rem; font-weight: 500; margin-bottom: 0.5rem; }
.insecure .contrast-label { color: var(--concede-warm); }
.secure .contrast-label { color: var(--insight-green); }
.contrast-block p { font-size: 0.9rem; color: var(--ink-soft); line-height: 1.7; margin: 0; }
@media (max-width: 480px) { .contrast-block { padding: 1.25rem; } }
</style>
