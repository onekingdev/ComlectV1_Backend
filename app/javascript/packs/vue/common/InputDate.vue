<template lang="pug">
  div
    label(:class="labelKlass")
      slot

    DatePicker(
      :value="value"
      :options="options"
      :placeholder="placeholder"
      @input="$emit('input', $event)"
    )
    Errors(:errors="errors")
</template>

<script>
export default {
  props: {
    value: String,
    errors: Array,
    placeholder: String,

    labelKlass: {
      type: String,
      default: "form-label"
    },

    options: {
      type: Object,
      default: () => ({})
    }
  }
}
</script>
