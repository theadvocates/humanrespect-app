<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">Now apply it</p>
    <h2 class="display-medium">Take everything you just said about human nature. Now give those humans a specific set of tools.</h2>
    <Divider />

    <div class="tools-list">
      <div class="tool-item">
        <p>The legal authority to take anyone's money or property</p>
      </div>
      <div class="tool-item">
        <p>The power to put people in cages for disobeying</p>
      </div>
      <div class="tool-item">
        <p>A monopoly on the legitimate use of violence</p>
      </div>
      <div class="tool-item">
        <p>The ability to write the rules everyone else must follow</p>
      </div>
      <div class="tool-item">
        <p>Legal immunity for most of what they do with these tools</p>
      </div>
    </div>

    <p class="body-text-large" style="margin-top: 2rem;">You said people {{ topTraitSummary }}. What do you predict happens when those same people get these tools?</p>

    <ContentBlock variant="mirror">
      <p>You don't need this philosophy to answer that. Your own observations about human nature already predict exactly what happens. The question is whether you've applied those observations consistently.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
const selectedTraits = inject('selectedTraits')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const traitSummaries = {
  'self-interest': 'act in their own interest',
  'game-systems': 'game any system they can',
  'power-abuse': 'abuse power when they have it',
  'short-term': 'chase short-term rewards',
  'in-group': 'favor their own group',
  'accountability': 'behave worse without accountability',
  'rationalize': 'rationalize anything that benefits them',
  'good-intentions': 'produce bad outcomes despite good intentions'
}

const topTraitSummary = computed(() => {
  const selected = selectedTraits.value.slice(0, 3)
  const summaries = selected.map(id => traitSummaries[id]).filter(Boolean)
  if (summaries.length === 0) return 'are flawed and self-interested'
  if (summaries.length === 1) return summaries[0]
  return summaries.slice(0, -1).join(', ') + ' and ' + summaries[summaries.length - 1]
})
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.tools-list { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.tool-item { padding: 0.85rem 1.1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); }
.tool-item p { margin: 0; font-size: 0.92rem; line-height: 1.55; color: var(--ink); }
</style>
