<template lang="pug">
  span
    span(v-for="(_, i) in starsActive" :key="`${i}_y`") ⭐
    span(v-for="(_, i) in starsInactive" :key="`${i}_n`") ❌
</template>

<script>
const DEFAULT_MAX = 5

export default {
  props: {
    stars: {
      type: Number,
      required: true
    },
    max: {
      type: Number,
      default: DEFAULT_MAX
    }
  },
  computed: {
    starsActive() {
      return Array(this.stars)
    },
    starsInactive() {
      const length = this.max - this.stars
      return Array(length > 0 ? length : 0)
    }
  }
}
</script>