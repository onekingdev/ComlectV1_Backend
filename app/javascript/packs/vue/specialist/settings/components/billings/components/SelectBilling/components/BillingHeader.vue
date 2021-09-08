<template lang="pug">
  .div
    h2 Set Up Client Billing

    hr
    .steps
      .step(:class="currentTab === 'account' ? 'active' : ''")
        h4.step__name 1. Account information
      .step(:class="currentTab === 'personal' ? 'active' : ''")
        h4.step__name 2. Personal Information
      .step(:class="currentTab === 'payout' ? 'active' : ''")
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
