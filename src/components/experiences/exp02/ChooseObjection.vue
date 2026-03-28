<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="1" :total="8" />
    <p class="caption" style="margin-bottom: 1.5rem;">Your strongest pushback</p>
    <h2 class="display-medium">Which of these is closest to what you're thinking?</h2>
    <Divider />
    <p class="body-text">Pick the one that feels most true to you — the objection you'd make if we were having this conversation in person.</p>

    <div class="choices">
      <button
        v-for="(obj, key) in allObjections"
        :key="key"
        class="objection-card"
        :class="{ selected: chosen === key }"
        @click="choose(key)"
      >
        <div class="objection-title">{{ obj.title }}</div>
        <div class="objection-subtitle">{{ obj.subtitle }}</div>
      </button>
    </div>

    <NavBar :can-go-back="true" :disable-continue="!chosen" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { objections as allObjections } from './objectionData.js'

const emit = defineEmits(['advance', 'back', 'choose-objection'])
const el = ref(null)
const chosen = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function choose(key) {
  chosen.value = key
  emit('choose-objection', key)
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.choices { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.objection-card { width: 100%; text-align: left; padding: 1rem 1.25rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; -webkit-tap-highlight-color: transparent; }
.objection-card:hover { border-color: var(--ochre); }
.objection-card.selected { border-color: var(--ochre); background: var(--ochre-faint); }
.objection-title { font-family: var(--serif); font-size: 0.95rem; font-weight: 500; color: var(--ink); line-height: 1.4; }
.objection-subtitle { font-size: 0.78rem; color: var(--ink-faint); margin-top: 0.2rem; }
</style>
