<template lang="pug">
  div
    .container-fluid
      .row
        .col-12
          .row.p-x-1
            .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
              div
                h2: b Financials
          .row(v-if="loading")
            .col
              .card-body.white-card-body
                Loading
          .row(v-if="!loading")
            .col-lg-7.col-12.m-b-2
              CompilanceSpend
            .col-lg-5.col-12.m-b-2
              AnnualBudget
          .row.mb-3
            .col
              Payments
          .row
            .col
              PaymentDetails
</template>

<script>
  import CompilanceSpend from "./components/CompilanceSpend";
  import AnnualBudget from "./components/AnnualBudget";
  import Payments from "./components/Payments";
  import PaymentDetails from "./components/PaymentDetails";

  export default {
    components: {
      PaymentDetails,
      Payments,
      CompilanceSpend,
      AnnualBudget,
    },
    data() {
      return {

      }
    },
    methods: {

    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
  };
</script>

<style module>

</style>

