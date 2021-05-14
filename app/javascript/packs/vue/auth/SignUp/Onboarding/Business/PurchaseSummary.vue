<template lang="pug">
  .card.m-t-1.purchase-summary
    .card-header
      | Purchase Summary
    .card-body.pb-0
      dl.row.mb-0
        dt.col-sm-6
          b {{ planComputed.name }} plan
        dd.col-sm-6.text-right {{ billingTypeSelected === 'annually' ?  planComputed.coastAnnuallyFormatted : planComputed.coastMonthlyFormatted }}
        dt.col-sm-6 {{ additionalUsers }} Users ({{ planComputed.usersCount }} Free)
        dd.col-sm-6.text-right {{ planComputed.additionalUserCoast !== '+$0' ? planComputed.additionalUserCoast : 'FREE' }}
        dt.col-sm-6.text-success(v-if="billingTypeSelected === 'annually' && planComputed.id !== 1") Billed Annualy
        dd.col-sm-6.text-right.text-success(v-if="billingTypeSelected === 'annually' && planComputed.id !== 1") You saved {{ planComputed.saved }}
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
      b-button.w-100(type='button' variant='dark' @click="complitePurchase" :disabled="disabled")
        b-icon.mr-2(icon="arrow-clockwise" animation="spin" font-scale="1" v-show="loading")
        | Complite purchase
</template>

<script>
export default {
  props: ['billingTypeSelected', 'billingTypeOptions', 'plan', 'additionalUsers', 'disabled'],
  data() {
    return {

    }
  },
  methods: {
    calcAdditionalUserCoast(planType, usersCount, usersFreeCount, usersCoastMonthly, usersCoastAnnually) {
      let finalCoast;
      if (usersCount <= usersFreeCount) return `+$0`
      if (planType === 'monthly') {
        finalCoast = (usersCount-usersFreeCount) * usersCoastMonthly
      }
      if (planType === 'annually') {
        finalCoast = (usersCount-usersFreeCount) * usersCoastAnnually
      }
      return finalCoast !== 'FREE0' ? `+$${finalCoast}` : 'FREE'
    },
    countTotalCoast(planType, coastMonthly, coastAnnually, usersCount, usersFreeCount, usersCoastMonthly, usersCoastAnnually) {
      // console.log(planType, coastMonthly, coastAnnually, usersCount, usersCoast)
      let finalCoast, finalUserCoast = 0;
      if (planType === 'monthly') {
        if (usersCount > usersFreeCount) finalUserCoast = (usersCount-usersFreeCount) * usersCoastMonthly
        finalCoast = coastMonthly + finalUserCoast
      }
      if (planType === 'annually') {
        if (usersCount > usersFreeCount)  finalUserCoast = (usersCount-usersFreeCount) * usersCoastAnnually
        finalCoast = coastAnnually + finalUserCoast
      }
      return finalCoast !== 'FREE0' ? `+$${finalCoast}` : 'FREE'
    },
    complitePurchase() {
      const value = this.planComputed
      this.$emit('complitePurchaseConfirmed', value)
    }
  },
  computed: {
    loading() {
      return this.$store.getters.loading;
    },
    planComputed() {
      return {
        ...this.plan,
        additionalUserCoast: this.calcAdditionalUserCoast(this.billingTypeSelected, this.additionalUsers, this.plan.usersCount, this.plan.additionalUserMonthly, this.plan.additionalUserAnnually),
        saved: `$${Math.abs(this.plan.coastAnnually - this.plan.coastMonthly * 12)}`,
        // tax: '$0.00',
        total: this.countTotalCoast(this.billingTypeSelected, this.plan.coastMonthly, this.plan.coastAnnually, this.additionalUsers, this.plan.usersCount, this.plan.additionalUserMonthly, this.plan.additionalUserAnnually),
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
