<template lang="pug">
  div.p-x-40.p-y-20
    .row
      .col-lg-7.col-12.mb-3
        CompilanceSpend
      .col-lg-5.col-12.mb-3
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

    },
  };
</script>

<style module>

</style>

