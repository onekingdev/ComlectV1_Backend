<template lang="pug">
  div
    label.form-label
      slot
    p: span(v-for="i in [1, 2, 3, 4, 5]" @click="clicked(i)" class="cursor-pointer")
      span(v-if="value >= i") ⭐
      span(v-else) ⚪
    Errors(:errors="errors")
</template>

<script>
export default {
  props: {
    value: Number,
    errors: Array,
  },
  methods: {
    clicked(i) {
      this.$emit('input', (i === 1 && this.value === 1) ? 0 : i)
    }
  }
}
</script>

<style>
.cursor-pointer {
  cursor: pointer;
}
</style>