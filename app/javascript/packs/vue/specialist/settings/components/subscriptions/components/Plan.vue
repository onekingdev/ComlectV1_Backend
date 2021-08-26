<template lang="pug">
  .card
    .card-body
      .row
        .col
          h5.mb-0 {{ plan.name }}
          p {{ plan.users }} active users
        .col
          .d-flex.justify-content-end
            PlanCancelModal(:date="plan.nextPaymentDate")
              b-button.btn.btn-link(type='button') Cancel plan
            // PlanModalEdit(:plan="plan")
            //   b-button.btn.mr-2(type='button' variant='default') Edit plan
            // b-button.btn(type='button' variant='dark') Upgrade
      hr
      .row
        .col {{ plan.monthCoast }}, billed {{ plan.billinPeriod }} to {{ plan.paymentCardType }} {{ plan.paymentCard }}
        .col.text-right Next payment date {{ plan.nextPaymentDate }}
</template>

<script>
    // import PlanModalEdit from "../modals/PlanModalEdit";
    import PlanCancelModal from "../modals/PlanCancelModal";
    export default {
      name: "Plan",
      components: {PlanCancelModal},
      // components: {PlanModalEdit},
      data() {
        return {
          plan: {
            id: 1,
            name: 'Specialist PRO',
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
