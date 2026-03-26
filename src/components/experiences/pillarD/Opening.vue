<template>
  <div class="opening stagger" ref="el">
    <span class="overline">Pillar · The Human Respect Method</span>
    <h1 class="display-large headline">
      Your values aren't<br><em>the problem.</em>
    </h1>
    <Divider :centered="true" />
    <p class="subtitle">
      Progressive or conservative, your deepest values are genuine expressions of
      what you believe makes life good. The question the Philosophy of Human Respect
      asks isn't <em>what</em> you value — it's how you propose to advance it.
    </p>
    <button class="begin-btn" @click="$emit('advance')">
      Continue <span class="arrow">→</span>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Divider from '@/components/shared/Divider.vue'
defineEmits(['advance'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.opening { text-align: center; padding: 2rem 0; }
.overline {
  font-size: 0.75rem; letter-spacing: 0.15em; text-transform: uppercase;
  color: var(--ochre-light); margin-bottom: 2rem; display: block;
}
.headline { color: #F0EBE3; font-weight: 500; }
.headline em { color: rgba(240,235,227,0.85); font-weight: 400; font-style: italic; }
.subtitle {
  font-family: var(--sans); font-size: 1rem; line-height: 1.8;
  color: rgba(240,235,227,0.65); max-width: 500px; margin: 0 auto;
}
.subtitle em { color: rgba(240,235,227,0.8); }
.begin-btn {
  display: inline-block; margin-top: 3rem; padding: 1rem 3rem;
  background: transparent; color: var(--ochre-light); border: 1px solid var(--ochre-light);
  border-radius: 100px; font-family: var(--serif); font-size: 1rem; font-weight: 500;
  cursor: pointer; transition: all 0.3s ease; letter-spacing: 0.05em;
  -webkit-tap-highlight-color: transparent;
}
.begin-btn:hover { background: var(--ochre-light); color: var(--bg-dark); }
.begin-btn .arrow { display: inline-block; transition: transform 0.3s ease; }
.begin-btn:hover .arrow { transform: translateX(4px); }
</style>
