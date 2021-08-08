<template lang="pug">
  span
    img.img-avatar(v-if="src" :src="src")
    span.avatar-placeholder(v-else :class="{ sm: sm, bgLight: bgLight, size40: size40 } ") {{placeholderText}}
</template>

<script>
const initialSymbol = str => (typeof str === "string" && str[0]) || ''

export default {
  props: {
    user: Object,
    business: Object,
    sm: Boolean,
    bgLight: Boolean,
    size40: Boolean,
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
.avatar-placeholder.bgLight {
  background: #E2E8F0;
  color: #303132;
  font-size: 16px;
  line-height: 2.5;
  font-weight: 600;
  letter-spacing: -2px;
}
.avatar-placeholder.size40{
  height: 2.5rem;
  width: 2.5rem;
}
.sm {
  height: 1.5625rem; /* 25px */
  width: 1.5625rem;
  max-height: 1.5625rem;
  max-width: 1.5625rem;
  line-height: 2.5em;
  font-size: .7rem;
}
</style>
