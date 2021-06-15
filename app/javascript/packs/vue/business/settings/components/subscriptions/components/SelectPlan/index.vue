<template lang="pug">
  div
    .row
      .col.mb-2.text-center
        h2.mb-3 Choose your plan
        b-form-group.mb-5(v-slot="{ ariaDescribedby }")
          b-form-radio-group(id="btn-radios-plan"
          v-model="billingTypeSelected"
          :options="billingTypeOptions"
          :aria-describedby="ariaDescribedby"
          button-variant="outline-primary"
          size="lg"
          name="radio-btn-outline"
          buttons)
    .row
      .col-xl-4(v-for='(plan, index) in billingPlans')
        b-card.w-100.mb-2.billing-plan(:class="[index === 0 ? 'billing-plan_low' : '', index === 1 ? 'billing-plan_medium' : '', index === 2 ? 'billing-plan_high' : '' ]")
          b-button.mb-3(type='button' :variant="currentPlan.status && currentPlan.id === index+1 ? 'dark' : 'outline-primary'" @click="openDetails(plan)")
            | {{ currentPlan.status && currentPlan.id === index+1 ? 'Current' : 'Select' }} Plan
          b-card-text
            h4.billing-plan__name {{ plan.name }}
            p.billing-plan__descr {{ plan.description }}
            h5.billing-plan__coast {{ billingTypeSelected === 'annually' ?  plan.coastAnnuallyFormatted : plan.coastMonthlyFormatted }}
            p.billing-plan__users(v-if="plan.id === 1") 0 free users
            p.billing-plan__users(v-if="plan.id !== 1 && billingTypeSelected === 'monthly'")
              span.billing-plan__discount {{ plan.coastMonthlyFormatted }}
              span.text-success &nbsp;{{ plan.coastAnnuallyFormatted }}
            p.billing-plan__users(v-if="plan.id !== 1") {{ billingTypeSelected === 'annually' ?  plan.usersCount + ' free users plus $' + plan.additionalUserAnnually + '/year per person' : plan.usersCount + ' free users plus $' + plan.additionalUserMonthly + '/mo per person' }}
            hr
            ul.list-unstyled.billing-plan__list
              li.billing-plan__item(v-for="feature in plan.features")
                b-icon.h4.mr-2.mb-0(icon="check-circle-fill" variant="success")
                | {{ feature }}
    b-sidebar#BillingPlanSidebar(@hidden="closeSidebar" v-model="isSidebarOpen" backdrop-variant='dark' backdrop left no-header width="60%")
      .card
        .card-header.borderless
          .d-flex.justify-content-between
            b-button(variant="default" @click="isSidebarOpen = false")
              b-icon.mr-2(icon="chevron-left" variant="dark")
              | Back
          .d-block.m-t-1
            h2 Time to power up
            p Review and confirm your subscription
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

  import data from './BillingPlansData.json'

  export default {
    components: {
      BillingDetails,
      PurchaseSummary,
    },
    data() {
      return {
        userType: 'business',
        formStep1: {
          crd_number: '',
          crd_numberSelected: 'no',
          crd_numberOptions: [
            {text: 'No', value: 'no'},
            {text: 'Yes', value: 'yes'},
          ],
        },
        // formStep2: initialAccountInfo(),
        industryOptions: [],
        subIndustryOptions: [],
        jurisdictionOptions: [],
        stateOptions: [],
        timeZoneOptions: [],

        show: true,
        errors: {},
        step1: true,
        step2: false,
        step3: false,
        currentStep: 1,
        navStep1: true,
        navStep2: false,
        navStep3: false,
        billingTypeSelected: 'annually',
        billingTypeOptions: [
          { text: 'Billed Annually', value: 'annually' },
          { text: 'Billed Monthly', value: 'monthly' },
        ],
        billingPlans: data.billingPlans,
        openId: null,
        isSidebarOpen: false,
        selectedPlan: [],
        additionalUsers: 0,
        paymentSourceId: null,
        disabled: true,
        overlay: false,
        overlayStatus: '',
        overlayStatusText: '',
        currentPlan: { id: null, status: false }
      }
    },
    methods: {
      openDetails(plan) {
        if(plan.id === 1) {
          const dataToSend = {
            userType: this.userType,
            planName: 'free',
            paymentSourceId : null,
          }

          this.$store.dispatch('updateSubscribe', dataToSend)
            .then(response => {
              this.toast('Success', `Update subscribe successfully finished!`)
              this.currentPlan = { id: 1, status: true }
              // this.redirect();
              this.$emit('upgradePlanComplited')
            })
            .catch(error =>this.toast('Error', `Something wrong!`))

          return
        }

        this.openId = plan.id
        // history.pushState({}, '', `${'new'}/${id}`)
        this.isSidebarOpen = true
        this.selectedPlan = plan;
      },
      closeSidebar() {
        this.openId = null
        // this.project = null
        // history.pushState({}, '', '')
        this.isSidebarOpen = false
      },
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
        this.overlayStatusText = 'Setting up account. Subscribing a plan...'

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

        const dataToSend = {
          userType: this.userType,
          planName,
          paymentSourceId : this.paymentSourceId,
        }

        this.$store
          .dispatch('updateSubscribe', dataToSend)
          .then(response => {
            if(response.errors) throw new Error(`Response error!`)
            if(!response.errors) {
              this.toast('Success', `Update subscribe successfully finished!`)
              this.paySeats(selectedPlan)

              // OVERLAY
              if(+this.additionalUsers === 0) {
                this.overlayStatusText = 'Account successfully purchased!'
                this.overlayStatus = 'success'
                // this.overlay = false
                // this.redirect()
                this.$emit('upgradePlanComplited')
              }
            }
          })
          .catch(error => {
            console.error(error)
            this.toast('Error', `Something wrong! ${error}`)

            // OVERLAY
            this.overlayStatus = 'error'
            this.overlayStatusText = `Something wrong! ${error}`
            setTimeout(() => {
              this.overlay = false
            }, 3000)
          })
          .finally(() => this.disabled = true)
      },
      paySeats(selectedPlan) {
        const freeUsers = selectedPlan.usersCount;
        const neededUsers = +this.additionalUsers;
        if (neededUsers <= freeUsers) return
        const countPayedUsers = neededUsers - freeUsers

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
                this.toast('Error', `Something wrong! ${response[i].data.errors[type]}`)
              }
            }

            if(!response.errors) {
              this.toast('Success', `Update seat subscribe successfully finished!`)

              // OVERLAY
              this.overlayStatusText = `Account and ${countPayedUsers} seats successfully purchased!`
              this.overlayStatus = 'success'
              // this.overlay = false
              // this.redirect()
              this.$emit('upgradePlanComplited')
            }
          })
          .catch(error => {
            console.error(error)
            this.toast('Error', `Something wrong! ${error}`)

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

<style scoped>

</style>
