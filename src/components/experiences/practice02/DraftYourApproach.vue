<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The constraint</p>
    <h2 class="display-medium">Now solve it — with zero coercion.</h2>
    <Divider />
    <p class="body-text-large">No taxes. No regulations. No penalties. No government mandates. Only persuasion, voluntary cooperation, and creative problem-solving.</p>

    <ScenarioBox label="Your tools">
      <p><strong>Conversation</strong> — talking to people, sharing ideas, changing minds through dialogue.</p>
      <p><strong>Voluntary funding</strong> — donations, crowdfunding, subscriptions, membership fees.</p>
      <p><strong>Community organizing</strong> — bringing people together who share the goal.</p>
      <p><strong>Market solutions</strong> — building products or services that address the problem.</p>
      <p><strong>Leading by example</strong> — demonstrating the change you want to see.</p>
    </ScenarioBox>

    <textarea class="text-input" v-model="approach" placeholder="How would you address your issue using only these tools?" rows="6"></textarea>
    <NavBar :can-go-back="true" :disable-continue="!approach.trim()" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ScenarioBox from '@/components/shared/ScenarioBox.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
const approach = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.text-input { width: 100%; margin: 2rem 0; padding: 1rem; border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.95rem; color: var(--ink); background: var(--cream); resize: vertical; outline: none; transition: border-color 0.2s; line-height: 1.6; }
.text-input:focus { border-color: var(--ochre); }
.text-input::placeholder { color: var(--ink-faint); }
</style>
