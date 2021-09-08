<template lang="pug">
  div
    .card-body
      BillingHeader(:currentTab="currentTab")
      AccountInformation(
        @changeTab="changeCurrentTab"
        :stripeAccount="stripeAccount"
        v-if="currentTab === 'account'"
      )

      PersonalInformation(
        @changeTab="changeCurrentTab"
        :stripeAccount="stripeAccount"
        v-if="!loading && stripeAccount && currentTab === 'personal'"
      )
</template>

<script>
  import { mapGetters } from "vuex";
  import BillingHeader from "./components/BillingHeader";
  import AccountInformation from "./components/AccountInformation";
  import PersonalInformation from "./components/PersonalInformation";

  export default {
    name: "index",
    components: {
      BillingHeader,
      AccountInformation,
      PersonalInformation
    },
    data() {
      return {
        currentTab: "account"
      }
    },
    methods: {
      changeCurrentTab(name) {
        this.currentTab = name;
      }
    },
    computed: {
      ...mapGetters({
        loading: "loading",
        stripeAccount: "stripe_accounts/stripeAccount"
      })
    }
  }
</script>
