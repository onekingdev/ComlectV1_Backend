<template lang="pug">
  div
    label.form-label
      slot
    select.form-control(:value="value" @input="$emit('input', $event.target.value)" :placeholder="placeholder")
      option(v-for="(label, value) in options" :key="value" :value="value") {{ label }}
    Errors(:errors="errors")
</template>

<script>
export default {
  props: {
    value: [String, Number],
    errors: Array,
    placeholder: String,
    options: {
      type: Object,
      required: true
    }
  }
}
</script>