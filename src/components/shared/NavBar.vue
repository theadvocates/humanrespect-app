<template>
  <div class="nav-area">
    <button
      class="nav-back"
      :disabled="!canGoBack"
      @click="$emit('back')"
    >← Back</button>
    <button
      class="nav-continue"
      :disabled="disableContinue"
      @click="$emit('continue')"
    >
      Continue <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
defineProps({
  canGoBack: { type: Boolean, default: true },
  disableContinue: { type: Boolean, default: false }
})
defineEmits(['back', 'continue'])
</script>

<style scoped>
.nav-area {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 2.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid var(--border-subtle);
}
.nav-back {
  background: none;
  border: none;
  font-family: inherit;
  font-size: 0.85rem;
  color: var(--ink-faint);
  cursor: pointer;
  padding: 0.75rem 0;
  transition: color 0.2s ease;
  -webkit-tap-highlight-color: transparent;
}
.nav-back:hover { color: var(--ink); }
.nav-back:disabled { opacity: 0; cursor: default; }
.nav-continue {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.85rem 2rem;
  background: var(--ochre);
  color: white;
  border: none;
  border-radius: 100px;
  font-family: inherit;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.25s ease;
  -webkit-tap-highlight-color: transparent;
}
.nav-continue:hover { background: var(--ochre-light); transform: translateY(-1px); }
.nav-continue:disabled { opacity: 0.35; cursor: not-allowed; transform: none; }
.nav-continue .arrow { transition: transform 0.2s ease; }
.nav-continue:hover:not(:disabled) .arrow { transform: translateX(3px); }

@media (max-width: 480px) {
  .nav-continue {
    padding: 0.85rem 1.5rem;
    font-size: 0.85rem;
  }
}
</style>
