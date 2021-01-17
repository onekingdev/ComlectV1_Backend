<template lang="pug">
  b-form-datepicker(v-bind="options" @input="input")
</template>

<script>
export default {
  props: {
    value: {},
    placeholder: {}
  },
  methods: {
    input(val) {
      this.$emit('input', val)
    }
  },
  computed: {
    options() {
      return {
        dateFormatOptions: { year: 'numeric', month: 'numeric', day: 'numeric' },
        placeholder: this.placeholder,
        value: this.value,
        hideHeader: true
      }
    }
  }
}
</script>