<template lang="pug">
  .div
    h2 Set Up Client Billing

    hr
    .steps
      .step(:class="{'active': currentTab === 'account'}")
        h4.step__name 1. Account information
      .step(:class="{'active': currentTab === 'personal'}")
        h4.step__name 2. Personal information
      .step(:class="{'active': currentTab === 'payout'}")
        h4.step__name 3. Payout type
</template>

<script>
  export default {
    name: "BillingHeader",
    props: {
      currentTab: String
    }
  }
</script>
