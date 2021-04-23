<template lang="pug">
  div
    .card-header
      .row
        .col
          h4.m-t-1 Plan
        .col.text-right
          b-form-group(v-slot="{ ariaDescribedby }")
            b-form-radio-group(id="btn-radios-plan"
            :checked="billingTypeSelected"
            :options="billingTypeOptions"
            :aria-describedby="ariaDescribedby"
            button-variant="outline-primary"
            size="lg"
            name="radio-btn-outline"
            buttons
            @change="onBiliingChange"
            )
    .card-header
      .row
        .col
          h4.m-t-1 {{ planComputed.name }}
          p {{ planComputed.description }}
        .col.text-right
          h4.m-t-1 {{ billingTypeSelected === 'annually' ?  planComputed.coastAnnuallyFormatted : planComputed.coastMonthlyFormatted }}
          p {{ planComputed.users }}
    .card-header
      .d-flex.justify-content-between
        div
          h4.m-t-1 Users
          p Enter the amount of applicable employees to join your plan
        dl.row.m-t-2
          dt.col-sm-3
          dd.col-sm-9
            b-form-group
              b-form-input(v-model="additionalUsersCount" type="number" min="1" max="100" @keyup="onChangeUserCount")
    .card-header
      .d-flex.justify-content-between
        h4.m-t-1 Payment Method
        div.m-t-1
          a.btn.btn-light(@click="addBankAccount") Add Bank Account
    .card-body.d-none(v-if="cardOptions")
      dl.row(v-for="(card, i) in cardOptions")
        dt.col-sm-7
          input.mr-2.mt-1(id="card+i" type='radio' name='card.value' value='card.value' :checked="i===1")
          label(for='card+i') {{ card.text }}
        dd.col-sm-5.text-right.m-b-0
          | {{ card.number }} {{ card.type }}
          a.link.ml-2(:href="'/remove/card/' + card.id") Remove
    .card-header
      <!--div-->
        <!--StripeCheckout(:pk="pk")-->
      <!--hr-->
      <!--div-->
        <!--.row-->
          <!--.col-->
            <!--b-form-group#inputBilling-group-1(label='Name on Card' label-for='inputBilling-1')-->
              <!--b-form-input#inputBilling-1(v-model='cardDetail.nameOnCard' type='text' placeholder='Name on Card' required)-->
              <!--.invalid-feedback.d-block(v-if="errors.nameOnCard") {{ errors.nameOnCard }}-->
        <!--.row-->
          <!--.col-8.pr-2-->
            <!--b-form-group#inputBilling-group-2(label='Card Number' label-for='inputBilling-2')-->
              <!--b-form-input#inputBilling-2(v-model='cardDetail.cardNumber' type='text' placeholder='Card Number' required)-->
              <!--.invalid-feedback.d-block(v-if="errors.cardNumber") {{ errors.cardNumber }}-->
          <!--.col-1.px-2-->
            <!--b-form-group#inputBilling-group-3(label='Exp date' label-for='inputBilling-3')-->
              <!--b-form-input#inputBilling-3(v-model='cardDetail.expDate' type='text' placeholder='MM' required)-->
              <!--.invalid-feedback.d-block(v-if="errors.expDate") {{ errorMonths.expDateMonth }}-->
          <!--.col-1.px-2-->
            <!--b-form-group#inputBilling-group-4(label='.' label-for='inputBilling-4')-->
              <!--b-form-input#inputBilling-4(v-model='cardDetail.expDateYear' type='text' placeholder='YY' required)-->
              <!--.invalid-feedback.d-block(v-if="errors.expDateYear") {{ errors.expDateYear }}-->
          <!--.col-2.pl-2-->
            <!--b-form-group#inputBilling-group-5(label='CVC/CVV' label-for='inputBilling-5')-->
              <!--b-form-input#inputBilling-5(v-model='cardDetail.CVV' type='text' placeholder='3 or 4 digits' required)-->
              <!--.invalid-feedback.d-block(v-if="errors.CVV") {{ errors.CVV }}-->
        <!--.row-->
          <!--.col.pr-2-->
            <!--b-form-group#inputBilling-group-6(label='Country' label-for='inputBilling-6')-->
              <!--b-form-input#inputBilling-6(v-model='cardDetail.country' type='text' placeholder='Country' required)-->
              <!--.invalid-feedback.d-block(v-if="errors.country") {{ errors.country }}-->
          <!--.col.pl-2-->
            <!--b-form-group#inputBilling-group-7(label='Zip' label-for='inputBilling-7')-->
              <!--b-form-input#inputBilling-7(v-model='cardDetail.zip' type='text' placeholder='Enter zip code' required)-->
              <!--.invalid-feedback.d-block(v-if="errors.zip") {{ errors.zip }}-->
        <!--.row-->
          <!--.col.text-right-->
            <!--b-button(type='button' variant='secondary' @click="addCardDetail") Add-->
      <!--hr-->
      <!--div-->
        <!--p stripe-checkout:-->
        <!--stripe-checkout(ref='checkoutRef' mode='payment' :pk='publishableKey' :line-items='lineItems' :success-url='successURL' :cancel-url='cancelURL' @loading='v => loading = v')-->
        <!--button(@click='submit') Pay now!-->
      //hr
      div
        <!--p stripe-element-card:-->
        stripe-element-card(ref="elementRef"
        :pk="pk"
        @token="tokenCreated")
        <!--button(@click="submit") Generate token-->
      .row
        .col.text-right
          b-button(type='button' variant='secondary' @click="submit") Add

