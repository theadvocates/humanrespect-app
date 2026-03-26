<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your design</p>
    <h2 class="display-medium">Design a solution using only voluntary means.</h2>
    <Divider />
    <p class="body-text">Consider these questions as you design:</p>

    <div class="prompts">
      <div class="prompt"><strong>Who cares about this problem?</strong> Who else in your community would want to help solve it?</div>
      <div class="prompt"><strong>How would you fund it?</strong> Donations, crowdfunding, business sponsorship, membership fees, bake sales?</div>
      <div class="prompt"><strong>How would you organize it?</strong> A neighborhood group, a nonprofit, an informal coalition, a social media campaign?</div>
      <div class="prompt"><strong>How would you sustain it?</strong> What keeps people engaged and contributing over time?</div>
      <div class="prompt"><strong>What's the first step?</strong> Not the whole plan — just the first action you'd take this week.</div>
    </div>

    <textarea class="text-input" v-model="solution" placeholder="Describe your voluntary solution..." rows="6"></textarea>
    <NavBar :can-go-back="true" :disable-continue="!solution.trim()" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
const solution = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.prompts { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.75rem; }
.prompt { padding: 0.75rem 1rem; background: var(--cream); border-left: 2px solid var(--ochre); font-size: 0.88rem; color: var(--ink-soft); line-height: 1.6; border-radius: 0 var(--radius) var(--radius) 0; }
.prompt strong { color: var(--ink); }
.text-input { width: 100%; margin: 2rem 0; padding: 1rem; border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.95rem; color: var(--ink); background: var(--cream); resize: vertical; outline: none; transition: border-color 0.2s; line-height: 1.6; }
.text-input:focus { border-color: var(--ochre); }
.text-input::placeholder { color: var(--ink-faint); }
</style>
