<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="5" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The reframe</p>
    <h2 class="display-medium">The Philosophy of Human Respect is the position that takes human nature seriously.</h2>
    <Divider />

    <p class="body-text-large">The naive position is believing that the same species that produces corruption, regulatory capture, civil forfeiture, and permanent bureaucratic expansion will somehow behave differently when given more power.</p>

    <p class="body-text">The realist position is designing a system around what we actually know about people: they respond to incentives. So the question becomes — what incentive structure produces the best outcomes?</p>

    <div class="comparison">
      <div class="compare-block coercive">
        <div class="compare-label">Coercive systems</div>
        <p>Reward political maneuvering. Externalize costs to people who can't fight back. Concentrate power in the hands of whoever wins the contest to control it. Create a permanent war over who gets to use the machinery of force.</p>
      </div>
      <div class="compare-block voluntary">
        <div class="compare-label">Voluntary systems</div>
        <p>Reward people for serving others well enough that others choose to pay them. Internalize costs to the people who create them. Distribute power across millions of individual decisions. Replace the war for control with competition to earn trust.</p>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>In voluntary systems, a bad actor can only harm the people who choose to interact with them. In coercive systems, a bad actor with political power can harm millions who never chose to be subject to their authority. The question is not whether bad actors exist. They do. The question is which system limits the damage they can do.</p>
    </ContentBlock>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.comparison { margin: 2rem 0; display: flex; flex-direction: column; gap: 1rem; }
.compare-block { padding: 1.25rem 1.5rem; border-radius: var(--radius); }
.compare-block p { margin: 0; font-size: 0.9rem; line-height: 1.7; }
.compare-block.coercive { background: var(--concede-bg); border-left: 3px solid var(--concede-warm); }
.compare-block.coercive p { color: var(--ink-muted); }
.compare-block.voluntary { background: var(--insight-bg); border-left: 3px solid var(--insight-green); }
.compare-block.voluntary p { color: var(--ink-muted); }
.compare-label { font-size: 0.68rem; letter-spacing: 0.1em; text-transform: uppercase; font-weight: 600; margin-bottom: 0.5rem; }
.coercive .compare-label { color: var(--concede-warm); }
.voluntary .compare-label { color: var(--insight-green); }
</style>
