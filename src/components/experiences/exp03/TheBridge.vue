<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">What you've established</p>
    <h2 class="display-medium">Two discoveries, from your own reasoning.</h2>
    <Divider />

    <div class="discoveries">
      <div class="discovery">
        <span class="discovery-number">01</span>
        <div>
          <div class="discovery-title">The method</div>
          <p class="discovery-desc">You already choose persuasion over force in your closest relationships — because you know what force does to people. You learned this from a lifetime of experience.</p>
        </div>
      </div>
      <div class="discovery">
        <span class="discovery-number">02</span>
        <div>
          <div class="discovery-title">The evidence</div>
          <p class="discovery-desc">The best periods of your life had safety, autonomy, and opportunity present. The worst had one or more of those domains — body, resources, time — under threat or taken away.</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="principle">
      <p>Human flourishing reliably increases in environments of voluntary cooperation and reliably decreases in environments where coercion, violence, or involuntary loss of time or property occur.</p>
    </ContentBlock>

    <p class="body-text">This is a strong claim. You might agree with the pattern but question whether it applies as broadly as the philosophy suggests. You might think there are exceptions important enough to justify force — situations where the cost of coercion is worth the benefit it produces.</p>

    <p class="body-text">Good. The next experience takes your strongest objection seriously.</p>

    <NewsletterSignup
      variant="minimal"
      source="exp03_closing"
      headline="One idea per week, grounded in flourishing."
      description="A short email connecting the Philosophy of Human Respect to something happening in the world right now."
      button-text="Subscribe"
    />

    <JourneyNav current="exp03" />

    <p class="body-text" style="text-align: center; margin-top: 3rem; color: var(--ink-faint); font-style: italic;">The Philosophy of Human Respect — articulated by Chris J. Rufer</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.discoveries { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.5rem; }
.discovery { display: flex; gap: 1.25rem; align-items: flex-start; }
.discovery-number { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.discovery-title { font-family: var(--serif); font-size: 1.1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.25rem; }
.discovery-desc { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.65; margin: 0; }
</style>
