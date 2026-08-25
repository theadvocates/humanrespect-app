<template>
  <div class="nav-bar">
    <button class="nav-back" :disabled="!canGoBack" @click="handleBack">
      ← Back
    </button>
    <button class="nav-continue" :disabled="disableContinue" @click="$emit('continue')">
      <span>Continue</span>
      <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
import { useSmartBack } from '@/composables/useSmartBack'

const props = defineProps({
  canGoBack: { type: Boolean, default: true },
  disableContinue: { type: Boolean, default: false },
  smartBack: { type: Boolean, default: false }
})

const emit = defineEmits(['back', 'continue'])
const { goBack: smartGoBack } = useSmartBack()

function handleBack() {
  if (props.smartBack) {
    smartGoBack()
  } else {
    emit('back')
  }
}
</script>

<style scoped>
.nav-bar {
  margin-top: 3rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 1.5rem;
  border-top: 1px solid var(--border-subtle);
}
.nav-back {
  font-family: var(--sans);
  font-size: 0.82rem;
  color: var(--ink-faint);
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.5rem 0;
  transition: color 0.2s;
}
.nav-back:hover { color: var(--ink-muted); }
.nav-back:disabled { opacity: 0; cursor: default; }
.nav-continue {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-family: var(--serif);
  font-size: 0.95rem;
  font-weight: 500;
  color: white;
  background: var(--ochre);
  border: none;
  border-radius: 100px;
  padding: 0.65rem 1.5rem;
  cursor: pointer;
  transition: all 0.25s ease;
  -webkit-tap-highlight-color: transparent;
}
.nav-continue:hover { transform: translateX(2px); }
.nav-continue:disabled { opacity: 0.35; cursor: not-allowed; transform: none; }
.nav-continue .arrow { transition: transform 0.2s ease; }
.nav-continue:hover:not(:disabled) .arrow { transform: translateX(3px); }
</style>
