<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">What you just demonstrated</p>
    <h2 class="display-medium">{{ wouldForce === 'yes' ? 'You chose force. Most people don\'t.' : 'You already know that force doesn\'t work.' }}</h2>
    <Divider />

    <template v-if="wouldForce === 'no'">
      <p class="body-text-large">You were confident you were right. The stakes were real. And you still chose persuasion. Look at the reasons you gave:</p>

      <div class="your-reasons">
        <div v-for="r in selectedReasons" :key="r.id" class="reason-item">
          <span class="reason-dot"></span>
          <span>{{ r.label }}</span>
        </div>
      </div>

      <p class="body-text">Every one of these is a statement about what happens to human beings when force replaces persuasion. Relationships break. Resentment grows. Beliefs don't change. Trust erodes. The long-term costs outweigh the short-term gains.</p>

      <ContentBlock variant="insight">
        <p>You didn't learn this from a philosophy book. You learned it from living among other human beings. You've run this experiment thousands of times — in your family, your friendships, your workplace — and you've arrived at the same conclusion every time: persuasion builds. Force diminishes.</p>
      </ContentBlock>
    </template>

    <template v-else>
      <p class="body-text-large">Most people, when they think honestly about a specific person they care about, choose persuasion over force. The relationship matters too much. The resentment isn't worth it. The compliance isn't the same as agreement.</p>

      <p class="body-text">Your answer is worth examining, though. What was it about this particular disagreement that made force feel justified? Was it the urgency of the situation? The certainty that you were right? The belief that the other person's resistance was harmful?</p>

      <ContentBlock variant="mirror">
        <p>Hold onto those reasons. They're the same reasons people give for using political force: urgency, certainty, and the belief that resistance to the right answer is itself a form of harm. The question the philosophy raises is whether those reasons produce good outcomes — for the person being forced, and for the relationship between you.</p>
      </ContentBlock>
    </template>

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
const wouldForce = inject('wouldForce')
const whyNot = inject('whyNot')
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const allReasons = [
  { id: 'relationship', label: 'It would have damaged the relationship' },
  { id: 'resentment', label: 'They would have resented me' },
  { id: 'belief', label: 'It wouldn\'t have changed what they actually believe' },
  { id: 'cost', label: 'The long-term cost isn\'t worth the short-term win' },
  { id: 'respect', label: 'It feels wrong to override someone I respect' },
  { id: 'wrong', label: 'Using force on someone who hasn\'t harmed me is simply wrong' },
]

const selectedReasons = computed(() =>
  allReasons.filter(r => whyNot.value.includes(r.id))
)
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.your-reasons { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.reason-item { display: flex; align-items: flex-start; gap: 0.75rem; font-size: 0.92rem; color: var(--ink); line-height: 1.5; }
.reason-dot { flex-shrink: 0; width: 8px; height: 8px; border-radius: 50%; background: var(--ochre); margin-top: 6px; }
</style>
