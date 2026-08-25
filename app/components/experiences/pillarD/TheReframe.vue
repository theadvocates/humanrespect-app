<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The shift</p>
    <h2 class="display-medium">What if everyone committed to persuasion — regardless of their values?</h2>
    <Divider />

    <p class="body-text-large">Imagine two societies. Same people. Same values. Same diversity of opinion. The only difference is the <em>method</em>.</p>

    <div class="comparison">
      <div class="society society-force">
        <div class="society-label">Society A: Force</div>
        <p>Everyone tries to capture political power and use it to impose their values on everyone else. Elections become winner-take-all battles. Whoever wins forces the losers to fund and follow policies they oppose.</p>
        <div class="society-result">Result: Permanent conflict. Resentment. Culture wars. Every election is an existential threat. Trust erodes. Cooperation collapses.</div>
      </div>

      <div class="society society-persuade">
        <div class="society-label">Society B: Persuasion</div>
        <p>Everyone holds their values just as deeply — but commits to advancing them only through conversation, example, voluntary cooperation, and creative problem-solving. No one forces anyone.</p>
        <div class="society-result">Result: Diversity without conflict. People with different values coexist, learn from each other, and cooperate on shared goals. Trust grows. Innovation flourishes.</div>
      </div>
    </div>

    <ContentBlock variant="principle">
      <p>The values stay exactly the same. Only the method changes. And that single change — from force to persuasion — turns a conflict machine into a cooperation machine.</p>
    </ContentBlock>

    <p class="body-text">This is the core insight of the Human Respect Method: the moral legitimacy of a social system depends not on the values it promotes, but on the methods it uses. You can hold any values and still commit to advancing them through persuasion alone.</p>

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

.comparison {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.society {
  padding: 1.5rem;
  border-radius: var(--radius);
  border: 1.5px solid var(--border-subtle);
}

.society-force {
  background: var(--concede-bg);
  border-color: var(--concede-warm);
}

.society-persuade {
  background: var(--insight-bg);
  border-color: var(--insight-green);
}

.society-label {
  font-family: var(--serif);
  font-size: 1rem;
  font-weight: 500;
  margin-bottom: 0.5rem;
}

.society-force .society-label { color: var(--concede-warm); }
.society-persuade .society-label { color: var(--insight-green); }

.society p {
  font-size: 0.9rem;
  line-height: 1.7;
  color: var(--ink-soft);
  margin: 0;
}

.society-result {
  margin-top: 0.75rem;
  font-size: 0.85rem;
  font-style: italic;
}

.society-force .society-result { color: var(--concede-warm); }
.society-persuade .society-result { color: var(--insight-green); }

@media (max-width: 480px) {
  .society { padding: 1.25rem; }
}
</style>
