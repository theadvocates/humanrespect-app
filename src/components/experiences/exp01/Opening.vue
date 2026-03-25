<template>
  <div class="opening stagger" ref="el">
    <span class="overline">A five-minute philosophical experiment</span>
    <h1 class="display-large headline">
      Let's find it.<br><em>Two questions. One mirror.</em>
    </h1>
    <Divider :centered="true" />
    <p class="subtitle">
      You're about to answer two simple questions. Then you'll see them
      side by side — and notice something you've probably never noticed before.
    </p>
    <button class="begin-btn" @click="$emit('advance')">
      Begin <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'

defineEmits(['advance'])

const el = ref(null)
onMounted(() => {
  requestAnimationFrame(() => el.value?.classList.add('animate'))
})
</script>

<style scoped>
.opening {
  text-align: center;
  padding: 2rem 0;
}

.overline {
  font-size: 0.75rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--ochre-light);
  margin-bottom: 2rem;
  display: block;
}

.headline {
  color: #F0EBE3;
  font-weight: 500;
}

.headline em {
  color: rgba(240, 235, 227, 0.85);
  font-weight: 400;
  font-style: italic;
}

.subtitle {
  font-family: var(--sans);
  font-size: 1rem;
  line-height: 1.8;
  color: rgba(240, 235, 227, 0.65);
  max-width: 480px;
  margin: 0 auto;
}

.begin-btn {
  display: inline-block;
  margin-top: 3rem;
  padding: 1rem 3rem;
  background: transparent;
  color: var(--ochre-light);
  border: 1px solid var(--ochre-light);
  border-radius: 100px;
  font-family: var(--serif);
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  letter-spacing: 0.05em;
}

.begin-btn:hover {
  background: var(--ochre-light);
  color: var(--bg-dark);
}

.begin-btn .arrow {
  display: inline-block;
  transition: transform 0.3s ease;
}

.begin-btn:hover .arrow {
  transform: translateX(4px);
}
</style>
