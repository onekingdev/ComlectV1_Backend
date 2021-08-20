<template lang="pug">
  .select-plan(v-if="isSidebarOpen")
    .card.registration-card
      .borderless.m-b-40.px-0.pt-0
        .d-flex.justify-content-between.m-b-40
          b-button(variant="default" @click="$emit('sidebarToggle', false)")
            b-icon.mr-2(icon="chevron-left" variant="dark")
            | Back
        .registration-card__header
          h2.registration-card__main-title Time to power up
          p.registration-card__main-subtitle Review and confirm your subscription
      BillingDetails(
      :billingTypeSelected="billingTypeSelected"
      :billingTypeOptions="billingTypeOptions"
      :plan="selectedPlan"
      @updateBiliing="onBiliingChange"
      @updateAdditionalUsers="updateAdditionalUsers"
      @complitedPaymentMethod="complitedPaymentMethod"
      )

    PurchaseSummary(
    v-if="isSidebarOpen"
    :billingTypeSelected="billingTypeSelected"
    :billingTypeOptions="billingTypeOptions"
    :plan="selectedPlan"
    :additionalUsers="additionalUsers"
    @complitePurchaseConfirmed="selectPlanAndComplitePurchase",
    :disabled="disabled"
    )
</template>

<script>
  import BillingDetails from './BillingDetails'
  import PurchaseSummary from './PurchaseSummary'

  export default {
    props: ['isSidebarOpen', 'selectedPlan', 'userType'],
    components: {
      BillingDetails,
      PurchaseSummary,
    },
    data() {
      return {
        billingTypeSelected: 'annually',
        billingTypeOptions: [
          { text: 'Billed Annually', value: 'annually' },
          { text: 'Billed Monthly', value: 'monthly' },
        ],
        additionalUsers: 0,
        paymentSourceId: null,
        disabled: true,

      }
    },
    methods: {
      onBiliingChange(event) {
        this.billingTypeSelected = event
      },
      updateAdditionalUsers(event){
        this.additionalUsers = event
      },
      complitedPaymentMethod(response) {
        this.paymentSourceId = response.id
        this.disabled = false;
      },
      selectPlanAndComplitePurchase (selectedPlan) {
        // CLEAR ERRORS
        this.errors = []

        // OVERLAY
        this.$store.dispatch('setOverlay', {
          active: true,
          message: 'Setting up account',
          status: ''
        })

        let planName;
        if (selectedPlan.id === 1) {
          planName = 'free';
        }
        if (selectedPlan.id === 2) {
          planName = this.billingTypeSelected === 'annually' ? 'team_tier_annual' : 'team_tier_monthly';
        }
        if (selectedPlan.id === 3) {
          planName = this.billingTypeSelected === 'annually' ? 'business_tier_annual' : 'business_tier_monthly'
        }

        const data = {
          userType: this.userType,
          planName: planName,
          payment_source_id : this.paymentSourceId,
        }
        if (+this.additionalUsers) data.additionalUsers = +this.additionalUsers
        if (selectedPlan.coupon_id) data.coupon_id = selectedPlan.coupon_id

        this.$store.dispatch('updateSubscribe', data)
          .then(response => {
            if(response.errors) throw new Error(`Response error!`)
            if(!response.errors) {
              // this.toast('Success', `Update subscribe successfully finished!`)

              // OVERLAY
              // this.$store.dispatch('setOverlay', {
              //   active: true,
              //   message: 'Payment complete! Setting up account...',
              //   status: 'success'
              // })
              // setTimeout(() => this.redirect() , 3000)

              this.$store.dispatch('setOverlay', {
                active: true,
                message: 'Setting up account',
                status: 'success'
              })
              this.redirect()
            }
          })
          .catch(error => {
            console.error(error)

            this.toast('Error', 'Payment failed to process.', true)
            // OVERLAY
            this.$store.dispatch('setOverlay', {
              active: true,
              message: 'Payment failed to process.',
              status: 'error'
            })
            setTimeout(() => this.$store.dispatch('setOverlay', {
              active: false,
              message: '',
              status: ''
            }), 3000)
          })
          .finally(() => this.disabled = true)
      },
      redirect() {
        localStorage.setItem('app.currentUser.firstEnter', JSON.stringify(true))
        const dashboard = this.userType === 'business' ? '/business' : '/specialist'
        setTimeout(() => {
          window.location.href = `${dashboard}`;
        }, 3000)
      }
    }
  }

</script>
