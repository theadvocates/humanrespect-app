<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The defenses</p>
    <h2 class="display-medium">Three things people say to avoid this conclusion.</h2>
    <Divider />

    <div class="defenses">
      <div v-for="d in defenses" :key="d.id" class="defense" :class="{ expanded: expanded === d.id }" @click="toggleExpand(d.id)">
        <div class="defense-header">
          <div class="defense-claim">{{ d.claim }}</div>
          <div class="defense-toggle">{{ expanded === d.id ? '−' : '+' }}</div>
        </div>
        <div v-if="expanded === d.id" class="defense-body">
          <p class="defense-response">{{ d.response }}</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="concession" label="The honest complexity">
      <p>Moral responsibility in a democracy exists on a spectrum. You didn't design the system. You were born into it. You may have voted against the specific policy. The philosophy acknowledges this. But it insists that the spectrum runs from "fully responsible" to "complicit by participation" — not from "responsible" to "innocent." Living within a coercive system and benefiting from it doesn't make you evil. But it doesn't make you uninvolved.</p>
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
const expanded = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function toggleExpand(id) {
  expanded.value = expanded.value === id ? null : id
}

const defenses = [
  {
    id: 'just-voting',
    claim: '"I was just voting. That\'s different from personally doing it."',
    response: 'Hiring a hitman is "just making a phone call." Commissioning a theft is "just writing a check." The directness of the action doesn\'t determine the moral weight. What matters is whether you authorized the outcome. When you vote for a policy knowing it will be enforced through the threat of imprisonment, you authorize that enforcement. The ballot is the authorization.'
  },
  {
    id: 'had-to',
    claim: '"I didn\'t have a choice — these are the only options on the ballot."',
    response: 'A constrained choice is still a choice. When you choose between two candidates who both support coercive policies, you are choosing which form of force to authorize — not whether to authorize force at all. The system constrains your options, but the constraint doesn\'t erase your agency. A person who pulls a lever because a gun is at their head has reduced responsibility. A person who pulls a lever because the other levers are slightly worse does not.'
  },
  {
    id: 'common-good',
    claim: '"I was voting for the common good."',
    response: 'The person who hires someone to steal also believes they have a good reason — maybe they intend to give the money to charity. Every act of coercion in history has been justified by its beneficiaries. Good intentions don\'t transform the nature of the act. They explain why you authorized it. They don\'t change what you authorized.'
  }
]
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.defenses { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.defense { background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; overflow: hidden; -webkit-tap-highlight-color: transparent; }
.defense:hover { border-color: var(--concede-warm); }
.defense.expanded { border-color: var(--concede-warm); }
.defense-header { display: flex; justify-content: space-between; align-items: flex-start; padding: 0.85rem 1.1rem; gap: 0.75rem; }
.defense-claim { font-family: var(--serif); font-size: 0.92rem; font-weight: 500; color: var(--ink); font-style: italic; }
.defense-toggle { font-size: 1.2rem; color: var(--concede-warm); font-weight: 300; flex-shrink: 0; width: 24px; text-align: center; }
.defense-body { padding: 0 1.1rem 1.1rem; }
.defense-response { font-size: 0.85rem; line-height: 1.7; color: var(--ink-muted); margin: 0; }
</style>
