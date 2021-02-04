<template lang="pug">
  Treeselect(@input="input" v-bind="args")
</template>

<script>
export default {
  props: {
    value: {},
    placeholder: String,
    options: {},
    multiple: {
      type: Boolean,
      default: false
    }
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
        // @see defining options: https://vue-treeselect.js.org/#basic-features
        options: this.options,
        multiple: this.multiple
      }
    }
  }
}
</script>