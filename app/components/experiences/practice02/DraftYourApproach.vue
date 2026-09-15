<template>
  <div ref="el" class="screen-inner stagger">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">The constraint</p>
    <h2 class="display-medium">Now solve it without force.</h2>
    <Divider />
    <p class="body-text-large">No taxes, regulations, penalties, or mandates. Only persuasion, voluntary cooperation, and creative problem-solving.</p>

    <ScenarioBox label="Your tools">
      <p><strong>Conversation</strong> — talking with people and changing minds.</p>
      <p><strong>Voluntary funding</strong> — donations, crowdfunding, subscriptions, membership fees.</p>
      <p><strong>Community organizing</strong> — bringing together the people who share the goal.</p>
      <p><strong>Market solutions</strong> — building a product or service that solves the problem.</p>
      <p><strong>Leading by example</strong> — doing it yourself, where others can see.</p>
    </ScenarioBox>

    <textarea v-model="approach" class="text-input" placeholder="How would you advance your issue with only these tools?" rows="6"/>
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
