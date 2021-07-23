<template lang="pug">
  .select-plan(v-if="isSidebarOpen")
    .card.registration-card
      .card-header.borderless.m-b-80.px-0.pt-0
        .d-flex.justify-content-between.m-b-40
          b-button(variant="default" @click="isSidebarOpen = false")
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
    props: ['isSidebarOpen', 'selectedPlan'],
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
        overlay: false,
        overlayStatus: '',
        overlayStatusText: '',
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

        this.overlay = true
        this.overlayStatusText = 'Processing payment...'

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
          planName,
          paymentSourceId : this.paymentSourceId,
        }
        if (+this.additionalUsers) data.countPayedUsers = +this.additionalUsers

        this.$store
          .dispatch('updateSubscribe', data)
          .then(response => {
            if(response.errors) throw new Error(`Response error!`)
            if(!response.errors) {
              // this.toast('Success', `Update subscribe successfully finished!`)

              // OVERLAY
              if(+this.additionalUsers === 0) {
                this.overlayStatusText = 'Payment complete! Setting up account...'
                this.overlayStatus = 'success'
                // this.overlay = false
                this.redirect()
              }
            }
          })
          .catch(error => {
            console.error(error)
            // this.toast('Error', `Something wrong! ${error}`)

            // OVERLAY
            this.overlayStatus = 'error'
            this.overlayStatusText = `Payment failed to process.`
            this.toast('Error', 'Payment failed to process.')
            setTimeout(() => {
              this.overlay = false
            }, 3000)
          })
          .finally(() => this.disabled = true)
      },
      paySeats(selectedPlan) {
        // const freeUsers = selectedPlan.usersCount;
        const neededUsers = +this.additionalUsers;
        // if (neededUsers <= freeUsers) {
        //   this.overlayStatusText = 'Account successfully purchased, you will be redirect to the dashboard...'
        //   this.overlayStatus = 'success'
        //   // this.overlay = false
        //   this.redirect()
        //   return
        // }
        // const countPayedUsers = neededUsers - freeUsers // OLD VERSION
        const countPayedUsers = neededUsers

        this.overlayStatusText = 'Subscribing additional seats...'

        let planName = this.billingTypeSelected === 'annually' ? 'seats_annual' : 'seats_monthly'

        const dataToSend = {
          userType: this.userType,
          planName,
          paymentSourceId : this.paymentSourceId,
          countPayedUsers,
        }

        this.$store
          .dispatch('updateSeatsSubscribe', dataToSend)
          .then(response => {

            if(response.errors) {
              for (const type of Object.keys(response[i].data.errors)) {
                // this.toast('Error', `Something wrong! ${response[i].data.errors[type]}`)
              }
            }

            if(!response.errors) {
              // this.toast('Success', `Update seat subscribe successfully finished!`)

              // OVERLAY
              this.overlayStatusText = `Account and ${countPayedUsers} seats successfully purchased, you will be redirect to the dashboard...`
              this.overlayStatus = 'success'
              // this.overlay = false
              this.redirect()
            }
          })
          .catch(error => {
            console.error(error)
            // this.toast('Error', `Something wrong! ${error}`)

            // OVERLAY
            this.overlayStatus = 'error'
            this.overlayStatusText = `Something wrong! ${error}`
            setTimeout(() => {
              this.overlay = false
            }, 3000)
          })
          .finally(() => this.disabled = true)
      },
    }
  }

</script>
