<template lang="pug">
  div.p-x-40.p-y-20
    .row
      .col-12.m-b-20
        Payments
    .row
      .col-xl-7.col-12.m-b-20
        ComplianceSpend
      .col-xl-5.col-12.m-b-20
        AnnualBudget
    //.row
    //  .col
    //    PaymentDetails

</template>

<script>
  import ComplianceSpend from "./components/ComplianceSpend";
  import AnnualBudget from "./components/AnnualBudget";
  import Payments from "./components/Payments";
  // import PaymentDetails from "./components/PaymentDetails";

  export default {
    components: {
      // PaymentDetails,
      Payments,
      ComplianceSpend,
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

