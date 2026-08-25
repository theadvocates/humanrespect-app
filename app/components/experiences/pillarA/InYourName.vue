<template>
  <div class="screen-inner stagger" ref="el">
    <StepDots :current="3" :total="6" />
    <p class="caption" style="margin-bottom: 1.5rem;">The uncomfortable question</p>
    <h2 class="display-medium">Right now, who is being threatened with physical force on your behalf?</h2>
    <Divider />

    <p class="body-text">You would never personally harm any of these people. But the system you participate in does, every day, in your name. Check each situation where government agents use or threaten physical force to enforce a policy you accept.</p>

    <div class="situations">
      <button
        v-for="item in situations"
        :key="item.id"
        class="item-card"
        :class="{ selected: selected.includes(item.id) }"
        @click="toggle(item.id)"
      >
        <span class="item-check">{{ selected.includes(item.id) ? '✓' : '' }}</span>
        <div class="item-content">
          <span class="item-label">{{ item.label }}</span>
          <span class="item-detail">{{ item.detail }}</span>
        </div>
      </button>
    </div>

    <div v-if="selected.length > 0" class="reflection">
      <ContentBlock variant="mirror">
        <p>You checked {{ selected.length }} situations. In each one, a person who has not harmed anyone else faces the threat of armed agents entering their home, restraining their body, and putting them in a cage. You would never do this to them personally. But you participate in a system that does it for you.</p>
      </ContentBlock>

      <p class="body-text">The philosophy doesn't claim these people are all blameless, or that every law is unjust. It asks a simpler question: for each of these situations, is the threat of bodily force truly necessary? Or could the same goal be achieved without it?</p>
    </div>

    <NavBar :can-go-back="true" :disable-continue="selected.length === 0" @back="$emit('back')" @continue="$emit('advance')" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import StepDots from '@/components/shared/StepDots.vue'
import Divider from '@/components/shared/Divider.vue'
import ContentBlock from '@/components/shared/ContentBlock.vue'
import NavBar from '@/components/shared/NavBar.vue'
import { useAnalytics } from '@/composables/useAnalytics'

defineEmits(['advance', 'back'])
const { trackChoice } = useAnalytics()
const el = ref(null)
const selected = ref([])
onMounted(() => requestAnimationFrame(() => el.value?.classList.add('animate')))

const situations = [
  { id: 'drug-user', label: 'A person using marijuana in their own home', detail: 'Faces arrest, prosecution, and imprisonment in most jurisdictions.' },
  { id: 'tax-refuser', label: 'A person who refuses to pay taxes', detail: 'Faces wage garnishment, asset seizure, and eventually armed agents at their door.' },
  { id: 'unlicensed-worker', label: 'A person braiding hair or selling food without a license', detail: 'Faces fines, forced closure, and arrest for operating without government permission.' },
  { id: 'raw-milk', label: 'A farmer selling raw milk to willing buyers', detail: 'In many states, faces raids by armed agents for a voluntary transaction between adults.' },
  { id: 'homeschool', label: 'A parent educating their child outside approved methods', detail: 'In some jurisdictions, faces fines, custody threats, and truancy enforcement.' },
  { id: 'building-code', label: 'A homeowner building a shed on their own property', detail: 'Without a permit, faces fines, forced demolition, and liens on their home.' },
  { id: 'immigrant', label: 'A person who crossed a border to work and feed their family', detail: 'Faces detention, separation from children, and deportation by armed agents.' },
  { id: 'gun-owner', label: 'A person possessing a firearm that violates a regulation', detail: 'Faces felony charges and imprisonment even with no intent to harm anyone.' },
]

function toggle(id) {
  const idx = selected.value.indexOf(id)
  if (idx === -1) selected.value.push(id)
  else selected.value.splice(idx, 1)
  trackChoice('pillarA', 'in-your-name', selected.value.join(','))
}
</script>

<style scoped>
.screen-inner { padding: 0 0.5rem; }
.situations { margin: 1.5rem 0; display: flex; flex-direction: column; gap: 0.4rem; }
.item-card { display: flex; align-items: flex-start; gap: 0.75rem; width: 100%; padding: 0.75rem 1rem; background: var(--cream); border: 1.5px solid var(--border-subtle); border-radius: var(--radius); cursor: pointer; transition: all 0.2s ease; text-align: left; font-family: inherit; font-size: 0.88rem; line-height: 1.5; color: var(--ink); -webkit-tap-highlight-color: transparent; }
.item-card:hover { border-color: var(--concede-warm); }
.item-card.selected { border-color: var(--concede-warm); background: var(--concede-bg); }
.item-check { flex-shrink: 0; width: 18px; height: 18px; border: 1.5px solid var(--border-subtle); border-radius: 3px; display: flex; align-items: center; justify-content: center; font-size: 0.65rem; color: var(--concede-warm); margin-top: 2px; transition: all 0.2s; }
.item-card.selected .item-check { background: var(--concede-warm); border-color: var(--concede-warm); color: white; }
.item-content { flex: 1; }
.item-label { display: block; font-weight: 500; font-size: 0.88rem; }
.item-detail { display: block; font-size: 0.72rem; color: var(--ink-faint); margin-top: 0.15rem; }
.reflection { margin-top: 1.5rem; }
</style>
