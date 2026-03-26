<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="4" />
    <p class="caption" style="margin-bottom: 1.5rem;">Start now</p>
    <h2 class="display-medium">Your first observation — right now.</h2>
    <Divider />
    <p class="body-text-large">Think about <em>today</em>. Was there a moment — even a small one — where the question of force vs. persuasion was present?</p>
    <p class="body-text">Maybe a conversation about politics. A frustration with a coworker. A news story that made you angry. A parenting moment. A business decision. A thought about what "should" be required.</p>

    <textarea class="text-input" v-model="observation" placeholder="Describe the moment. What happened? Did you lean toward force or persuasion?" rows="5"></textarea>

    <ContentBlock v-if="observation.trim()" variant="insight">
      <p>That's day one. You noticed. Most people go their entire lives without seeing this pattern in their own thinking. You just started.</p>
    </ContentBlock>

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
const observation = ref('')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>
<style scoped>
.screen-inner { padding: 0 0.5rem; }
.text-input { width: 100%; margin: 2rem 0; padding: 1rem; border: 1.5px solid var(--border-subtle); border-radius: var(--radius); font-family: var(--sans); font-size: 0.95rem; color: var(--ink); background: var(--cream); resize: vertical; outline: none; transition: border-color 0.2s; line-height: 1.6; }
.text-input:focus { border-color: var(--ochre); }
.text-input::placeholder { color: var(--ink-faint); }
</style>
