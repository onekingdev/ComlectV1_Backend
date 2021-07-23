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
        console.log('complitedPaymentMethod', response)
        this.paymentSourceId = response.id
        this.disabled = false;
      },
      selectPlanAndComplitePurchase (selectedPlan) {
        // CLEAR ERRORS
        this.errors = []

        this.overlay = true
        this.overlayStatusText = 'Setting up account. Subscribing a plan...'

        let planName;
        if (selectedPlan.id === 1) {
          planName = 'free';
        }
        if (selectedPlan.id === 2) {
          planName = 'specialist_pro';
        }

        const dataToSend = {
          userType: this.userType,
          planName,
          paymentSourceId : this.paymentSourceId,
        }

        this.$store
          .dispatch('updateSubscribe', dataToSend)
          .then(response => {
            if(response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                // this.toast('Error', `${key}: ${value}`)
                // this.errors = Object.assign(this.errors, { [key]: value })
                throw new Error(`${[key]} ${value}`)
              }
            }

            if(!response.errors) {
              // this.toast('Success', `Update subscribe successfully finished!`)

              // OVERLAY
              if(+this.additionalUsers === 0) {
                this.overlayStatus = 'success'
                this.overlayStatusText = 'Payment complete! Setting up account...'
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
            this.overlayStatusText = `Something wrong! ${error}`
            setTimeout(() => {
              this.overlay = false
            }, 3000)
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
