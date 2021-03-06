<template lang="pug">
  b-form-datepicker(v-bind="options" @input="input" :show-decade-nav="false" :hide-header="true")
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
        dateFormatOptions: { year: 'numeric', month: 'numeric', day: 'numeric', weekday: 'narrow' },
        placeholder: 'MM/DD/YYYY',
        value: this.value,
        hideHeader: true,
        showDecadeNav: false
      }
    }
  }
}
</script>