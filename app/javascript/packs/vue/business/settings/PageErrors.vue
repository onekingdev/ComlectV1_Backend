<template lang="pug">
  div.settings
    .container-fluid
      .row.p-t-3
        .col.h-100
          .d-flex.flex-column.align-items-center
            ion-icon.error(name="home-outline")
            h2 Payment update requered
            p Your payment method is no longer working. Please update your paymnet information to proceed.
            button.btn.btn-dark Update Now
</template>

<script>

  export default {
    components: {

    },
    created() {

    },
    data() {
      return {

      };
    },
    methods: {

    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
    mounted() {

    },
  };
</script>

<style scoped>
  .card-billing {
    transition: background-color 200ms ease-in;
  }
  .card-billing:hover,
  .card-billing:active {
    background-color: #f6f6f8;
    cursor: pointer;
  }
  ion-icon.error {
    margin-bottom: 3rem;
    font-size: 85px;
  }
</style>
