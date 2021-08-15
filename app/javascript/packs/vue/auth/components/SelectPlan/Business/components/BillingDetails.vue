<template lang="pug">
  div
    .registration-card-header.p-b-20.px-0
      .row
        .col
          h4.registration-card__main-title Plan
          //p.registration-card__main-subtitle Review and confirm your subscription
        .col.text-right
          b-form-group(v-if="planComputed.id !== 1", v-slot="{ ariaDescribedby }")
            b-form-radio-group(id="btn-radios-plan"
            :checked="billingTypeSelected"
            :options="billingTypeOptions"
            :aria-describedby="ariaDescribedby"
            button-variant="outline-primary"
            size="md"
            name="radio-btn-outline"
            buttons
            @change="onBiliingChange"
            )
    .registration-card-header.p-y-20.px-0
      .row
        .col
          h4.registration-card-header__title {{ planComputed.name }}
          p.registration-card-header__subtitle {{ planComputed.description }}
        .col.text-right
          h4.registration-card-header__title {{ billingTypeSelected === 'annually' ?  planComputed.coastAnnuallyFormatted : planComputed.coastMonthlyFormatted }}
          p.registration-card-header__subtitle(v-if="planComputed.id !== 1") {{ billingTypeSelected === 'annually' ?  planComputed.usersCount + ' free users plus $' + planComputed.additionalUserAnnually + '/year per person' : planComputed.usersCount + ' free users plus $' + planComputed.additionalUserMonthly + '/mo per person' }}
    .registration-card-header.p-y-20.px-0(v-if="planComputed.id !== 1")
      .d-flex.justify-content-between
        div
          h4.registration-card-header__title Users
          p.registration-card-header__subtitle Enter the number of users (this is often your employee headcount)
        .d-block
          b-form-input.form-control-number(v-model="additionalUsersCount" type="number" min="1" max="100" @keyup="onChangeUserCount")
    AddPaymentMethod(:billingTypeSelected="billingTypeSelected", :billingTypeOptions="billingTypeOptions", :plan="plan", :userType="userType" @complitedPaymentMethod="complitedPaymentMethod")
</template>

<script>
  import AddPaymentMethod from "../../../AddPaymentMethod";

  export default {
    props: ['billingTypeSelected', 'billingTypeOptions', 'plan'],
    components: {
      AddPaymentMethod,
    },
    data() {
      return {
        userType: 'business',
        // loading: false,
        additionalUsersCount: 0,
      };
    },
    methods: {
      onBiliingChange(event){
        this.$emit('updateBiliing', event)
      },
      onChangeUserCount() {
        const value = this.additionalUsersCount
        this.$emit('updateAdditionalUsers', value)
      },
      complitedPaymentMethod(response) {
        this.$emit('complitedPaymentMethod', response)
      }
    },
    computed: {
      planComputed() {
        return this.plan
      },
    },
  }
</script>
