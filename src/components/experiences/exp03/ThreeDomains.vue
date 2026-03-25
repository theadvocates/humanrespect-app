<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="4" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The structure of what went wrong</p>
    <h2 class="display-medium">Every violation you identified falls into one of three domains.</h2>
    <Divider />

    <p class="body-text-large">The conditions that suppressed your flourishing weren't random. They attacked specific dimensions of your life — the same three dimensions that, when respected, make flourishing possible.</p>

    <div class="domains">
      <div class="domain" :class="{ active: hasBody }">
        <div class="domain-header">
          <div class="domain-icon">I</div>
          <div>
            <div class="domain-name">Bodily Integrity</div>
            <div class="domain-imperative">Respect the Body: Do not harm.</div>
          </div>
        </div>
        <p class="domain-desc">Your body is the seat of all experience. When it is unsafe — when you face violence, threats, or the fear of harm — your nervous system shifts into survival mode. Creativity shuts down. Trust collapses. Long-term thinking becomes impossible. Safety isn't a luxury. It's the precondition for everything else.</p>
        <div v-if="hasBody" class="domain-yours">You experienced this.</div>
      </div>

      <div class="domain" :class="{ active: hasResources }">
        <div class="domain-header">
          <div class="domain-icon">II</div>
          <div>
            <div class="domain-name">Material Integrity</div>
            <div class="domain-imperative">Respect Resources: Do not steal.</div>
          </div>
        </div>
        <p class="domain-desc">Your property isn't just stuff. It's crystallized time — the physical form of hours, days, and years of effort. When resources are taken or destabilized, you lose not just things but the capacity to plan, build, and shape your future. Material security is the quiet engine of flourishing.</p>
        <div v-if="hasResources" class="domain-yours">You experienced this.</div>
      </div>

      <div class="domain" :class="{ active: hasTime }">
        <div class="domain-header">
          <div class="domain-icon">III</div>
          <div>
            <div class="domain-name">Temporal Integrity</div>
            <div class="domain-imperative">Respect Time: Do not coerce.</div>
          </div>
        </div>
        <p class="domain-desc">Time is the only truly non-renewable resource. It cannot be replaced, replenished, stored, or compensated. Every moment of coerced activity is a moment of life permanently redirected. When someone controls your time, they don't just inconvenience you — they consume the irreplaceable substance of your existence.</p>
        <div v-if="hasTime" class="domain-yours">You experienced this.</div>
      </div>
    </div>

    <ContentBlock variant="principle">
      <p>These three domains — body, resources, and time — form the complete architecture of a human life. When all three are respected, people flourish. When any is violated, flourishing predictably declines.</p>
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
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const selectedViolations = inject('selectedViolations', ref([]))

const hasBody = computed(() =>
  selectedViolations.value.some(v => v.startsWith('body'))
)
const hasResources = computed(() =>
  selectedViolations.value.some(v => v.startsWith('resources'))
)
const hasTime = computed(() =>
  selectedViolations.value.some(v => v.startsWith('time'))
)
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.domains {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.domain {
  padding: 1.5rem;
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  background: var(--cream);
  transition: all 0.3s ease;
}

.domain.active {
  border-color: var(--ochre);
  background: var(--ochre-faint);
}

.domain-header {
  display: flex;
  gap: 0.75rem;
  align-items: flex-start;
  margin-bottom: 0.75rem;
}

.domain-icon {
  flex-shrink: 0;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: var(--paper-deep);
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: var(--serif);
  font-size: 0.75rem;
  font-weight: 500;
  color: var(--ink-muted);
  margin-top: 2px;
}

.domain.active .domain-icon {
  background: var(--ochre);
  color: white;
}

.domain-name {
  font-family: var(--serif);
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--ink);
  line-height: 1.3;
}

.domain-imperative {
  font-size: 0.8rem;
  color: var(--ink-muted);
  font-style: italic;
  margin-top: 0.15rem;
}

.domain-desc {
  font-size: 0.9rem;
  color: var(--ink-soft);
  line-height: 1.7;
  margin: 0;
}

.domain-yours {
  font-size: 0.8rem;
  color: var(--ochre);
  margin-top: 0.75rem;
  font-style: italic;
}

@media (max-width: 480px) {
  .domain { padding: 1.25rem; }
  .domain-desc { font-size: 0.85rem; }
}
</style>