</template>

<script>
  import { StripeCheckout, StripeElementCard  } from '@vue-stripe/vue-stripe';

  export default {
    props: ['billingTypeSelected', 'billingTypeOptions', 'plan'],
    components: {
      StripeCheckout,
      StripeElementCard
    },
    data() {
      this.publishableKey = 'pk_test_01vxEQv9T5FIIKTu1GkHW41D';
      return {
        loading: false,
        lineItems: [
          {
            price: 'price_1IiDiaGXaxE41NmqapXysseR', // The id of the one-time price you created in your Stripe dashboard
            quantity: 1,
          },
        ],
        successURL: 'https://example.com/success',
        cancelURL: 'https://example.com/cancel',
        token: null,
        cardDetail: {
          nameOnCard: '',
          cardNumber: '',
          expDate: '',
          expDateYear: '',
          CVV: '',
          country: '',
          zip: '',
        },
        cards: [],
        cardSelected: '1',
        cardOptions: [
          { text: 'Credit Card (primary)', value: '1', number: '**** **** **** 8900', type: 'Visa', id: '1' },
          { text: 'Credit Card (secondary)', value: '2', number: '**** **** **** 8888', type: 'MasterCard', id: '2' },
          { text: 'Credit Card (third)', value: '3', number: '**** **** **** 1111', type: 'Visa', id: '3' },
        ],
        errors: [],
        additionalUsersCount: 0
      };
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      // submit () {
      //   // You will be redirected to Stripe's secure checkout page
      //   this.$refs.checkoutRef.redirectToCheckout();
      // },
      submit () {
        // this will trigger the process
        this.$refs.elementRef.submit()
      },
      tokenCreated (token) {
        console.log(token);
        // handle the token
        // send it to your server
        const dataToSend = {
          business: 'business',
          stripeToken: token.id,
        }

        this.$store
          .dispatch('generatePaymentMethod', dataToSend)
          .then(response => {
            console.log('response', response)
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Something wrong! ${error}`)
          })
      },
      addCardDetail() {
        console.log(this.cardDetail)
        this.cardOptions = Object.assign(this.cardOptions, {
          text: this.cardDetail.nameOnCard,
          value: this.cardOptions.length + 1,
          number: this.cardDetail.cardNumber,
          type: 'Visa',
          id: Math.floor(Math.random()) * 100
        })
      },
      addBankAccount() {

      },
      onBiliingChange(event){
        this.$emit('updateBiliing', event)
      },
      onChangeUserCount() {
        const value = this.additionalUsersCount
        this.$emit('updateAdditionalUsers', value)
      }
    },
    computed: {
      planComputed() {
        return this.plan
      },
      pk() {
        return process.env.STRIPE_PUBLISHABLE_KEY
      }
    }
  }
</script>
