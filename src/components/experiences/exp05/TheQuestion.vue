<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question you take with you</p>
    <h2 class="display-medium">What are you willing to authorize?</h2>
    <Divider />

    <p class="body-text-large">Every political position is an answer to this question. Every vote is an act of authorization. The philosophy asks you to see it clearly and choose deliberately.</p>

    <ContentBlock variant="principle">
      <p>If you would not personally walk up to your neighbor and take their money, threaten their freedom, or cage them for their choices, then voting for someone else to do it does not change the moral weight. It changes the distance.</p>
    </ContentBlock>

    <ContentBlock variant="concession" label="What the philosophy does not ask">
      <p>It does not ask you to stop participating in democracy. It does not ask you to feel guilty for past votes. It asks you to carry one question into every political decision you make from now on: "Am I willing to authorize force against a peaceful person for this?" If the answer is yes, own it with open eyes. If the answer is no, find another way.</p>
    </ContentBlock>

    <NewsletterSignup variant="minimal" source="exp05_closing" headline="One question per week, applied to real policy." description="A short email translating a real political proposal into the force it authorizes. No spin. Just the chain of authority, made visible." button-text="Subscribe" />
    <JourneyNav current="exp05" />
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
<style scoped>.screen-inner { padding: 0 0.5rem; }</style>
