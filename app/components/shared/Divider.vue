<template>
  <div class="divider" :class="{ centered }"></div>
</template>

<script setup>
defineProps({
  centered: { type: Boolean, default: false }
})
</script>

<style scoped>
.divider {
  width: 40px;
  height: 1px;
  background: var(--ochre);
  margin: 2rem 0;
  opacity: 0.4;
}
.divider.centered {
  margin: 2rem auto;
}
</style>
