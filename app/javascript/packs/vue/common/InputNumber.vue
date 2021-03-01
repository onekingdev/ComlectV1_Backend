<template lang="pug">
  div
    label.form-label
      slot
    input.form-control(v-bind="config" @input="$emit('input', $event.target.value)" type="number")
    Errors(:errors="errors")
</template>

<script>
export default {
  props: {
    value: Number,
    errors: Array,
    placeholder: String
  },
  computed: {
    config() {
      return {
        value: this.value,
        placeholder: this.placeholder
      }
    }
  }
}
</script>

<style scoped>
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
input[type=number] {
  -moz-appearance: textfield;
}
</style>