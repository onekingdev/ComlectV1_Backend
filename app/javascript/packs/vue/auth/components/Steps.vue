<template lang="pug">
  .steps
    .step(v-for="(step, i) in steps" :class="i+1 <= currentStep ? 'active' : ''")
      h4.step__name {{ i + 1 }}. {{ step }}
</template>

<script>
  export default {
    props: ['currentStep', 'steps'],
    computed: {
      currentStepComp () {
        const step = this.currentStep
        return step
      }
    }
  }
</script>

<style scoped>

</style>
