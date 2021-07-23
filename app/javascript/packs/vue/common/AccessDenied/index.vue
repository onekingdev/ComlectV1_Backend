<template lang="pug">
  div
    .access-denied.access-denied_h-100
      .access-denied-content
        .access-denied__logo
          img(src='@/assets/rocket.svg')
        h3.access-denied__title Upgrade to Access Feature
        p.access-denied__subtitle Choose a plan to get started!
        b-button.access-denied__btn(variant="dark") Check out plans
          b-icon.ml-2(icon="chevron-right")
</template>

<script>
  import AccessDeniedModal from "@/common/AccessDenied/modals/AccessDeniedModal";
  export default {
    components: {AccessDeniedModal}
  }
</script>

<style scoped>

</style>
