<template>
  <div class="about">
    <div class="about-inner">
      <h1 class="display-medium">About Human Respect</h1>
      <div style="width: 40px; height: 1px; background: var(--ochre); margin: 2rem 0; opacity: 0.4;"></div>
      <p class="body-text-large">The Philosophy of Human Respect was articulated by Chris J. Rufer. It begins with an observation about human nature — that happiness, harmony, and prosperity decrease when people experience the initiation of violence or the theft of their property through force or fraud — and asks what a society built on voluntary cooperation might look like.</p>
      <p class="body-text" style="margin-top: 1.5rem;">This platform explores that question through interactive experiences designed to surface your own moral reasoning, not to tell you what to think.</p>
      <router-link to="/" class="home-link" style="display: inline-block; margin-top: 2rem; font-family: var(--serif); color: var(--ochre);">← Back to home</router-link>
    </div>
  </div>
</template>

<style scoped>
.about {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
}
.about-inner { max-width: 560px; }
</style>
