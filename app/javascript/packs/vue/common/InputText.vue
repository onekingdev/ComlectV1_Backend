<template lang="pug">
  div
    label.form-label
      slot
    input.form-control(:value="value" @input="$emit('input', $event.target.value)" type="text" :placeholder="placeholder")
    Errors(:errors="errors")
</template>

<script>
export default {
  props: {
    value: [String, Number],
    errors: Array,
    placeholder: String
  }
}
</script>