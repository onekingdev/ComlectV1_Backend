<template lang="pug">
  div
    .card-header.registration-card-header.p-b-20.px-0
      .row
        .col
          h4.registration-card__main-title Plan
          p.registration-card__main-subtitle Review and confirm your subscription
        .col.text-right
          b-form-group(v-if="planComputed.id !== 1", v-slot="{ ariaDescribedby }")
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
    .card-header.registration-card-header.p-y-20.px-0
      .row
        .col
          h4.registration-card-header__title {{ planComputed.name }}
          p.registration-card-header__subtitle {{ planComputed.description }}
        .col.text-right
          h4.registration-card-header__title {{ billingTypeSelected === 'annually' ?  planComputed.coastAnnuallyFormatted : planComputed.coastMonthlyFormatted }}
          p.registration-card-header__subtitle(v-if="planComputed.id !== 1") {{ billingTypeSelected === 'annually' ?  planComputed.usersCount + ' free users plus $' + planComputed.additionalUserAnnually + '/year per person' : planComputed.usersCount + ' free users plus $' + planComputed.additionalUserMonthly + '/mo per person' }}
    .card-header.registration-card-header.p-y-20.px-0(v-if="planComputed.id !== 1")
      .d-flex.justify-content-between
        div
          h4.registration-card-header__title Users
          p.registration-card-header__subtitle Enter the number of users for your plan (this is often your employee headcount
        .d-flex.justify-content-end.align-items-center
          b-form-input(v-model="additionalUsersCount" type="number" min="1" max="100" @keyup="onChangeUserCount")
    .card-header.registration-card-header.p-y-20.px-0
      .d-flex.justify-content-between
        h4.registration-card-header__title Payment Method
        div(v-show="!cardOptions.length")
          plaid-link(env='sandbox' :publicKey='plaidPK' clientName='Test App' product='transactions' v-bind='{ onSuccess }')
            template(slot='button' slot-scope='props')
              a.btn.btn-default(@click="props.onClick") Add Bank Account
    .card-body(v-if="cardOptions")
      dl.row(v-for="(card, i) in cardOptions")
        dt.col-7
          input.mr-2.mt-1(:id="'card'+card.id" type='radio' name='card' :value='card.id' v-model="cardSelected" @click="onPaymentMethodChange(card.id)")
          label(:for="'card'+card.id") {{ card.text }}
        dd.col-sm-5.text-right.m-b-0
          | {{ card.number }} {{ card.type }}
          a.link.ml-2(href="#" @click.stop="deletePaymentMethod(card.id)") Remove
    .card-header.registration-card-header.bordeless.p-t-20.px-0(v-show="!cardOptions.length")
      stripe-element-card(ref="elementRef" :pk="pk" @token="tokenCreated")
      .row
        .col.text-right
          b-button(type='button' variant='outline-primary' @click="submit")
            // b-icon.mr-2(icon="arrow-clockwise" animation="spin" font-scale="1" v-show="loading")
            .lds-ring.lds-ring-small(v-show="loading")
              div
              div
              div
              div
            span(v-show="!loading") Add
</template>

<script>
  import { StripeCheckout, StripeElementCard  } from '@vue-stripe/vue-stripe';
  import PlaidLink from "vue-plaid-link";

  /* Will be deleted soon after we test it on staging */
  console.warn("process.env.STRIPE_PUBLISHABLE_KEY > ", process.env.STRIPE_PUBLISHABLE_KEY)

  export default {
    props: ['billingTypeSelected', 'billingTypeOptions', 'plan'],
    components: {
      StripeCheckout,
      StripeElementCard,
      PlaidLink
    },
    data() {
      return {
        userType: 'business',
        // loading: false,
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
        cardSelected: null,
        cardOptions: [],
        // cardOptions: [
        //   { text: 'Credit Card (primary)', value: '1', number: '**** **** **** 8900', type: 'Visa', id: '1' },
        //   { text: 'Credit Card (secondary)', value: '2', number: '**** **** **** 8888', type: 'MasterCard', id: '2' },
        //   { text: 'Credit Card (third)', value: '3', number: '**** **** **** 1111', type: 'Visa', id: '3' },
        // ],
        errors: [],
        additionalUsersCount: 0,
        // isActive: true,
      };
    },
    methods: {
      // submit () {
      //   // You will be redirected to Stripe's secure checkout page
      //   this.$refs.checkoutRef.redirectToCheckout();
      // },
      submit () {
        // this will trigger the process
        this.$refs.elementRef.submit()
      },
      tokenCreated (token) {
        // handle the token
        // send it to your server
        const dataToSend = {
          userType: this.userType,
          stripeToken: token.id,
        }

        this.$store
          .dispatch('generatePaymentMethod', dataToSend)
          .then(response => {
            this.$emit('complitedPaymentMethod', response)
            this.toast('Success', `Payment method successfully added!`)
            this.isActive = false
            this.$refs.elementRef.clear()
            this.cardOptions.push({ text: `Credit Card${this.cardOptions.length===0 ? ' (primary)' : ''}`, value: response.id, number: `**** **** **** ${response.last4}`, type: response.brand, id: response.id })
            this.cardSelected = response.id
          })
          .catch(error => {
            console.error(error)
            // this.toast('Error', `Something wrong! ${error}`)
            this.toast('Error', 'Payment method could not be added.')
          })
      },
      deletePaymentMethod(cardId) {
        const data = {
          userType: this.userType,
          id: cardId,
        }

        this.$store
          .dispatch('deletePaymentMethod', data)
          .then(response => {
            const index = this.cardOptions.findIndex(record => record.id === cardId);
            this.cardOptions.splice(index, 1)
            this.toast('Success', `${response.message.message}`)
          })
          .catch(error => console.error(error))
      },
      addBankAccount() {

      },
      onBiliingChange(event){
        this.$emit('updateBiliing', event)
      },
      onChangeUserCount() {
        const value = this.additionalUsersCount
        this.$emit('updateAdditionalUsers', value)
      },
      onPaymentMethodChange(cardId){
        this.$emit('complitedPaymentMethod', {
          id: cardId
        })
      },
      onSuccess(token) {
        console.log(token);
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      planComputed() {
        return this.plan
      },
      pk() {
        return process.env.STRIPE_PUBLISHABLE_KEY
      },
      plaidPK() {
        return process.env.PLAID_PUBLIC_KEY
      }
    },
    mounted() {
      const dataToSend = {
        userType: this.userType,
      }

      this.$store
        .dispatch('getPaymentMethod', dataToSend)
        .then(response => {
          const newOptions = response.map((card, index) => {
            return { text: `Credit Card${index===0 ? ' (primary)' : ''}`, value: card.id, number: `**** **** **** ${card.last4}`, type: card.brand, id: card.id }
          })
          this.cardOptions = newOptions
        })
        .catch(error => {
          console.error(error)
        })
    }
  }
</script>
