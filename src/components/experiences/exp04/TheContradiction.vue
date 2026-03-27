<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The contradiction at the center</p>
    <h2 class="display-medium">The argument for concentrating coercive power requires you to believe two things at once.</h2>
    <Divider />

    <div class="contradictions">
      <div class="contradiction-pair">
        <div class="contradiction-box premise">
          <div class="contradiction-label">What you believe about people</div>
          <p>People are self-interested, short-sighted, and prone to abusing power when they have it.</p>
        </div>
        <div class="contradiction-vs">and yet</div>
        <div class="contradiction-box conclusion">
          <div class="contradiction-label">What the system assumes</div>
          <p>These same people, when given a monopoly on legal force, will use it wisely, restrain themselves voluntarily, and serve the public interest over their own.</p>
        </div>
      </div>
    </div>

    <p class="body-text-large">Voters are too ignorant to make good decisions about their own lives. But politicians, drawn from the same population, are wise enough to make decisions for everyone. People are too selfish to help each other voluntarily. But those same people become public servants the moment they win an election.</p>

    <ContentBlock variant="principle">
      <p>If human beings cannot be trusted to manage their own lives through voluntary cooperation, they certainly cannot be trusted to manage other people's lives through coercive authority. The flaws that make freedom dangerous make power catastrophic.</p>
    </ContentBlock>

    <p class="body-text">You don't need to accept a single claim about human goodness to reach this conclusion. You only need to apply your existing beliefs consistently.</p>

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
.contradictions { margin: 2rem 0; }
.contradiction-pair { display: flex; flex-direction: column; gap: 0; }
.contradiction-box { padding: 1.25rem 1.5rem; border-radius: var(--radius); }
.contradiction-box.premise { background: var(--ochre-faint); border: 1.5px solid var(--ochre); border-bottom: none; border-radius: var(--radius) var(--radius) 0 0; }
.contradiction-box.conclusion { background: var(--concede-bg); border: 1.5px solid var(--concede-warm); border-top: none; border-radius: 0 0 var(--radius) var(--radius); }
.contradiction-label { font-size: 0.68rem; letter-spacing: 0.1em; text-transform: uppercase; font-weight: 600; margin-bottom: 0.5rem; }
.premise .contradiction-label { color: var(--ochre); }
.conclusion .contradiction-label { color: var(--concede-warm); }
.contradiction-box p { margin: 0; font-size: 0.92rem; line-height: 1.6; }
.premise p { color: var(--ink); }
.conclusion p { color: var(--ink); }
.contradiction-vs { text-align: center; font-family: var(--serif); font-size: 0.85rem; font-style: italic; color: var(--ink-faint); padding: 0.4rem 0; background: var(--paper); position: relative; z-index: 1; }
</style>
