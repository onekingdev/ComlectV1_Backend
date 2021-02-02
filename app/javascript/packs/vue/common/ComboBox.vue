<template lang="pug">
  Treeselect(@input="input" v-bind="args")
</template>

<script>
export default {
  props: {
    value: {},
    placeholder: String,
    options: {}
  },
  methods: {
    input(val) {
      this.$emit('input', val)
    }
  },
  computed: {
    args() {
      return {
        value: this.value,
        placeholder: this.placeholder,
        options: this.options,
        multiple: false
      }
    }
  }
}
</script>