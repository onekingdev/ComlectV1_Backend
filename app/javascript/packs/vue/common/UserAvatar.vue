<template lang="pug">
  span
    img.img-avatar(v-if="src" :src="src")
    span.avatar-placeholder(v-else :class="{ sm: sm } ") {{placeholderText}}
</template>

<script>
const initialSymbol = str => (typeof str === "string" && str[0]) || ''

export default {
  props: {
    user: Object,
    business: Object,
    sm: Boolean,
  },
  computed: {
    src() {
      return (this.user && this.user.photo) || (this.business && this.business.logo)
    },
    placeholderText() {
      return this.user
        ? `${initialSymbol(this.user.first_name)} ${initialSymbol(this.user.last_name)}`
        : initialSymbol(this.business.business_name)
    }
  }
}
</script>

<style scoped>
.img-avatar {
  max-height: 3em;
  max-width: 3em;
  border-radius: 1.5em;
}
.avatar-placeholder {
  display: inline-block;
  border-radius: 1.5em;
  height: 3em;
  width: 3em;
  background: #303132;
  line-height: 3em;
  color: white;
  text-align: center;
}
.sm {
  height: 1.5625rem; /* 25px */
  width: 1.5625rem;
  max-height: 1.5625rem;
  max-width: 1.5625rem;
  line-height: 2em;
}
</style>
