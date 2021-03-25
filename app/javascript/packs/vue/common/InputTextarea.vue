<template lang="pug">
  div
    label.form-label
      slot
    textarea.form-control(v-bind="{value,placeholder,rows}" @input="$emit('input', $event.target.value)")
    Errors(:errors="errors")
</template>

<script>
export default {
  props: {
    value: String,
    errors: Array,
    placeholder: String,
    rows: {
      type: Number,
      default: 3
    }
  }
}
</script>