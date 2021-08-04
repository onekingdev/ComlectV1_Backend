<template lang="pug">
  .card.info-board.w-100
    .card-body.p-0
      .d-flex.justify-content-between.align-items-center
        .d-flex.align-items-center
          b-icon.info-board__icon(icon="shop")
          .d-flex.flex-column
            h3.info-board__title Get hired for your next big job
            p.info-board__subtitle.mb-0 Sign up for our All Access Membership and unlock the compliance job board, enjoy automated billing, and access to client compliance program management tools.
        .d-flex.ml-auto.align-items-center
          //button.btn.btn-default.mr-2 More information
          button.btn.btn-dark Upgrade Now
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
