<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question you take with you</p>
    <h2 class="display-medium">Given what you know about how humans actually behave, which system would you design?</h2>
    <Divider />

    <p class="body-text-large">One where flawed people compete to control the machinery of force — and the losers live under the winners' rules.</p>

    <p class="body-text-large">Or one where flawed people compete to earn each other's trust — and no one has the authority to impose their will on everyone else.</p>

    <ContentBlock variant="principle">
      <p>The Philosophy of Human Respect is not a bet on human goodness. It is a system designed for human beings as they actually are — self-interested, imperfect, and responsive to incentives. It succeeds not by assuming the best in people, but by building a structure where even self-interest produces cooperation instead of exploitation.</p>
    </ContentBlock>

    <ContentBlock variant="concession" label="The honest acknowledgment">
      <p>Voluntary systems have failure modes too. Free riders. Information asymmetry. Coordination problems. The philosophy does not claim these disappear. It claims that a system where bad actors are limited by the people willing to associate with them produces better outcomes than a system where bad actors can seize the apparatus of legal force and direct it against everyone.</p>
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
