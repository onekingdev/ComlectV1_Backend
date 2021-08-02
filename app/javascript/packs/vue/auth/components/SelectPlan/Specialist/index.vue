<template lang="pug">
  div
    .row
      .col.mb-2.text-center
        h2.mb-3 Choose your Membership plan
        p.onboarding__sub-title.m-b-10 Want to skip selecting a plan?
        b-form-group.m-b-40
          b-button(type='button' variant='outline-primary' @click="$emit('openDetails', freePlan)") Continue With Free Plan
    .billing-plans
      b-card.billing-plan.billing-plan_specialist(v-for='(plan, index) in billingPlans' :class="[index === 0 ? 'billing-plan_default' : '', index === 1 ? 'billing-plan_high' : '' ]"  :key=`index`)
        b-button.m-b-20(type='button' :variant="currentPlan.status && currentPlan.id === index+1 ? 'dark' : 'secondary'" @click="$emit('openDetails', plan)")
          | {{ currentPlan.status && currentPlan.id === index+1 ? 'Current' : 'Select' }} Plan
        b-card-text
          h4.billing-plan__name {{ plan.name }}
          p.billing-plan__descr {{ plan.description }}
          h5.billing-plan__coast {{ billingTypeSelected === 'annually' ?  plan.coastAnnuallyFormatted : plan.coastMonthlyFormatted }}
          // p.billing-plan__users {{ billingTypeSelected === 'annually' ?  plan.usersCount + ' free users plus $' + plan.additionalUserAnnually + '/year per person' : plan.usersCount + ' free users plus $' + plan.additionalUserMonthly + '/mo per person' }}
          hr
          ul.list-unstyled.billing-plan__list
            li.billing-plan__item(v-for="feature in plan.features")
              b-icon.billing-plan__icon(icon="check-circle-fill" variant="success")
              | {{ feature }}
    .row
      .col
        .text-right.m-t-30
          b-button(type='button' variant='default' @click="$emit('goBack')") Go back
</template>

<script>
  import data from './BillingPlansData.json'

  export default {
    props: {
      userType: {
        type: String,
        required: true
      }
    },
    data() {
      return {
        billingTypeSelected: 'annually',
        billingTypeOptions: [
          { text: 'Billed Annually', value: 'annually' },
          { text: 'Billed Monthly', value: 'monthly' },
        ],
        billingPlans: data.billingPlans,
        currentPlan: { id: null, status: false },
        openId: null,
        isSidebarOpen: false,
        selectedPlan: null,
        overlay: false,
        overlayStatus: '',
        overlayStatusText: ''
      }
    },
    methods: {

    },
    computed: {
      freePlan() {
        return this.billingPlans.find(plan => plan.id === 1)
      }
    }
  }
</script>

<style scoped>

</style>
