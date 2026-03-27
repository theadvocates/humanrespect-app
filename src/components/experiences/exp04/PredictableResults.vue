<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The results are in</p>
    <h2 class="display-medium">Every one of these outcomes was predictable from the incentive structure.</h2>
    <Divider />

    <p class="body-text">These are not failures of the system. They are the system working exactly as its incentives dictate.</p>

    <div class="examples">
      <div v-for="ex in examples" :key="ex.id" class="example-card" :class="{ expanded: expanded === ex.id }" @click="toggleExpand(ex.id)">
        <div class="example-header">
          <div class="example-title">{{ ex.title }}</div>
          <div class="example-toggle">{{ expanded === ex.id ? '−' : '+' }}</div>
        </div>
        <div v-if="expanded === ex.id" class="example-body">
          <p class="example-incentive"><strong>The incentive:</strong> {{ ex.incentive }}</p>
          <p class="example-result"><strong>The result:</strong> {{ ex.result }}</p>
          <p class="example-prediction">{{ ex.prediction }}</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>None of these required corruption in the traditional sense. The people involved were often acting rationally within the incentive structure they were given. The problem is the structure itself: when you reward political actors for expanding their authority, they expand it. When you shield them from the costs of their decisions, they make worse decisions. When you give them the power to reward allies with other people's money, they do exactly that.</p>
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
const expanded = ref(null)
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

function toggleExpand(id) {
  expanded.value = expanded.value === id ? null : id
}

const examples = [
  {
    id: 'regulatory-capture',
    title: 'Regulatory capture',
    incentive: 'Industries being regulated have billions at stake. Regulators have modest salaries and career ambitions. The regulated have every incentive to hire, fund, and influence the regulators.',
    result: 'Major banks write their own financial regulations. Pharmaceutical companies staff the FDA. Telecom giants shape FCC policy. The agencies created to protect the public become tools of the industries they oversee.',
    prediction: 'Anyone who understands self-interest would predict this. Give one group the power to write rules for another, and the group with the most at stake will capture the rule-writers.'
  },
  {
    id: 'civil-forfeiture',
    title: 'Civil asset forfeiture',
    incentive: 'Police departments get to keep property they seize from suspects. No conviction required. The seized assets fund department budgets.',
    result: 'In many jurisdictions, police seize more property from citizens than burglars do. People who are never charged with a crime lose their cars, homes, and savings. The burden of proof falls on the victim to prove their property is "innocent."',
    prediction: 'Tell any group of humans they can take other people\'s property and keep it, with minimal oversight. The outcome is obvious.'
  },
  {
    id: 'lobbying',
    title: 'Political lobbying',
    incentive: 'A $1 million lobbying investment can yield $100 million in favorable legislation. Political access is the highest-return investment available.',
    result: 'The lobbying industry spends over $4 billion per year in the US alone. Corporations write legislation that their lobbyists hand to legislators. The return on lobbying investment dwarfs the return on productive investment.',
    prediction: 'When you create a system where political favors are worth billions, people will spend billions to obtain them. The incentive makes this inevitable.'
  },
  {
    id: 'war',
    title: 'Military expansion',
    incentive: 'The people who decide to go to war never fight in it. Defense contractors profit from it. Politicians who appear "strong on defense" win elections. The costs are externalized to soldiers, taxpayers, and foreign civilians.',
    result: 'The United States has been at war for the majority of its existence. The defense budget exceeds the next several countries combined. Wars are started based on false or exaggerated intelligence and continue long after any strategic justification has evaporated.',
    prediction: 'Separate the people who benefit from war from the people who bear its costs, and wars will be frequent and prolonged. This is basic incentive economics.'
  },
  {
    id: 'welfare',
    title: 'Permanent dependency',
    incentive: 'Politicians gain votes by providing benefits. Agencies gain budgets by having more recipients. Reducing dependency means reducing the political constituency and the agency\'s reason to exist.',
    result: 'Programs designed to be temporary become permanent. Eligibility requirements are structured to penalize earning more income. Trillions spent on poverty programs over decades with minimal reduction in poverty rates. The bureaucracy grows while the problem persists.',
    prediction: 'When the people running a program benefit from the problem continuing, the problem will continue. The incentive to solve it is weaker than the incentive to manage it.'
  }
]
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.examples { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.example-card { background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; overflow: hidden; -webkit-tap-highlight-color: transparent; }
.example-card:hover { border-color: var(--ochre); }
.example-card.expanded { border-color: var(--ochre); }
.example-header { display: flex; justify-content: space-between; align-items: center; padding: 0.85rem 1.1rem; }
.example-title { font-family: var(--serif); font-size: 0.95rem; font-weight: 500; color: var(--ink); }
.example-toggle { font-size: 1.2rem; color: var(--ochre); font-weight: 300; flex-shrink: 0; width: 24px; text-align: center; }
.example-body { padding: 0 1.1rem 1.1rem; }
.example-body p { font-size: 0.85rem; line-height: 1.65; color: var(--ink-muted); margin: 0 0 0.75rem; }
.example-body p:last-child { margin-bottom: 0; }
.example-incentive strong, .example-result strong { color: var(--ink); }
.example-prediction { font-style: italic; color: var(--ink-faint) !important; }
</style>
