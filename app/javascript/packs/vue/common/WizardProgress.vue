<template lang="pug">
  b-row(no-gutters)
    .col-sm.bg-dark.text-light(v-for="(label, i) in stepsActive" :key="label")
      b {{1+i}}. {{label}}
    .col-sm(v-for="(label, i) in stepsInactive" :key="label")
      | {{1+i+stepsActive.length}}. {{label}}
</template>

<script>
export default {
  props: {
    step: {
      type: String,
      required: true
    },
    steps: {
      type: Array,
      required: true
    }
  },
  computed: {
    stepsActive() {
      return this.steps.slice(0, 1 + this.steps.indexOf(this.step))
    },
    stepsInactive() {
      return this.steps.slice(1 + this.steps.indexOf(this.step))
    }
  }
}
</script>