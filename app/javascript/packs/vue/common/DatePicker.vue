<template lang="pug">
  b-input-group.mb-1
    b-form-input(v-bind="datepickerOptions" @input="input")
    b-input-group-append
      b-form-datepicker.d-none(v-bind="datepickerOptions" @input="input" :show-decade-nav="false" :hide-header="true" locale="en-US" button-only right)
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
        dateFormatOptions: { year: 'numeric', month: 'numeric', day: 'numeric' },
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
