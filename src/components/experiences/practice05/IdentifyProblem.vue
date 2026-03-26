<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your community</p>
    <h2 class="display-medium">What's a real problem where you live?</h2>
    <Divider />
    <p class="body-text">Think local. A park that needs maintenance. A neighbor who needs help. A street that's unsafe. A school that's failing. Kids with nothing to do after school. Elderly people who are isolated. A food desert. A housing shortage.</p>
    <p class="body-text">Pick something specific enough to actually address — not "fix inequality" but "the playground on Elm Street is broken and kids have nowhere to play."</p>
    <textarea class="text-input" v-model="problem" placeholder="Describe a real problem in your community..." rows="4"></textarea>
    <NavBar :can-go-back="true" :disable-continue="!problem.trim()" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
const problem = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.text-input { width: 100%; margin: 2rem 0; padding: 1rem; border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.95rem; color: var(--ink); background: var(--cream); resize: vertical; outline: none; transition: border-color 0.2s; line-height: 1.6; }
.text-input:focus { border-color: var(--ochre); }
.text-input::placeholder { color: var(--ink-faint); }
</style>
