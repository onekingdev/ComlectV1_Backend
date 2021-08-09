<template lang="pug">
  .steps
    .step.active(v-for="(label, i) in stepsActive" :key="label")
      h4.step__name {{1+i}}. {{label}}
    .step(v-for="(label, i) in stepsInactive" :key="label")
      h4.step__name {{1+i+stepsActive.length}}. {{label}}
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
