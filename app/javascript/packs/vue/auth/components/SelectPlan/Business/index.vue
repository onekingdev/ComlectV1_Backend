<template lang="pug">
  div
    .row
      .col.mb-2.text-center
        h2.m-b-20 Choose your plan
        b-form-group.m-b-40(v-slot="{ ariaDescribedby }")
          b-form-radio-group(id="btn-radios-plan"
          v-model="billingTypeSelected"
          :options="billingTypeOptions"
          :aria-describedby="ariaDescribedby"
          button-variant="outline-primary"
          name="radio-btn-outline"
          buttons)
    .billing-plans
      b-card.billing-plan(v-for='(plan, index) in billingPlans' :class="[index === 0 ? 'billing-plan_low' : '', index === 1 ? 'billing-plan_medium' : '', index === 2 ? 'billing-plan_high' : '' ]")
        b-button.m-b-20(type='button' :variant="currentPlan.status && currentPlan.id === index+1 ? 'dark' : 'outline-primary'" @click="$emit('openDetails', plan)")
          | {{ currentPlan.status && currentPlan.id === index+1 ? 'Current' : 'Select' }} Plan
        b-card-text
          h4.billing-plan__name {{ plan.name }}
          p.billing-plan__descr {{ plan.description }}
          h5.billing-plan__coast {{ billingTypeSelected === 'annually' ?  plan.coastMonthlyDiscountFormatted : plan.coastMonthlyFormatted }}
          p.billing-plan__users(v-if="plan.id === 1") {{ plan.users }}
          p.billing-plan__users(v-if="plan.id !== 1 && billingTypeSelected === 'annually'")
            span.billing-plan__discount {{ plan.coastMonthlyFormatted }}
            span.text-success &nbsp;{{ plan.coastAnnuallyFormatted }}
          p.billing-plan__users(v-if="plan.id !== 1") {{ billingTypeSelected === 'annually' ?  plan.usersCount + ' free users plus $' + plan.additionalUserAnnually + '/year per person' : plan.usersCount + ' free users plus $' + plan.additionalUserMonthly + '/mo per person' }}
          hr
          ul.list-unstyled.billing-plan__list
            li.billing-plan__item(v-for="feature in plan.features")
              b-icon.billing-plan__icon(icon="check-circle-fill" variant="success")
              span(v-html="feature")
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

<style scoped>

</style>
