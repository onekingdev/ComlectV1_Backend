<template lang="pug">
  .card
    .card-body
      .d-flex.justify-content-between
        .d-flex.align-items-center
          ion-icon.plan__icon(name="home-outline")
          .d-flex.flex-column.ml-3
            h3 Get hired for your next big job
            p.mb-0 Sign up for a Complect PRO Specialist account and unlock the compilance job board, program mirroring, and automated invoicing.
        .d-flex.ml-auto.align-items-center
          button.btn.btn-default.mr-2 More information
          button.btn.btn-dark Upgrade now
            b-icon.ml-2(icon="chevron-right")
</template>

<script>
  export default {
    name: "Plan",
    components: {},
    data() {
      return {

      }
    }
  }
</script>

<style scoped>

</style>

<style >
  ion-icon.plan__icon {
    font-size: 44px;
  }
</style>
