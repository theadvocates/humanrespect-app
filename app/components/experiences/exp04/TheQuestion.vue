<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question you take with you</p>
    <h2 class="display-medium">Given what you know about how humans actually behave, which system would you design?</h2>
    <Divider />

    <p class="body-text-large">One where flawed people compete to control the machinery of force — and the losers live under the winners' rules.</p>

    <p class="body-text-large">Or one where flawed people get what they want only by serving each other — where reputation, contracts, and profit and loss make honesty pay, and no one can impose their will on everyone else.</p>

    <ContentBlock variant="principle">
      <p>The Philosophy of Human Respect is not a bet on human goodness. It is a system designed for human beings as they actually are — self-interested, imperfect, and responsive to incentives. It succeeds not by assuming the best in people, but by building a structure where even self-interest produces cooperation instead of exploitation.</p>
    </ContentBlock>

    <ContentBlock variant="concession" label="The standard objections">
      <p>Free riders, information asymmetry, coordination problems. Voluntary systems answer each without force: assurance contracts, clubs, and bundling; reputation, warranties, and brands; norms and standards bodies. Coercive systems have all three in worse form: voters who free-ride on everyone else's attention, officials who know less about your life than you do, and coordination by decree with no way to learn it is wrong.</p>
    </ContentBlock>

    <NewsletterSignup variant="minimal" source="exp04_closing" headline="One question per week, applied to the real world." description="A short email examining the incentive structures behind real policies and institutions." button-text="Subscribe" />
    <JourneyNav current="exp04" />
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
