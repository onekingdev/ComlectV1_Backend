<template lang="pug">
  .card.info-board.w-100
    .card-body.p-0
      .d-flex.justify-content-between.align-items-center
        .d-flex.align-items-center
          b-icon.info-board__icon(icon="shop")
          .d-flex.flex-column
            h3.info-board__title Get hired for your next big job
            p.info-board__subtitle.mb-0 Sign up for a Complect PRO Specialist account and unlock the compilance job board, program mirroring, and automated invoicing.
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
