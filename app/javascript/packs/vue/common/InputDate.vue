<template lang="pug">
  div
    label.form-label
      slot
    DatePicker(:value="value" @input="$emit('input', $event)" :placeholder="placeholder")
    Errors(:errors="errors")
</template>

<script>
export default {
  props: {
    value: String,
    errors: Array,
    placeholder: String
  }
}
</script>