<template lang="pug">
  .card.m-t-1.purchase-summary
    .card-header
      | Purchase Summary
    .card-body.pb-0
      dl.row.mb-0
        dt.col-sm-6
          b {{ planComputed.name }} plan
        dd.col-sm-6.text-right {{ billingTypeSelected === 'annually' ?  planComputed.coastAnnuallyFormatted : planComputed.coastMonthlyFormatted }}
        dt.col-sm-6 {{ planComputed.usersCount }} Users ({{ planComputed.usersCount }} Free)
        dd.col-sm-6.text-right {{ planComputed.additionalUserCoast }}
        dt.col-sm-6.text-success(v-if="billingTypeSelected === 'annually'") Billed Annualy
        dd.col-sm-6.text-right.text-success(v-if="billingTypeSelected === 'annually'") You saved {{ planComputed.saved }}
    hr(v-if="planComputed.tax")
    .card-body.py-0(v-if="planComputed.tax")
      dl.row.mb-0
        dt.col-sm-6
          b Tax
        dd.col-sm-6.text-right.m-b-0
          b {{ planComputed.tax }}
    hr
    .card-body.pt-0
      dl.row.mb-0
        dt.col-sm-6
          b Total
        dd.col-sm-6.text-right.m-b-0
          b {{ planComputed.total }}
    .card-footer
      b-button.w-100(type='button' variant='dark' @click="complitePurchase") Complite purchase
</template>

<script>
export default {
  props: ['billingTypeSelected', 'billingTypeOptions', 'plan', 'additionalUsers'],
  data() {
    return {

    }
  },
  methods: {
    countTotalCoast(planType, coastMonthly, coastAnnually, usersCount, usersCoastMonthly, usersCoastAnnually) {
      // console.log(planType, coastMonthly, coastAnnually, usersCount, usersCoast)
      let finalCoast;
      if (planType === 'monthly') {
        finalCoast = coastMonthly + usersCount * usersCoastMonthly
      }
      if (planType === 'annually') {
        finalCoast = coastAnnually + usersCount * usersCoastAnnually
      }
      return `$${finalCoast}`
    },
    complitePurchase() {
      const value = this.planComputed
      this.$emit('complitePurchaseConfirmed', value)
    }
  },
  computed: {
    planComputed() {
      return {
        ...this.plan,
        additionalUserCoast: `+$${this.additionalUsers * this.plan.additionalUserMonthly}`,
        saved: `$${Math.abs(this.plan.coastAnnually - this.plan.coastMonthly * 12)}`,
        // tax: '$0.00',
        total: this.countTotalCoast(this.billingTypeSelected, this.plan.coastMonthly, this.plan.coastAnnually, this.additionalUsers, this.plan.additionalUserMonthly, this.plan.additionalUserAnnually),
      }
    },
  },
  // watch: {
    // billingTypeSelected: function(newVal, oldVal) {
      // console.log('Prop changed: ', newVal, ' | was: ', oldVal)
    // }
  // }
}
</script>

<style scoped>
  .purchase-summary {
    position: absolute;
    z-index: 1050;
    right: 5rem;
    top: 30%;
    width: 30rem;
    transform: translateY(-30%);
  }
</style>
