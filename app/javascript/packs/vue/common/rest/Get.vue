<template lang="pug">
  div(v-if="everythingLoaded")
    slot(v-bind="slotProps")
</template>

<script>
import Vue from 'vue'

export default {
  props: {
    callback: {
      type: Function,
      default: result => result
    },
    etag: {
      type: Number,
      default: Math.random()
    }
  },
  data() {
    return {
      slotProps: {}
    }
  },
  methods: {
    refetch() {
      Object.keys(this.$attrs).map(prop => fetch(this.$attrs[prop], { headers: {'Accept': 'application/json'}})
            .then(response => response.json())
            .then(result => Vue.set(this.slotProps, prop, this.callback(result))))
    }
  },
  computed: {
    everythingLoaded() {
      const totalProps = Object.keys(this.$attrs).length,
            setProps = Object.keys(this.slotProps).length,
            nonEmptyProps = Object.values(this.slotProps).filter(o => typeof(o) === "object").length
      return totalProps === setProps && setProps === nonEmptyProps
    }
  },
  watch: {
    etag: {
      handler: function() {
        this.refetch()
      },
      immediate: true
    }
  }
}
</script>