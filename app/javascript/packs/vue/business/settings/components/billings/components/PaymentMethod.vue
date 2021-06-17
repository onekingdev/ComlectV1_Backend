<template lang="pug">
  div
    .card.mb-2(v-if="paymentMethods && !paymentMethods.length")
      .card-body
        h5.text-center Payment methods not exist
    .card.mb-2(v-for="payment in paymentMethods" :key="payment.id")
      .card-body
        .row
          .col
            .d-flex.align-items-center
              b-icon(v-if="payment.last4" icon='credit-card2-back-fill' variant="dark" font-scale="2")
              ion-icon.payment(v-if="!payment.brand" name="logo-paypal")
              .d-block.ml-4
                h3(v-if="payment.last4") Credit Card
                  span(v-if="payment.primary") (Primary)
                p.mb-0 {{ '**** **** **** ' + payment.last4 }} {{ payment.brand }} {{ payment.email }}
          .col
            .d-flex.justify-content-end.align-items-center.h-100
              b-button.btn.mr-2.font-weight-bold(v-if="!payment.primary" type='button' variant='default' @click="makePrimary(payment.id)") Make Primary
              b-button.btn.mr-2.font-weight-bold(type='button' variant='default' @click="deletePaymentMethod(payment.id)") Remove
</template>

<script>
  export default {
    name: "paymentMethod",
    props:['paymentMethods'],
    components: {},
    data() {
      return {
        userType: 'business',
        // paymentMethods: [
          // {
          //   id: 1,
          //   name: 'Credit Card(primary)',
          //   users: '10',
          //   billinPeriod: 'monthly',
          //   monthCoast: '100$/month',
          //   paymentCardType: 'Visa',
          //   paymentCard: '**** **** **** 4242',
          //   nextPaymentDate: 'October 25, 2021',
          //   primary: true
          // },
          // {
          //   id: 2,
          //   name: 'Paypal',
          //   email: 'email: some_email@example.com',
          //   users: '10',
          //   billinPeriod: 'monthly',
          //   monthCoast: '100$/month',
          //   // paymentCardType: 'Paypal',
          //   // paymentCard: '**** **** **** 4242',
          //   nextPaymentDate: 'October 25, 2021',
          //   primary: false
          // }
        // ]
      }
    },
    methods: {
      makePrimary(cardId) {
        console.log(cardId)
      },
      deletePaymentMethod(cardId) {
        const dataToSend = {
          userType: this.userType,
          id: cardId,
        }

        this.$store.dispatch('settings/deletePaymentMethod', dataToSend)
          .then(response => {
            if (response.status === "ok") this.toast('Success', `${response.message.message}`)
          })
          .catch(error => {
            console.error(error)
            this.toast('Error', `Something wrong! ${error}`)
          })
      },
    },
    mounted() {

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
