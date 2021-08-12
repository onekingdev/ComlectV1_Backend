<template lang="pug">
  div
    .registration-card-header.borderless.p-y-20.px-0
      .d-flex.justify-content-between.align-items-center
        h4.registration-card-header__title.mb-0 Payment Method
        div(v-show="!cardOptions.length")
          plaid-link(env='sandbox' :publicKey='plaidPK' clientName='Test App' product='auth' v-bind='{ onSuccess }')
            template(slot='button' slot-scope='props')
              a.btn.btn-default(@click="props.onClick") Add Bank Account
    .registration-card-header.borderless.p-y-20.px-0(v-if="cardOptions.length")
      div(v-for="(card, i) in cardOptions")
        .d-flex.justify-content-between.align-items-center
          //input.mr-2.mt-1(:id="'card'+card.id" type='radio' name='card' :value='card.id' v-model="cardSelected" @click="onPaymentMethodChange(card.id)")
          //label(:for="'card'+card.id") {{ card.text }}
          //ion-icon.mr-2.text-success(name="checkmark-circle")
          .paragraph {{ card.text }}
          .d-flex.align-items-center
            .paragraph.font-weight-bold
              | {{ card.number }} {{ card.type }}
            a.btn.link.ml-2(@click.stop="deletePaymentMethod(card.id)") Remove
    .registration-card-header.borderless.p-t-20.px-0(v-show="!cardOptions.length")
      stripe-element-card(ref="elementRef" :pk="pk" @token="tokenCreated")
      .row
        .col.text-right
          b-button(v-show="!loading" type='button' variant='dark' @click="submit" :disabled="disabled") Add
          b-button(v-show="loading" type='button' variant='none')
            .lds-ring.lds-ring-small
              div
              div
              div
              div
</template>

<script>
  import { StripeCheckout, StripeElementCard  } from '@vue-stripe/vue-stripe';
  import PlaidLink from "vue-plaid-link";

  /* Will be deleted soon after we test it on staging */
  console.warn("process.env.STRIPE_PUBLISHABLE_KEY > ", process.env.STRIPE_PUBLISHABLE_KEY)

  export default {
    props: ['billingTypeSelected', 'billingTypeOptions', 'plan', 'userType'],
    components: {
      StripeCheckout,
      StripeElementCard,
      PlaidLink
    },
    created() {
      const paymentMethod = JSON.parse(localStorage.getItem('app.currentUser.paymentMethod'));
      if (paymentMethod) {
        this.cardSelected = paymentMethod.id
        this.onPaymentMethodChange(paymentMethod.id)
        this.cardOptions.push({ ...paymentMethod })
        this.$emit('complitedPaymentMethod', paymentMethod.id)
      }
    },
    data() {
      return {
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
        disabled: false
      };
    },
    methods: {
      submit () {
        // this will trigger the process
        this.$refs.elementRef.submit()
      },
      tokenCreated (token) {
        // handle the token
        // send it to your server
        const data = {
          userType: this.userType,
          stripeToken: token.id,
        }

        this.$store.dispatch('generatePaymentMethod', data)
          .then(response => {
            // this.isActive = false
            this.$refs.elementRef.clear()
            const data = { text: `Credit Card${this.cardOptions.length===0 ? ' (primary)' : ''}`, value: response.id, number: `**** **** **** ${response.last4}`, type: response.brand, id: response.id }
            this.cardOptions.push(data)
            this.cardSelected = response.id
            this.onPaymentMethodChange(response.id)
            // SAVE FOR RELOAD PAGE CASES
            localStorage.setItem('app.currentUser.paymentMethod', JSON.stringify(data));

            this.$emit('complitedPaymentMethod', response)
            this.toast('Success', `Payment method successfully added!`)
          })
          .catch(error => {
            console.error(error)
            this.toast('Error', 'Payment method could not be added.', true)
          })
      },
      deletePaymentMethod(cardId) {
        const data = {
          userType: this.userType,
          id: cardId,
        }

        this.$store.dispatch('deletePaymentMethod', data)
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
      onSuccess (publicToken, metadata) {
        const data = {
          userType: this.userType,
          plaid: {
            payment_source_ach: {
              plaid_token: publicToken,
              plaid_account_id: metadata.account_id,
              plaid_institution: metadata.institution.name
            }
          }
        }

        this.$store.dispatch('generatePaymentMethod', data)
          .then(response => {
            // this.isActive = false
            this.$refs.elementRef.clear()
            const data = { text: `${response.brand}${this.cardOptions.length===0 ? ' (primary)' : ''}`, value: response.id, number: `**** **** **** ${response.last4}`, type: '', id: response.id }
            this.cardOptions.push(data)
            this.cardSelected = response.id
            this.onPaymentMethodChange(response.id)
            // SAVE FOR RELOAD PAGE CASES
            localStorage.setItem('app.currentUser.paymentMethod', JSON.stringify(data));

            this.$emit('complitedPaymentMethod', response)
            this.toast('Success', `Payment method successfully added!`)
          })
          .catch(error => {
            console.error(error)
            // this.toast('Error', `Something wrong! ${error}`)
            this.toast('Error', 'Payment method could not be added.')
          })
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      planComputed() {
        return this.plan
      },
      pk() {
        return this.$store.getters.staticCollection.STRIPE_PUBLISHABLE_KEY
      },
      plaidPK() {
        return this.$store.getters.staticCollection.PLAID_PUBLIC_KEY;
      }
    },
    // mounted() {
    //   const data = {
    //     userType: this.userType,
    //   }
    //
    //   this.$store.dispatch('getPaymentMethod', data)
    //     .then(response => {
    //       const newOptions = response.map((card, index) => {
    //         return { text: `Credit Card${index===0 ? ' (primary)' : ''}`, value: card.id, number: `**** **** **** ${card.last4}`, type: card.brand, id: card.id }
    //       })
    //       this.cardOptions = newOptions
    //     })
    //     .catch(error => {
    //       console.error(error)
    //     })
    // }
  }
</script>

<style scoped>

</style>
