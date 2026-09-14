<template>
  <!-- The plate for one experience, captioned with its number and name. -->
  <Plate :name="name" :dark="dark" :bare="bare" :alt="`${PLATE_TITLE[name]}, an engraving`">
    <template v-if="!bare"><b>Plate {{ numeral }}</b> · <i>{{ PLATE_TITLE[name] }}.</i>{{ note ? ' ' + note : '' }}</template>
  </Plate>
</template>

<script setup>
import { computed } from 'vue'
import Plate from '@/components/shared/Plate.vue'
import { PLATE_FOR, PLATE_TITLE, plateNumeral } from '@/utils/plates.js'

const props = defineProps({
  id: { type: String, required: true },
  dark: { type: Boolean, default: false },
  bare: { type: Boolean, default: false },
  /** An extra sentence after the plate's name. */
  note: { type: String, default: '' }
})
const name = computed(() => PLATE_FOR[props.id])
const numeral = computed(() => plateNumeral(props.id))
</script>
