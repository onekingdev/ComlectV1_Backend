<template lang="pug">
  span
    img.img-avatar(v-if="src" :src="src")
    span.avatar-placeholder(v-else :class="{ sm: sm, bg: bg, bgLight: bgLight, size40: size40, size100: size100 } ") {{placeholderText}}
</template>

<script>
const initialSymbol = str => (typeof str === "string" && str[0]) || ''

export default {
  props: {
    user: Object,
    business: Object,
    sm: Boolean,
    bg: Boolean,
    bgLight: Boolean,
    size40: Boolean,
    size100: Boolean,
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
  border-radius: 50%;
}
.avatar-placeholder {
  display: inline-block;
  border-radius: 50%;
  height: 3em;
  width: 3em;
  background: #E2E8F0;
  line-height: 3;
  color: #303132;
  text-align: center;
  font-weight: 600;
  letter-spacing: -2px;
}
.avatar-placeholder.bgLight {
  background: #E2E8F0;
  color: #303132;
}
.avatar-placeholder.size40{
  height: 2.5rem;
  width: 2.5rem;
}
.avatar-placeholder.size100{
  height: 6.25rem;
  width: 6.25rem;
}
.sm {
  height: 65px;
  width: 65px;
  max-height: 1.5625rem;
  max-width: 1.5625rem;
  line-height: 2em;
  font-size: 12px;
  letter-spacing: -1px;
  /*font-weight: 600;*/
}
.bg {
  height: 6.25rem;
  width: 6.25rem;
  max-height: 6.25rem;
  max-width: 6.25rem;
  line-height: 4em;
  font-size: 25px;
  letter-spacing: -1px;
  /*font-weight: 600;*/
}
</style>
