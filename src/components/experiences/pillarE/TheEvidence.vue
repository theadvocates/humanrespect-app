<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">Already happening</p>
    <h2 class="display-medium">Voluntary cooperation is solving "impossible" problems right now.</h2>
    <Divider />

    <p class="body-text">Each of these was once assumed to require compulsory funding, centralized control, or government mandates. Each one was solved by people who chose to cooperate.</p>

    <div class="examples">
      <div v-for="ex in examples" :key="ex.id" class="example-card">
        <div class="example-header">
          <div class="example-name">{{ ex.name }}</div>
          <div class="example-what">{{ ex.what }}</div>
        </div>
        <p class="example-how">{{ ex.how }}</p>
        <div class="example-assumption">
          <span class="assumption-label">The assumption:</span>
          <span v-html="ex.assumption"></span>
        </div>
        <div class="example-reality">
          <span class="reality-label">The reality:</span>
          {{ ex.reality }}
        </div>
      </div>
    </div>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { examples } from './examplesData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.examples { margin: 2rem 0; display: flex; flex-direction: column; gap: 1.25rem; }

.example-card {
  padding: 1.5rem;
  background: var(--cream);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius);
  box-shadow: var(--shadow-soft);
}

.example-header { margin-bottom: 0.75rem; }

.example-name {
  font-family: var(--serif);
  font-size: 1.1rem;
  font-weight: 500;
  color: var(--ink);
}

.example-what {
  font-size: 0.8rem;
  color: var(--ink-muted);
  margin-top: 0.1rem;
}

.example-how {
  font-size: 0.88rem;
  color: var(--ink-soft);
  line-height: 1.7;
  margin: 0 0 0.75rem 0;
}

.example-assumption {
  font-size: 0.82rem;
  color: var(--concede-warm);
  line-height: 1.6;
  padding: 0.6rem 0.85rem;
  background: var(--concede-bg);
  border-radius: 4px;
  margin-bottom: 0.5rem;
}

.assumption-label {
  font-weight: 600;
  display: block;
  font-size: 0.7rem;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  margin-bottom: 0.2rem;
}

.example-reality {
  font-size: 0.82rem;
  color: var(--insight-green);
  line-height: 1.6;
  padding: 0.6rem 0.85rem;
  background: var(--insight-bg);
  border-radius: 4px;
}

.reality-label {
  font-weight: 600;
  display: block;
  font-size: 0.7rem;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  margin-bottom: 0.2rem;
}

@media (max-width: 480px) {
  .example-card { padding: 1.25rem; }
}
</style>
