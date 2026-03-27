<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The world that gets built</p>
    <h2 class="display-medium">What happens when people trust that they can keep what they build?</h2>
    <Divider />

    <p class="body-text-large">Material security changes behavior in predictable ways. When people trust that their property is safe, they act differently than when they don't.</p>

    <div class="contrast">
      <div class="contrast-block insecure">
        <div class="contrast-label">When property is insecure</div>
        <p>People conceal wealth instead of investing it. They avoid long-term planning. They become less generous, restrict cooperation, and increase defensive behavior. Innovation slows because the rewards of risk can be seized.</p>
      </div>
      <div class="contrast-block secure">
        <div class="contrast-label">When property is respected</div>
        <p>People plan for the future. They invest, build, create, share, and take risks. They are more generous, because secure people give more freely. The result: innovation, prosperity, and deepening social trust.</p>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>Societies with stronger property norms consistently experience higher GDP, better environmental stewardship, stronger innovation, and deeper levels of trust. Material integrity is what makes societies wealthy, not a luxury they can afford once they already are.</p>
    </ContentBlock>

    <p class="body-text">The things you identified on the previous screen that you didn't build? In a society with stronger material integrity, more of those things would exist. More businesses. More investments. More generosity. More risk-taking. More creation. The cost of material insecurity is measured in the world that doesn't get built.</p>

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
.contrast-block { padding: 1.25rem 1.5rem; border-radius: var(--radius); }
.contrast-block p { margin: 0; font-size: 0.9rem; line-height: 1.7; }
.contrast-block.insecure { background: var(--concede-bg); border-left: 3px solid var(--concede-warm); }
.contrast-block.insecure p { color: var(--concede-warm); }
.contrast-block.secure { background: var(--insight-bg); border-left: 3px solid var(--insight-green); }
.contrast-block.secure p { color: var(--insight-green); }
.contrast-label { font-size: 0.68rem; letter-spacing: 0.1em; text-transform: uppercase; font-weight: 600; margin-bottom: 0.5rem; }
.insecure .contrast-label { color: var(--concede-warm); }
.secure .contrast-label { color: var(--insight-green); }
</style>
