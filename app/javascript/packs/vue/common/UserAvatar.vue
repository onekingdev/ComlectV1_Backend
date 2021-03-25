<template lang="pug">
  span
    img.img-avatar(v-if="src" :src="src")
    span.avatar-placeholder(v-else) {{placeholderText}}
</template>

<script>
const initialSymbol = str => (typeof str === "string" && str[0]) || ''

export default {
  props: {
    user: Object
  },
  computed: {
    src() {
      return this.user && this.user.photo
    },
    placeholderText() {
      return initialSymbol(this.user.first_name) + ' ' + initialSymbol(this.user.last_name)
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
  background: grey;
  line-height: 3em;
  color: white;
  text-align: center;
}
</style>