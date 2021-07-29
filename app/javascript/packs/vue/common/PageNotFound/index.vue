<template lang="pug">
  div
    .access-denied.access-denied_h-100
      .access-denied-content
        .access-denied__logo
          img(src='@/assets/rocket.svg')
        h3.access-denied__title Page Not Found
        p.access-denied__subtitle Please search again
        b-button.access-denied__btn(variant="dark" @click="backToMain") Back to main
          b-icon.ml-2(icon="chevron-right")
</template>

<script>
  export default {
    methods: {
      backToMain () {
        window.location = backToMainUrl
      }
    },
    computed () {
      backToMainUrl : '/'
    }
  }
</script>

<style scoped>

</style>
