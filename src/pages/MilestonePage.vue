<template>
  <div class="page">
    <div class="page-container stagger" ref="el">

      <div class="milestone-badge">Foundation complete</div>

      <h1 class="display-large" style="margin-top: 1rem; text-align: center;">
        You've built the framework.
      </h1>

      <Divider :centered="true" />

      <p class="body-text-large" style="text-align: center; max-width: 520px; margin: 1.5rem auto 0;">
        Three experiences. Three discoveries. A foundation for seeing every political question differently.
      </p>

      <div class="discoveries">
        <div class="discovery">
          <div class="discovery-num">01</div>
          <div class="discovery-content">
            <div class="discovery-title">The gap</div>
            <p class="discovery-desc" v-if="journey.mirrorPattern === 'gap'">You hold one moral standard for personal life and a different one for politics. Most people do. Now you've seen it.</p>
            <p class="discovery-desc" v-else-if="journey.mirrorPattern === 'consistent-voluntary'">You apply the same moral standard to personal and political life. You're already living by the principle most people haven't noticed.</p>
            <p class="discovery-desc" v-else>You examined your own moral reasoning and found a pattern worth understanding.</p>
          </div>
        </div>

        <div class="discovery">
          <div class="discovery-num">02</div>
          <div class="discovery-content">
            <div class="discovery-title">The objection</div>
            <p class="discovery-desc" v-if="journey.exp02.chosenObjection">You chose "{{ objectionTitle }}" and saw it steelmanned, responded to, and honestly conceded.</p>
            <p class="discovery-desc" v-else>You tested the philosophy against your strongest objection.</p>
          </div>
        </div>

        <div class="discovery">
          <div class="discovery-num">03</div>
          <div class="discovery-content">
            <div class="discovery-title">The grounding</div>
            <p class="discovery-desc">You traced the principle through your own life and found that flourishing tracks with the three domains: body, resources, and time.</p>
          </div>
        </div>
      </div>

      <div style="margin-top: 3rem;">
        <h2 class="display-medium" style="text-align: center;">What the philosophy asks of you.</h2>
        <Divider :centered="true" />

        <ContentBlock variant="principle">
          <p>Not agreement. Not conversion. Not a political identity. Just a question you carry with you: in this situation, am I reaching for force or persuasion? And could the outcome be better if I chose differently?</p>
        </ContentBlock>
      </div>

      <div style="margin-top: 3rem;">
        <h2 class="display-medium" style="text-align: center;">Three paths forward.</h2>
        <Divider :centered="true" />

        <p class="body-text">The foundation is complete. From here, the philosophy opens up in three directions.</p>

        <div class="path-section">
          <div class="path-label">Arguments</div>
          <p class="path-desc">Standalone arguments that deepen the case. Why human nature is the argument <em>for</em> the philosophy. Why you bear moral responsibility for the force you authorize.</p>
        </div>

        <div class="path-section">
          <div class="path-label">Pillars</div>
          <p class="path-desc">The three domains of human integrity explored in depth, plus the method question and the evidence for cooperation.</p>
        </div>

        <div class="path-section">
          <div class="path-label">Practices</div>
          <p class="path-desc">Apply the philosophy to your actual life. Map your political footprint, practice persuasion, design voluntary solutions.</p>
        </div>
      </div>

      <JourneyNav current="milestone" next-label="Continue your journey" />

      <NewsletterSignup
        source="milestone"
        headline="The questions don't stop here."
        description="One short email per week applying the Philosophy of Human Respect to a real situation."
        success-message="You're in. The first question arrives this week."
      />

    </div>

    <footer class="page-footer">
      <div class="footer-inner">
        <div class="footer-left">Human Respect</div>
        <div class="footer-right">
          <router-link to="/about" class="footer-link">About</router-link>
          <router-link to="/privacy" class="footer-link">Privacy</router-link>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import JourneyNav from '@/components/shared/JourneyNav.vue'
import NewsletterSignup from '@/components/shared/NewsletterSignup.vue'
import { useJourneyStore } from '@/stores/journey'
import { objections } from '@/components/experiences/exp02/objectionData.js'

const journey = useJourneyStore()
const el = ref(null)

onMounted(() => {
  document.body.classList.remove('dark-mode')
  requestAnimationFrame(() => el.value?.classList.add('animate'))
})

const objectionTitle = computed(() => {
  const key = journey.exp02.chosenObjection
  return key && objections[key] ? objections[key].title : ''
})
</script>

<style scoped>
.page { background: var(--paper); min-height: 100vh; }
.page-container { max-width: 640px; margin: 0 auto; padding: 5rem 1.5rem 4rem; }

.milestone-badge { text-align: center; font-size: 0.68rem; letter-spacing: 0.12em; text-transform: uppercase; color: var(--insight-green); background: var(--insight-bg); display: block; padding: 0.35rem 1rem; border-radius: 100px; font-weight: 600; width: fit-content; margin: 0 auto; }

.discoveries { margin: 3rem 0; display: flex; flex-direction: column; gap: 1.5rem; }
.discovery { display: flex; gap: 1.25rem; align-items: flex-start; }
.discovery-num { flex-shrink: 0; font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: var(--ochre); margin-top: 0.15rem; }
.discovery-content {}
.discovery-title { font-family: var(--serif); font-size: 1.1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.25rem; }
.discovery-desc { font-size: 0.88rem; color: var(--ink-muted); line-height: 1.65; margin: 0; }

.path-section { margin-top: 1.25rem; padding: 1rem 1.25rem; background: var(--cream); border-radius: var(--radius); border: 1px solid var(--border-subtle); }
.path-label { font-family: var(--serif); font-size: 0.95rem; font-weight: 500; color: var(--ink); margin-bottom: 0.25rem; }
.path-desc { font-size: 0.85rem; color: var(--ink-muted); line-height: 1.6; margin: 0; }

.page-footer { padding: 3rem 1.5rem; background: var(--ink); display: flex; justify-content: center; }
.footer-inner { max-width: 640px; width: 100%; display: flex; justify-content: space-between; align-items: center; }
.footer-left { font-family: var(--serif); font-size: 0.85rem; font-weight: 400; color: rgba(244, 240, 234, 0.3); }
.footer-right { display: flex; gap: 2rem; }
.footer-link { font-family: var(--sans); font-size: 0.72rem; letter-spacing: 0.08em; text-transform: uppercase; color: rgba(244, 240, 234, 0.25); text-decoration: none; transition: color 0.3s ease; }
.footer-link:hover { color: rgba(244, 240, 234, 0.6); }

@media (max-width: 480px) {
  .page-container { padding: 3.5rem 1.25rem 3rem; }
  .footer-inner { flex-direction: column; gap: 1.5rem; text-align: center; }
}
</style>
