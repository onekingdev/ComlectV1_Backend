<template lang="pug">
  div
    div
      p Choose how you want to get paid
      .card.mb-2
        .card-body
          .row
            .col
              .d-flex.align-items-center
                .d-block.ml-4
                  h3 You have no client billing methods yet.
                  p.mb-0 Add how you would like to receive your funds by clicking "Add Method"
            .col
              .d-flex.justify-content-end.align-items-center.h-100
                b-button.btn.font-weight-bold(type='button' variant='default') Add Methhod
    .card.mb-2(v-for="billing in clientBilling" :key="billing.id")
      .card-title
      .card-body
        .row
          .col
            .d-flex.align-items-center
              img(src='https://e7.pngegg.com/pngimages/368/337/png-clipart-chase-bank-jpmorgan-chase-car-finance-loan-chase-blue-angle.png' width='70px' alt="chase bank")
              //b-icon(v-if="billing.billingCardType === 'Visa'" icon='credit-card2-back-fill' variant="dark" font-scale="2")
              //ion-icon.billing(v-if="!billing.billingCardType" name="logo-paypal")
              .d-block.ml-4
                h3 {{ billing.name }}
                p.mb-0 {{ billing.billingCard }} {{ billing.billingCardType }} {{ billing.email }}
          .col
            .d-flex.justify-content-end.align-items-center
              b-button.btn.mr-2.font-weight-bold(type='button' variant='default') Edit
              b-button.btn.font-weight-bold(type='button' variant='default') Remove
</template>

<script>
  export default {
    name: "billingMethod",
    components: {

    },
    data() {
      return {
        clientBilling: [
          {
            id: 1,
            name: 'Bank account',
            users: '10',
            billinPeriod: 'monthly',
            monthCoast: '100$/month',
            billingCardType: 'Visa',
            billingCard: '**** **** **** 4242',
            nextbillingDate: 'October 25, 2021',
            primary: true
          },
        ]
      }
    }
  }
</script>

<style scoped>

</style>
<style>
  ion-icon.billing {
    font-size: 2rem;
  }
</style>
