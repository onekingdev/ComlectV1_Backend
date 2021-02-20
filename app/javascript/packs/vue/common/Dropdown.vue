<template lang="pug">
  b-form-select(@input="input" v-bind="args")
</template>

<script>
export default {
  props: {
    value: {},
    options: {}
  },
  methods: {
    input(val) {
      this.$emit('input', val)
    }
  },
  computed: {
    args() {
      return {
        value: this.value,
        options: this.options
      }
    }
  }
}
</script>