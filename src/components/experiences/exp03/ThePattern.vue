<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="2" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The pattern in your answer</p>
    <h2 class="display-medium">You just described what scientists call human flourishing.</h2>
    <Divider />

    <p class="body-text-large">The conditions you selected aren't random. They map to six pillars that researchers across psychology, neuroscience, economics, and philosophy have independently identified as the architecture of human well-being.</p>

    <div class="pillars">
      <div v-for="p in pillars" :key="p.id" class="pillar" :class="{ highlighted: isSelected(p.id) }">
        <div class="pillar-marker">{{ isSelected(p.id) ? '●' : '○' }}</div>
        <div class="pillar-content">
          <div class="pillar-name">{{ p.name }}</div>
          <div class="pillar-desc">{{ p.desc }}</div>
          <div v-if="isSelected(p.id)" class="pillar-yours">You identified this from your own life.</div>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>These aren't philosophical abstractions. They're the conditions that were present when <em>you</em> were at your best. And they're universal — every human being, across every culture and era, flourishes under these same conditions.</p>
    </ContentBlock>

    <p class="body-text">This matters because it means flourishing is an observable, measurable pattern in human nature. And anything that systematically undermines these conditions systematically undermines human well-being.</p>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const selectedConditions = inject('selectedConditions', ref([]))

const pillars = [
  { id: 'safety', name: 'Safety', desc: 'The absence of credible threat to your body or well-being.' },
  { id: 'autonomy', name: 'Autonomy', desc: 'The freedom to direct your own life and make your own choices.' },
  { id: 'connection', name: 'Connection', desc: 'Relationships of trust, belonging, and mutual support.' },
  { id: 'competence', name: 'Competence', desc: 'The ability to act effectively — to build, create, and grow.' },
  { id: 'purpose', name: 'Purpose', desc: 'A sense that your life is coherent, valuable, and worth pursuing.' },
  { id: 'opportunity', name: 'Opportunity', desc: 'Access to the time, tools, and resources that make growth possible.' }
]

function isSelected(id) {
  return selectedConditions.value.includes(id)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.pillars {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.pillar {
  display: flex;
  gap: 0.75rem;
  padding: 1rem 1.25rem;
  border-radius: var(--radius);
  border: 1px solid var(--border-subtle);
  background: var(--cream);
  transition: all 0.3s ease;
}

.pillar.highlighted {
  border-color: var(--ochre);
  background: var(--ochre-faint);
}

.pillar-marker {
  flex-shrink: 0;
  font-size: 0.7rem;
  color: var(--ochre);
  margin-top: 0.25rem;
}

.pillar-content { flex: 1; }

.pillar-name {
  font-family: var(--serif);
  font-size: 1rem;
  font-weight: 500;
  color: var(--ink);
  margin-bottom: 0.2rem;
}

.pillar-desc {
  font-size: 0.85rem;
  color: var(--ink-muted);
  line-height: 1.5;
}

.pillar-yours {
  font-size: 0.75rem;
  color: var(--ochre);
  margin-top: 0.35rem;
  font-style: italic;
}

@media (max-width: 480px) {
  .pillar { padding: 0.85rem 1rem; }
}
</style>
