<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">What your answers reveal</p>
    <h2 class="display-medium">{{ headline }}</h2>
    <Divider />

    <!-- ALL PERSUASION -->
    <template v-if="allPersuasion">
      <ContentBlock variant="insight">
        <p>You chose persuasion for every issue. You already apply the Human Respect Method consistently — you believe society should advance its goals through voluntary cooperation, not force.</p>
      </ContentBlock>
      <p class="body-text-large">This puts you in a minority. Most people choose persuasion for issues where they disagree with the forced approach — and force for issues they care most about. You've avoided that trap.</p>
    </template>

    <!-- ALL FORCE -->
    <template v-else-if="allForce">
      <ContentBlock variant="mirror">
        <p>You chose force for every issue. You believe government compulsion is the right tool for advancing social goals — across the board.</p>
      </ContentBlock>
      <p class="body-text-large">This is at least consistent. But consider: every issue where you chose force, someone who disagrees with your approach is also having force applied to them. They're being compelled to fund and comply with priorities they didn't choose. How would you feel if their priorities — not yours — were the ones being enforced?</p>
    </template>

    <!-- MIXED (most common) -->
    <template v-else>
      <ContentBlock variant="mirror">
        <p>Look at the pattern in your answers.</p>
        <p v-for="issue in mixedResults" :key="issue.id" style="margin-top: 0.5rem;">
          <strong>{{ issue.label }}:</strong> you chose {{ issue.answer === 'force' ? 'force' : 'persuasion' }}
        </p>
      </ContentBlock>

      <p class="body-text-large">{{ mixedInsight }}</p>

      <ContentBlock variant="insight">
        <p>This is the pattern the Philosophy of Human Respect is designed to reveal. Most people want <em>their</em> values advanced by whatever means necessary — and <em>other people's</em> values advanced only through persuasion. But you can't have it both ways. If you claim the right to force your priorities on others, you've given them the right to force theirs on you.</p>
      </ContentBlock>
    </template>

    <NavBar :can-go-back="true" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, inject, computed, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { issues as allIssues } from './valuesData.js'

defineEmits(['advance', 'back'])
const el = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const methodAnswers = inject('methodAnswers', ref({}))

const forceCount = computed(() => Object.values(methodAnswers.value).filter(v => v === 'force').length)
const persuadeCount = computed(() => Object.values(methodAnswers.value).filter(v => v === 'persuade').length)
const allPersuasion = computed(() => forceCount.value === 0)
const allForce = computed(() => persuadeCount.value === 0)

const headline = computed(() => {
  if (allPersuasion.value) return 'You\'re already consistent.'
  if (allForce.value) return 'You trust force across the board.'
  return 'You chose force for some — and persuasion for others.'
})

const mixedResults = computed(() => {
  return allIssues.map(issue => ({
    id: issue.id,
    label: issue.label,
    answer: methodAnswers.value[issue.id]
  }))
})

const mixedInsight = computed(() => {
  const forceIssues = allIssues.filter(i => methodAnswers.value[i.id] === 'force')
  const persuadeIssues = allIssues.filter(i => methodAnswers.value[i.id] === 'persuade')

  if (forceIssues.every(i => i.lean === 'progressive') && persuadeIssues.every(i => i.lean === 'conservative')) {
    return 'You chose force for progressive goals and persuasion for conservative ones. You want the government to enforce the values you agree with, but not the ones you don\'t.'
  }
  if (forceIssues.every(i => i.lean === 'conservative') && persuadeIssues.every(i => i.lean === 'progressive')) {
    return 'You chose force for conservative goals and persuasion for progressive ones. You want the government to enforce the values you agree with, but not the ones you don\'t.'
  }
  return 'Notice which issues you chose force for and which you chose persuasion. Is there a pattern? Most people choose force for the goals they care about most — and persuasion for the goals they\'re less invested in.'
})
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
</style>
