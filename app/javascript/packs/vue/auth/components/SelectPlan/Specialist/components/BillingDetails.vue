<template lang="pug">
  div
    .registration-card-header.p-b-20.px-0
      .row
        .col
          h4.registration-card__main-title Plan
    .registration-card-header.p-y-20.px-0
      .row
        .col
          h4.registration-card-header__title {{ planComputed.name }}
          p.registration-card-header__subtitle {{ planComputed.description }}
        .col.text-right
          h4.registration-card-header__title {{ billingTypeSelected === 'annually' ?  planComputed.coastAnnuallyFormatted : planComputed.scratched }}
          //p {{ billingTypeSelected === 'annually' ?  planComputed.usersCount + ' free users plus $' + planComputed.additionalUserAnnually + '/year per person' : planComputed.usersCount + ' free users plus $' + planComputed.additionalUserMonthly + '/mo per person' }}
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
        userType: 'specialist',
        // loading: false,
        additionalUsersCount: 0,
      };
    },
    methods: {
      onBiliingChange(event){
        this.$emit('updateBiliing', event)
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
