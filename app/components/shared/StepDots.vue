<template>
  <div class="step-indicator">
    <div
      v-for="i in total"
      :key="i"
      class="step-dot"
      :class="{
        active: i - 1 === current,
        completed: i - 1 < current
      }"
    />
  </div>
</template>

<script setup>
defineProps({
  current: { type: Number, required: true },
  total: { type: Number, required: true }
})
</script>

<style scoped>
.step-indicator {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-bottom: 2.5rem;
}
.step-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--border-subtle);
  transition: all 0.3s ease;
}
.step-dot.active {
  background: var(--ochre);
  transform: scale(1.3);
}
.step-dot.completed {
  background: var(--ochre-light);
}
.dark-mode .step-dot { background: rgba(255,255,255,0.15); }
.dark-mode .step-dot.active { background: var(--ochre-light); }
</style>
