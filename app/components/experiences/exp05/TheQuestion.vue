<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="6" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The question you take with you</p>
    <h2 class="display-medium">What are you willing to authorize?</h2>
    <Divider />

    <p class="body-text-large">Every political position is an answer to this question. Every vote is an act of authorization.</p>

    <ContentBlock variant="principle">
      <p>If you would not personally walk up to your neighbor and take their money, threaten their freedom, or cage them for their choices, then voting for someone else to do it does not change the moral weight. It changes the distance.</p>
    </ContentBlock>

    <ContentBlock variant="concession" label="The question to carry">
      <p>Not guilt over past votes, and not a retreat from public life. One question, carried into every political decision from now on: "Am I willing to have someone forced to do this my way?" If yes, the principle already predicts the harm, whoever carries it out. If no, the other ways are the ones you already use: persuasion, exchange, voluntary association, and charity.</p>
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
