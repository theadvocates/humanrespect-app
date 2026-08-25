<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="7" />
    <p class="caption" style="margin-bottom: 1.5rem;">The results</p>
    <h2 class="display-medium">When you give flawed humans coercive power over other humans, the damage follows the same pattern every time.</h2>
    <Divider />

    <p class="body-text">Each of these is a story about one of the three domains of integrity you identified in your own life — body, resources, or time. In every case, the people with power did exactly what your model of human nature predicts.</p>

    <div class="examples">
      <div v-for="ex in examples" :key="ex.id" class="example-card" :class="{ expanded: expanded === ex.id }" @click="toggleExpand(ex.id)">
        <div class="example-header">
          <div>
            <div class="example-title">{{ ex.title }}</div>
            <div class="example-domain">{{ ex.domain }}</div>
          </div>
          <div class="example-toggle">{{ expanded === ex.id ? '−' : '+' }}</div>
        </div>
        <div v-if="expanded === ex.id" class="example-body">
          <p class="example-story">{{ ex.story }}</p>
          <p class="example-mechanism">{{ ex.mechanism }}</p>
          <p class="example-prediction">{{ ex.prediction }}</p>
        </div>
      </div>
    </div>

    <ContentBlock variant="insight">
      <p>These are not failures of bad people. They are the predictable consequences of the incentive structure itself. Give any group of humans the power to write rules for others, take their property, or restrict their freedom — with minimal personal cost for getting it wrong — and these outcomes follow as reliably as water flows downhill.</p>
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
    id: 'mandatory-min',
    title: 'The judge who couldn\'t judge',
    domain: 'Bodily integrity',
    story: 'A first-time offender, a young father who made a single terrible decision, stands before a judge. The judge has read the case. She knows the circumstances — the man\'s addiction, his children, his employer who wants him back. She knows that a short sentence with treatment would give him a real chance. But her hands are tied. A mandatory minimum, written by legislators who never met this man and never will, requires her to sentence him to fifteen years.',
    mechanism: 'The people who wrote the sentencing law will never see its consequences. They wrote it to appear "tough on crime" before an election. The judge who sees the human cost has no power to change it. The man\'s children will grow up without a father — not because justice required it, but because the incentives of the people who wrote the law had nothing to do with justice.',
    prediction: 'Separate the people who write the rules from the people who live under them, and the rules will serve the rule-writers. This is what you said about human nature. Applied consistently, it predicts exactly this.'
  },
  {
    id: 'seized-home',
    title: 'The house that wasn\'t for sale',
    domain: 'Material integrity',
    story: 'A woman has lived in her house for forty years. She raised her children there. Her husband died there. The city decides her neighborhood would generate more tax revenue as a shopping center. They invoke eminent domain — the legal power to take private property for "public use." She doesn\'t want to sell. The amount they offer doesn\'t cover a comparable home. It doesn\'t matter. The city takes her house, demolishes it, and hands the land to a private developer. The shopping center is never built. The lot sits empty for a decade.',
    mechanism: 'The developer who lobbied for the project had everything to gain and nothing to lose. The city officials who approved it would benefit from higher tax revenue projections. The woman who lost her home had no leverage against either. Her property — forty years of her life made physical — was taken by people who had the legal power to do it and the political incentive to use it.',
    prediction: 'You said people favor their own group and act in their own interest. The developer and the politicians were in the same group. The homeowner was not.'
  },
  {
    id: 'family-separation',
    title: 'The children who needed protection from their protectors',
    domain: 'Bodily integrity + connection',
    story: 'A mother lets her nine-year-old walk three blocks to a park in a safe neighborhood. A stranger calls the police. Child protective services investigates. The children are temporarily removed while the case is processed. The mother — who has never harmed her children — spends four months navigating a bureaucratic system designed to protect children, fighting to get her own children back. During those months, the children live with strangers.',
    mechanism: 'The caseworker followed protocol. The protocol was written by people who face consequences for under-reacting (a child harmed on their watch) but not for over-reacting (a family destroyed by excessive intervention). The incentive structure guarantees over-intervention — because the bureaucrat\'s career is at risk if they miss something, but no one\'s career is at risk if they tear apart a healthy family.',
    prediction: 'You said people prioritize short-term rewards over long-term consequences. For the caseworker, the short-term reward is protecting their own career. The long-term consequence — a family traumatized, children who learn that authority figures can take them from their parents at any moment — falls on someone else entirely.'
  },
  {
    id: 'cant-help',
    title: 'The volunteers who were told to stop helping',
    domain: 'Temporal integrity + cooperation',
    story: 'A hurricane devastates a coastal city. Within hours, hundreds of people with boats drive to the area and start pulling families out of flooded homes. Then official emergency management arrives and orders the volunteer rescuers to stop. They don\'t have proper credentials. Their boats haven\'t been inspected. They haven\'t completed the required safety training. While the paperwork is sorted out, people wait on rooftops.',
    mechanism: 'The emergency management officials aren\'t malicious. They\'re following rules designed by people who prioritized institutional liability over human lives. The rules exist to protect the agency from lawsuits, not to protect the people drowning. When the incentive is "don\'t let anything happen that could be blamed on us," the rational response is to prevent anyone from acting without authorization — even when unauthorized action is saving lives.',
    prediction: 'You said good intentions frequently produce bad outcomes when the incentives are wrong. The people who wrote the emergency management regulations genuinely intended to ensure safe, coordinated rescue. The result was a system that stopped the fastest, most effective help from reaching the people who needed it.'
  },
  {
    id: 'poverty-trap',
    title: 'The woman who couldn\'t afford to earn more',
    domain: 'Temporal integrity + autonomy',
    story: 'A single mother on government assistance gets a job offer that would pay $2,400 more per year than her current income. She does the math. The raise would cost her $4,100 in lost benefits — housing subsidy, childcare assistance, food support. Taking the job would make her family poorer. So she turns it down. She\'s not lazy. She\'s trapped by a system that penalizes the very steps that would move her toward independence.',
    mechanism: 'The programs were designed by people who would never personally experience their structure. No legislator has ever had to calculate whether a raise would trigger a benefits cliff that leaves their children hungry. The perverse incentive — that earning more means losing more — exists because the people who designed it bear no cost when it fails. Their metric is "number of people served," not "number of people who escaped the need for service."',
    prediction: 'You said people who gain power tend to use it to benefit themselves. The agencies that administer these programs grow their budgets based on the number of recipients. A program that successfully moved everyone to independence would eliminate its own funding. The institutional incentive is to manage poverty, not end it.'
  }
]
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.examples { margin: 2rem 0; display: flex; flex-direction: column; gap: 0.5rem; }
.example-card { background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; overflow: hidden; -webkit-tap-highlight-color: transparent; }
.example-card:hover { border-color: var(--ochre); }
.example-card.expanded { border-color: var(--ochre); }
.example-header { display: flex; justify-content: space-between; align-items: flex-start; padding: 0.85rem 1.1rem; gap: 0.75rem; }
.example-title { font-family: var(--serif); font-size: 0.95rem; font-weight: 500; color: var(--ink); }
.example-domain { font-size: 0.7rem; color: var(--ochre); letter-spacing: 0.05em; margin-top: 0.15rem; }
.example-toggle { font-size: 1.2rem; color: var(--ochre); font-weight: 300; flex-shrink: 0; width: 24px; text-align: center; }
.example-body { padding: 0 1.1rem 1.1rem; }
.example-body p { font-size: 0.85rem; line-height: 1.7; color: var(--ink-muted); margin: 0 0 0.85rem; }
.example-body p:last-child { margin-bottom: 0; }
.example-story { color: var(--ink) !important; }
.example-mechanism { }
.example-prediction { font-style: italic; color: var(--ink-faint) !important; }
</style>
