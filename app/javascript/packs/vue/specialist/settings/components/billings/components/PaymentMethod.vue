<template lang="pug">
  div
    .card.mb-2(v-for="payment in paymentMethods" :key="payment.id")
      .card-title
      .card-body
        .row
          .col
            .d-flex.align-items-center
              b-icon(v-if="payment.paymentCardType === 'Visa'" icon='credit-card2-back-fill' variant="dark" font-scale="2")
              ion-icon.payment(v-if="!payment.paymentCardType" name="logo-paypal")
              .d-block.ml-4
                h3 {{ payment.name }}
                p.mb-0 {{ payment.paymentCard }} {{ payment.paymentCardType }} {{ payment.email }}
          .col
            .d-flex.justify-content-end.align-items-center
              b-button.btn.mr-2.font-weight-bold(v-if="!payment.primary" type='button' variant='default') Make Primary
              b-button.btn.mr-2.font-weight-bold(type='button' variant='default') Remove
</template>

<script>
    export default {
      name: "paymentMethod",
      components: {

      },
      data() {
        return {
          paymentMethods: [
            {
              id: 1,
              name: 'Credit Card(primary)',
              users: '10',
              billinPeriod: 'monthly',
              monthCoast: '100$/month',
              paymentCardType: 'Visa',
              paymentCard: '**** **** **** 4242',
              nextPaymentDate: 'October 25, 2021',
              primary: true
            },
            {
              id: 2,
              name: 'Paypal',
              email: 'email: some_email@example.com',
              users: '10',
              billinPeriod: 'monthly',
              monthCoast: '100$/month',
              // paymentCardType: 'Paypal',
              // paymentCard: '**** **** **** 4242',
              nextPaymentDate: 'October 25, 2021',
              primary: false
            }
          ]
        }
      }
    }
</script>

<style scoped>

</style>
<style>
  ion-icon.payment {
    font-size: 2rem;
  }
</style>
