<template lang="pug">
  Treeselect(@input="input" v-bind="args")
    template(v-if="idAsLabel" v-slot:value-label="{node}") {{node.id}}
</template>

<script>
export default {
  props: {
    value: {},
    placeholder: String,
    options: {},
    idAsLabel: {
      type: Boolean,
      default: false
    },
    treeProps: {
      type: Object,
      default: () => ({})
    },
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
        multiple: this.multiple,
        ...this.treeProps
      }
    }
  }
}
</script>