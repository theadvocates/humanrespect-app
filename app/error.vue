<template>
  <div class="not-found">
    <div class="not-found-inner">
      <h1 class="display-medium">This page doesn't exist.</h1>
      <p class="body-text" style="margin-top: 1rem;">But the thought experiment does.</p>
      <router-link to="/" class="home-link">Return home →</router-link>
    </div>
  </div>
</template>

<style scoped>
.not-found {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 2rem;
}
.not-found-inner { max-width: 400px; }
.home-link {
  display: inline-block;
  margin-top: 2rem;
  font-family: var(--serif);
  font-size: 1rem;
  color: var(--ochre);
  border-bottom: 1px solid transparent;
  transition: border-color 0.3s ease;
}
.home-link:hover { border-bottom-color: var(--ochre); }
</style>
