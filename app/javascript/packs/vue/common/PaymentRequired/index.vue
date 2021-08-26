<template lang="pug">
  div
    .access-denied.access-denied_h-100
      .access-denied-content
        .access-denied__logo
          img(src='@/assets/cards.svg')
        h3.access-denied__title Payment Update Required
        p.access-denied__subtitle Your payment method is no longer working. Please update your payment information to proceed.
        b-button.access-denied__btn(variant="dark") Update Now
          b-icon.ml-2(icon="chevron-right")
</template>

<script>
  export default {
  }
</script>

<style scoped>

</style>
