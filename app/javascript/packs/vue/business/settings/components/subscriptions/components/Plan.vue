<template lang="pug">
  .card
    .card-title
    .card-body
      .row
        .col
          h3 {{ plan.name }}
          p {{ plan.users }} active users
        .col
          .d-flex.justify-content-end
            b-button.btn.link.mr-2(type='button' variant='none') Cancel
            PlanModalEdit(:plan="plan")
              b-button.btn.mr-2(type='button' variant='default') Edit plan
            b-button.btn(type='button' variant='dark' @click="$emit('openComponent', 'SelectPlan')") Upgrade
      hr
      .row
        .col {{ plan.monthCoast }}, billed {{ plan.billinPeriod }} to {{ plan.paymentCardType }} {{ plan.paymentCard }}
        .col.text-right Next payment date {{ plan.nextPaymentDate }}
</template>

<script>
    import PlanModalEdit from "../modals/PlanModalEdit";
    export default {
      name: "Plan",
      components: {PlanModalEdit},
      data() {
        return {
          plan: {
            id: 1,
            name: 'Team Plan',
            users: '10',
            billinPeriod: 'monthly',
            monthCoast: '100$/month',
            paymentCardType: 'Visa',
            paymentCard: '**** **** **** 4242',
            nextPaymentDate: 'October 25, 2021',
          }
        }
      }
    }
</script>

<style scoped>

</style>
