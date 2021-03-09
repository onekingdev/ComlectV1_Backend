<template lang="pug">
  span(v-if="everythingLoaded")
    slot(v-bind="slotProps")
</template>

<script>
import Vue from 'vue'

export default {
  props: {
    callback: Function
  },
  data() {
    return {
      slotProps: {}
    }
  },
  created() {
    Object.keys(this.$attrs).map(prop => fetch(this.$attrs[prop], { headers: {'Accept': 'application/json'}})
          .then(response => response.json())
          .then(result => Vue.set(this.slotProps, prop, this.callback ? this.callback(result) : result)))
  },
  computed: {
    everythingLoaded() {
      const totalProps = Object.keys(this.$attrs).length,
            setProps = Object.keys(this.slotProps).length,
            nonEmptyProps = Object.values(this.slotProps).filter(o => typeof(o) === "object").length
      return totalProps === setProps && setProps === nonEmptyProps
    }
  }
}
</script>