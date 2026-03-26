<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your issue</p>
    <h2 class="display-medium">What issue do you care most about?</h2>
    <Divider />
    <p class="body-text">It could be anything — poverty, education, climate, healthcare, community safety, moral standards, immigration. The more passionately you feel about it, the better this exercise works.</p>
    <textarea class="text-input" v-model="issue" placeholder="Describe the issue you care about most..." rows="4"></textarea>
    <NavBar :can-go-back="true" :disable-continue="!issue.trim()" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
defineEmits(['advance', 'back'])
const el = ref(null)
const issue = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.text-input { width: 100%; margin: 2rem 0; padding: 1rem; border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.95rem; color: var(--ink); background: var(--cream); resize: vertical; outline: none; transition: border-color 0.2s; line-height: 1.6; }
.text-input:focus { border-color: var(--ochre); }
.text-input::placeholder { color: var(--ink-faint); }
</style>
