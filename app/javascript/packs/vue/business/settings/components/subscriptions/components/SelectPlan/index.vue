<template lang="pug">
  .registration-onboarding.position-relative(:class="{ full: isSidebarOpen }")
    Overlay(v-if="overlay.active")
    .container-fluid(v-if="!isSidebarOpen")
      .row
        .col-md-9.mx-auto.my-2
          .card
            .card-body
              .row
                .col.mb-2.text-center
                  h2.m-b-20 Choose your plan
                  b-form-group.mb-5(v-slot="{ ariaDescribedby }")
                    b-form-radio-group(id="btn-radios-plan"
                    v-model="billingTypeSelected"
                    :options="billingTypeOptions"
                    :aria-describedby="ariaDescribedby"
                    button-variant="outline-primary"
                    size="md"
                    name="radio-btn-outline"
                    buttons)
              .billing-plans
                b-card.billing-plan(v-for='(plan, index) in billingPlans' :class="[index === 0 ? 'billing-plan_low' : '', index === 1 ? 'billing-plan_medium' : '', index === 2 ? 'billing-plan_high' : '' ]" :key=`index`)
                  b-button.m-b-20(type='button' :variant="currentPlan.status && currentPlan.id === index+1 ? 'dark' : 'outline-primary'" @click="openDetails(plan)")
                    | {{ currentPlan.status && currentPlan.id === index+1 ? 'Current' : 'Select' }} Plan
                  b-card-text(:class="billingTypeSelected === 'annually' ?  'billing-plan__common-info' : ''")
                    h4.billing-plan__name {{ plan.name }}
                    p.billing-plan__descr {{ plan.description }}
                    h5.billing-plan__coast {{ billingTypeSelected === 'annually' ?  plan.coastMonthlyDiscountFormatted : plan.coastMonthlyFormatted }}
                      span.billing-plan__discount(v-if="plan.id !== 1 && billingTypeSelected === 'annually'")  &nbsp;{{ plan.coastMonthlyFormatted }}
                    p.billing-plan__users(v-if="plan.id === 1") {{ plan.users }}
                    p.billing-plan__users(v-if="plan.id !== 1 && billingTypeSelected === 'annually'")
                      //span.billing-plan__discount {{ plan.coastMonthlyFormatted }}
                      span.text-success.font-weight-bold &nbsp;{{ plan.coastAnnuallyFormatted }}
                    p.billing-plan__users(v-if="plan.id !== 1") {{ billingTypeSelected === 'annually' ?  plan.usersCount + ' free users plus $' + plan.additionalUserAnnually + '/year per person' : plan.usersCount + ' free users plus $' + plan.additionalUserMonthly + '/mo per person' }}
                  hr
                  ul.list-unstyled.billing-plan__list
                    li.billing-plan__item(v-for="feature in plan.features")
                      b-icon.billing-plan__icon(icon="check-circle-fill" variant="success")
                      span(v-html="feature")
    .select-plan(v-if="isSidebarOpen")
      .card.registration-card
        .borderless.m-b-40.px-0.pt-0
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
  import { mapActions, mapGetters } from "vuex"
  import BillingDetails from './BillingDetails'
  import PurchaseSummary from './PurchaseSummary'
  import Overlay from './Overlay'

  import data from './BillingPlansData.json'

  export default {
    components: {
      BillingDetails,
      PurchaseSummary,
      Overlay,
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

        currentPlan: { id: null, status: false }
      }
    },
    methods: {
      ...mapActions({
        updateSubscribe: 'settings/updateSubscribe',
        updateSeatsSubscribe: 'settings/updateSeatsSubscribe',
        getStaticCollection: 'settings/getStaticCollection',
      }),
      openDetails(plan) {
        if(plan.id === 1) {

          // OVERLAY
          this.$store.dispatch('setOverlay', {
            active: true,
            message: 'Setting up account',
            status: ''
          })

          const dataToSend = {
            userType: this.userType,
            planName: 'free',
            paymentSourceId : null,
          }

          this.$store.dispatch('settings/updateSubscribe', dataToSend)
            .then(response => {
              this.currentPlan = { id: 1, status: true }

              // OVERLAY
              this.$store.dispatch('setOverlay', {
                active: true,
                message: 'Setting up account...',
                status: 'success'
              })

              setTimeout(() => this.$store.dispatch('setOverlay', {
                active: false,
                message: '',
                status: ''
              }), 1000)
            })
            .catch(error => {
              console.error(error)

              // OVERLAY
              this.$store.dispatch('setOverlay', {
                active: true,
                message: `Something wrong! ${error}`,
                status: 'error'
              })
              setTimeout(() => {
                this.$store.dispatch('setOverlay', {
                  active: false,
                  message: '',
                  status: ''
                })
                this.closeSidebar()
              }, 2000)
            })

          return
        }

        this.isSidebarOpen = true
        this.selectedPlan = plan;
      },
      closeSidebar() {
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

        this.$store.dispatch('settings/updateSubscribe', data)
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

              this.$store.dispatch('setOverlay', {
                active: true,
                message: 'Setting up account',
                status: 'success'
              })

              setTimeout(() => {
                this.$store.dispatch('setOverlay', {
                  active: false,
                  message: '',
                  status: ''
                })
                this.closeSidebar()
              }, 1000)


            }
          })
          .catch(error => {
            console.error(error)

            // this.toast('Error', 'Payment failed to process.', true)
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
    },
    computed: {
      ...mapGetters({
        overlay: 'overlay',
      }),
    },
    async mounted () {
      try {
        await this.getStaticCollection()
      } catch (error) {
        console.error(error)
      }
    },
  }
</script>

<style scoped>

</style>
