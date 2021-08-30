<template lang="pug">
  div
    .registration-card-header.borderless.p-y-20.px-0
      .d-flex.justify-content-between.align-items-center
        h4.registration-card-header__title.mb-0 Payment Method
        div
          plaid-link(env='sandbox' :publicKey='plaidPK' clientName='Test App' product='auth' v-bind='{ onSuccess }')
            template(slot='button' slot-scope='props')
              a.btn.btn-default(@click="props.onClick") Add Bank Account
      div(v-for="(card, i) in cardOptions" :class="i === 0 ? 'p-t-20' : ''")
        .d-flex.align-items-center
          input.mr-2(:id="'card'+card.id" type='radio' name='card' :value='card.id' v-model="cardSelected" @click="onPaymentMethodChange(card.id)")
          label.paragraph.mb-0(:for="'card'+card.id") {{ card.text }}
          .d-flex.align-items-center.ml-auto
            .paragraph.font-weight-bold
              | {{ card.number }} {{ card.type }}
            a.btn.btn-link.ml-2(@click.stop="deletePaymentMethod(card.id)") Remove
        hr(v-if="i+1 !== cardOptions.length")
    .registration-card-header.borderless.p-t-20.px-0
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
  import { mapActions, mapGetters } from "vuex"
  import { StripeCheckout, StripeElementCard  } from '@vue-stripe/vue-stripe';
  import PlaidLink from "vue-plaid-link";

  export default {
    props: ['billingTypeSelected', 'billingTypeOptions', 'plan', 'userType'],
    components: {
      StripeCheckout,
      StripeElementCard,
      PlaidLink
    },
    // created() {
    //   const paymentMethod = JSON.parse(localStorage.getItem('app.currentUser.paymentMethod'));
    //   if (paymentMethod) {
    //     this.cardSelected = paymentMethod.id
    //     this.onPaymentMethodChange(paymentMethod.id)
    //     this.cardOptions.push({ ...paymentMethod })
    //     this.$emit('complitedPaymentMethod', paymentMethod.id)
    //   }
    // },
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
      ...mapActions({
        getPaymentMethod: 'settings/getPaymentMethod',
        generatePM: 'settings/generatePaymentMethod',
        deletePM: 'settings/deletePaymentMethod',
      }),
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

        this.generatePM(data)
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
            // this.toast('Success', `Payment method successfully added!`)
          })
          .catch(error => {
            console.error(error)
            // this.toast('Error', 'Payment method could not be added.', true)
          })
      },
      deletePaymentMethod(cardId) {
        const data = {
          userType: this.userType,
          id: cardId,
        }

        this.deletePM(data)
          .then(response => {
            const index = this.cardOptions.findIndex(record => record.id === cardId);
            this.cardOptions.splice(index, 1)
            // this.toast('Success', `${response.message.message}`)
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

        this.generatePM(data)
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
            // this.toast('Success', `Payment method successfully added!`)
          })
          .catch(error => {
            console.error(error)
            // this.toast('Error', `Something wrong! ${error}`)
            // this.toast('Error', 'Payment method could not be added.')
          })
      }
    },
    computed: {
      ...mapGetters({
        loading: 'loading',
        staticCollection: 'settings/staticCollection',
        paymentMethods: 'settings/paymentMethods',
      }),
      planComputed() {
        return this.plan
      },
      pk() {
        return this.staticCollection.STRIPE_PUBLISHABLE_KEY
      },
      plaidPK() {
        return this.staticCollection.PLAID_PUBLIC_KEY;
      }
    },
    async mounted() {
      try {
        const response = await this.getPaymentMethod({ userType: this.userType })
        if (response) {
          for(let paymentMethod of response) {
            const data = { text: `${paymentMethod.brand}${paymentMethod.primary ? ' (primary)' : ''}`, value: paymentMethod.id, number: `**** **** **** ${paymentMethod.last4}`, type: '', id: paymentMethod.id }
            this.cardOptions.push(data)
            if(paymentMethod.primary) {
              this.cardSelected = paymentMethod.id
              this.onPaymentMethodChange(paymentMethod.id)
            }
          }
        }
      } catch (error) {
        console.error(error)
      }
    }
  }
</script>

<style scoped>

</style>
