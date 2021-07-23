<template lang="pug">
  div
    //.row
    //  .col
    //  b-form-group#inputBilling-group-1(label='Name on Card' label-for='inputBilling-1')
    //  b-form-input#inputBilling-1(v-model='cardDetail.nameOnCard' type='text' placeholder='Name on Card' required)
    //  .invalid-feedback.d-block(v-if="errors.nameOnCard") {{ errors.nameOnCard }}
    //.row
    //  .col-8.pr-2
    //  b-form-group#inputBilling-group-2(label='Card Number' label-for='inputBilling-2')
    //  b-form-input#inputBilling-2(v-model='cardDetail.cardNumber' type='text' placeholder='Card Number' required)
    //  .invalid-feedback.d-block(v-if="errors.cardNumber") {{ errors.cardNumber }}
    //.col-1.px-2
    //  b-form-group#inputBilling-group-3(label='Exp date' label-for='inputBilling-3')
    //  b-form-input#inputBilling-3(v-model='cardDetail.expDate' type='text' placeholder='MM' required)
    //  .invalid-feedback.d-block(v-if="errors.expDate") {{ errorMonths.expDateMonth }}
    //.col-1.px-2
    //  b-form-group#inputBilling-group-4(label='.' label-for='inputBilling-4')
    //  b-form-input#inputBilling-4(v-model='cardDetail.expDateYear' type='text' placeholder='YY' required)
    //  .invalid-feedback.d-block(v-if="errors.expDateYear") {{ errors.expDateYear }}
    //.col-2.pl-2
    //  b-form-group#inputBilling-group-5(label='CVC/CVV' label-for='inputBilling-5')
    //  b-form-input#inputBilling-5(v-model='cardDetail.CVV' type='text' placeholder='3 or 4 digits' required)
    //  .invalid-feedback.d-block(v-if="errors.CVV") {{ errors.CVV }}
    //.row
    //  .col.pr-2
    //    b-form-group#inputBilling-group-6(label='Country' label-for='inputBilling-6')
    //    b-form-input#inputBilling-6(v-model='cardDetail.country' type='text' placeholder='Country' required)
    //    .invalid-feedback.d-block(v-if="errors.country") {{ errors.country }}
    //.col.pl-2
    //  b-form-group#inputBilling-group-7(label='Zip' label-for='inputBilling-7')
    //  b-form-input#inputBilling-7(v-model='cardDetail.zip' type='text' placeholder='Enter zip code' required)
    //  .invalid-feedback.d-block(v-if="errors.zip") {{ errors.zip }}
    //.row
    //  .col.text-right
    //    b-button(type='button' variant='secondary' @click="addCardDetail") Add
    //    hr
    //    div
    //    p stripe-checkout:
    //    stripe-checkout(ref='checkoutRef' mode='payment' :pk='publishableKey' :line-items='lineItems' :success-url='successURL' :cancel-url='cancelURL' @loading='v => loading = v')
    //    button(@click='submit') Pay now!
</template>

<script>
  export default {
      name: "CreditCard"
  }
</script>

<style scoped>

</style>
