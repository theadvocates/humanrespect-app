<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">A personal calculation</p>
    <h2 class="display-medium">How many hours of your life go to taxes each year?</h2>
    <Divider />

    <p class="body-text-large">Not the money. The <em>hours</em>. The irreplaceable hours of your one life. Let's find out.</p>

    <div class="calc-inputs">
      <div class="calc-field">
        <label class="calc-label">Your approximate annual income</label>
        <div class="input-row">
          <span class="input-prefix">$</span>
          <input
            type="number"
            class="calc-input"
            placeholder="e.g. 60000"
            :value="localIncome"
            @input="localIncome = Number($event.target.value)"
          />
        </div>
      </div>

      <div class="calc-field">
        <label class="calc-label">Your approximate total tax rate (federal + state + local + payroll)</label>
        <div class="input-row">
          <input
            type="number"
            class="calc-input"
            placeholder="e.g. 30"
            :value="localRate"
            @input="localRate = Number($event.target.value)"
            min="0"
            max="70"
          />
          <span class="input-suffix">%</span>
        </div>
        <p class="calc-hint">Most working Americans pay 25-40% across all taxes combined.</p>
      </div>
    </div>

    <div v-if="hoursPerYear" class="result-block">
      <div class="result-number">{{ hoursPerYear.toLocaleString() }}</div>
      <div class="result-label">hours of your life per year</div>
      <div class="result-context">That's <strong>{{ weeksPerYear }} full work weeks</strong> — spent earning money that goes to someone else's priorities, not yours.</div>

      <div class="lifetime-row">
        <div class="lifetime-stat">
          <div class="lifetime-number">{{ lifetimeHours.toLocaleString() }}</div>
          <div class="lifetime-label">hours over a 40-year career</div>
        </div>
        <div class="lifetime-stat">
          <div class="lifetime-number">{{ lifetimeYears }}</div>
          <div class="lifetime-label">years of full-time work</div>
        </div>
      </div>
    </div>

    <NavBar
      :can-go-back="true"
      :disable-continue="!hoursPerYear"
      @back="$emit('back')"
      @continue="emitAndAdvance"
    />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'

const emit = defineEmits(['advance', 'back', 'set-income', 'set-rate'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const localIncome = ref(null)
const localRate = ref(null)

const hourlyRate = computed(() => {
  if (!localIncome.value || localIncome.value <= 0) return null
  return localIncome.value / 2080 // 40hr × 52wk
})

const hoursPerYear = computed(() => {
  if (!hourlyRate.value || !localRate.value || localRate.value <= 0) return null
  const taxAmount = localIncome.value * (localRate.value / 100)
  return Math.round(taxAmount / hourlyRate.value)
})

const weeksPerYear = computed(() => {
  if (!hoursPerYear.value) return null
  return Math.round(hoursPerYear.value / 40)
})

const lifetimeHours = computed(() => {
  if (!hoursPerYear.value) return null
  return hoursPerYear.value * 40
})

const lifetimeYears = computed(() => {
  if (!lifetimeHours.value) return null
  return (lifetimeHours.value / 2080).toFixed(1)
})

function emitAndAdvance() {
  emit('set-income', localIncome.value)
  emit('set-rate', localRate.value)
  emit('advance')
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }

.calc-inputs {
  margin: 2rem 0;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.calc-field {}

.calc-label {
  display: block;
  font-size: 0.85rem;
  color: var(--ink-muted);
  margin-bottom: 0.5rem;
}

.input-row {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.input-prefix, .input-suffix {
  font-family: var(--serif);
  font-size: 1.1rem;
  color: var(--ink-muted);
}

.calc-input {
  flex: 1;
  padding: 0.75rem 1rem;
  border: 1.5px solid var(--border-subtle);
  border-radius: var(--radius);
  font-family: var(--sans);
  font-size: 1rem;
  color: var(--ink);
  background: var(--cream);
  outline: none;
  transition: border-color 0.2s ease;
  -webkit-appearance: none;
}

.calc-input:focus {
  border-color: var(--ochre);
}

.calc-input::placeholder {
  color: var(--ink-faint);
}

.calc-hint {
  font-size: 0.75rem;
  color: var(--ink-faint);
  margin-top: 0.35rem;
  font-style: italic;
}

.result-block {
  background: var(--ochre-faint);
  border: 1px solid var(--ochre);
  border-radius: var(--radius);
  padding: 2rem;
  margin: 2rem 0;
  text-align: center;
}

.result-number {
  font-family: var(--serif);
  font-size: clamp(2.5rem, 6vw, 3.5rem);
  font-weight: 500;
  color: var(--ochre);
  line-height: 1;
}

.result-label {
  font-size: 0.9rem;
  color: var(--ink-muted);
  margin-top: 0.5rem;
}

.result-context {
  font-size: 0.95rem;
  color: var(--ink-soft);
  margin-top: 1.25rem;
  line-height: 1.6;
}

.lifetime-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid rgba(154, 123, 79, 0.2);
}

.lifetime-number {
  font-family: var(--serif);
  font-size: 1.5rem;
  font-weight: 500;
  color: var(--ink);
}

.lifetime-label {
  font-size: 0.75rem;
  color: var(--ink-muted);
  margin-top: 0.25rem;
}

/* Hide number input spinners */
.calc-input::-webkit-outer-spin-button,
.calc-input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
.calc-input[type=number] {
  -moz-appearance: textfield;
}

@media (max-width: 480px) {
  .result-block { padding: 1.5rem; }
  .lifetime-row { gap: 1rem; }
}
</style>
