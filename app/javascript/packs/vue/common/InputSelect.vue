<template lang="pug">
  div
    label.form-label
      slot
    select.form-control(:value="value" @input="$emit('input', $event.target.value)" :placeholder="placeholder")
      option(v-for="(label, value) in optionsList" :key="value" :value="value") {{ label }}
    Errors(:errors="errors")
</template>

<script>
export default {
  props: {
    value: [String, Number],
    errors: Array,
    placeholder: String,
    options: {
      type: [Array, Object],
      required: true
    }
  },
  computed: {
    optionsList() {
      return this.areOptionsIdLabelObjects
        ? Object.fromEntries(this.options.map(({ id, label }) => [id, label]))
        : this.options
    },
    areOptionsIdLabelObjects() {
      return this.options[0] && this.options[0].id && this.options[0].label
    }
  }
}
</script>