<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The four moves</p>
    <h2 class="display-medium">A conversation, not a debate.</h2>
    <Divider />
    <p class="body-text">The goal isn't to win. It's to plant a question they'll keep thinking about. Four moves, in order.</p>

    <div class="steps">
      <div class="step"><div class="step-num">1</div><div><div class="step-title">Affirm their values</div><p>"I think compassion for the poor is genuinely important" or "I agree that personal responsibility matters." Start where they are, not where you want them to be.</p></div></div>
      <div class="step"><div class="step-num">2</div><div><div class="step-title">Ask the method question</div><p>"We agree on the goal. I'm curious — do you think the best way to achieve it is through government force, or through voluntary cooperation?" Don't answer it for them. Let them sit with it.</p></div></div>
      <div class="step"><div class="step-num">3</div><div><div class="step-title">Introduce the personal test</div><p>"Would you personally do what you're asking the government to do? Would you go to your neighbor's house and take their money for this cause?" If they say no, ask why the government doing it feels different.</p></div></div>
      <div class="step"><div class="step-num">4</div><div><div class="step-title">Leave the question open</div><p>Don't push for agreement. Say: "I don't have all the answers either. But I think that question — force or persuasion — is worth thinking about." Then let it rest.</p></div></div>
    </div>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.steps { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }
.step { display: flex; gap: 1rem; align-items: flex-start; }
.step-num { flex-shrink: 0; width: 28px; height: 28px; border-radius: 50%; background: var(--ochre-faint); display: flex; align-items: center; justify-content: center; font-family: var(--serif); font-size: 0.8rem; font-weight: 500; color: var(--ochre); margin-top: 2px; }
.step-title { font-family: var(--serif); font-size: 1rem; font-weight: 500; color: var(--ink); margin-bottom: 0.3rem; }
.step p { font-size: 0.88rem; color: var(--ink-soft); line-height: 1.7; margin: 0; }
</style>
