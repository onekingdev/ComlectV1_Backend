<template lang="pug">
  .card.purchase-summary
    .card-header.purchase-summary-header
      | Purchase Summary
    .card-body.purchase-summary-body.p-y-20
      Coupon(@couponApplied="addDiscount")
    .card-body.purchase-summary-body.borderless.p-40.pb-0
      dl.row.mb-0
        dt.col-7 {{ planComputed.name }} plan
        dd.col-5.text-right.font-weight-bold {{ billingTypeSelected === 'annually' ?  planComputed.coastAnnuallyFormatted : planComputed.coastMonthlyFormatted }}
        //dt.col-6 {{ additionalUsers }} Users ({{ planComputed.usersCount }} Free)
        //dd.col-6.text-right {{ planComputed.additionalUserCoast }}
        //dt.col-6.text-success {{ billingTypeSelected === 'annually' ? 'Billed Annualy' : 'Billed Monthly' }}
        //dd.col-6.text-right.text-success(v-if="billingTypeSelected === 'annually'") You saved {{ planComputed.saved }}
      //.card-body.purchase-summary-body.p-x-40.p-y-20(v-if="planComputed.tax")
      //  dl.row.mb-0
      //    dt.col-6
      //      b Tax
      //    dd.col-6.text-right.m-b-0
      //      b {{ planComputed.tax }}
      hr
      dl.row.mb-0.purchase-summary__total
        dt.col-6
          b Total
        dd.col-6.text-right.m-b-0
          b {{ planComputed.total }}
    .card-footer.purchase-summary-footer.borderless.p-40
      b-button.purchase-summary__btn(type='button' variant='dark' @click="complitePurchase" :disabled="disabled")
        //b-icon.mr-2(icon="arrow-clockwise" animation="spin" font-scale="1" v-show="loading")
        .lds-ring.lds-ring-small(v-show="loading")
          div
          div
          div
          div
        span(v-show="!loading") Complete Purchase
</template>

<script>
  import Coupon from '@/auth/components/Coupon'
  export default {
    props: ['billingTypeSelected', 'billingTypeOptions', 'plan', 'additionalUsers', 'disabled'],
    components: { Coupon },
    data() {
      return {
        loading: false
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
      },
      addDiscount() {
        console.log('disocunt')
      }
    },
    computed: {
      // loading() {
      //   return this.$store.getters.loading;
      // },
      planComputed() {
        return {
          ...this.plan,
          // additionalUserCoast: this.calcAdditionalUserCoast(this.billingTypeSelected, this.additionalUsers, this.plan.usersCount, this.plan.additionalUserMonthly, this.plan.additionalUserAnnually),
          // saved: `$${Math.abs(this.plan.coastAnnually - this.plan.coastMonthly * 12)}`,
          // tax: '$0.00',
          total: this.countTotalCoast(this.billingTypeSelected, this.plan.coastMonthly, this.plan.coastAnnually, this.additionalUsers, this.plan.usersCount, this.plan.additionalUserMonthly, this.plan.additionalUserAnnually),
        }
      },
    },
  }
</script>
