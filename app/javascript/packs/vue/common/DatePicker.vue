<template lang="pug">
  b-form-datepicker(v-bind="datepickerOptions" @input="input" :show-decade-nav="false" :hide-header="true")
</template>

<script>
export default {
  props: {
    value: {},
    options: {
      type: Object,
      default: () => ({})
    }
  },
  methods: {
    input(val) {
      this.$emit('input', val)
    }
  },
  computed: {
    datepickerOptions() {
      return {
        dateFormatOptions: { year: 'numeric', month: 'numeric', day: 'numeric', weekday: 'narrow' },
        placeholder: 'MM/DD/YYYY',
        value: this.value,
        hideHeader: true,
        showDecadeNav: false,
        ...this.options
      }
    }
  }
}
</script>