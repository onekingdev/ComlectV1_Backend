<template lang="pug">
  b-form-datepicker(v-bind="options" @input="input")
</template>

<script>
export default {
  props: {
    value: {},
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
        placeholder: 'MM/DD/YYYY',
        value: this.value,
        hideHeader: true
      }
    }
  }
}
</script>