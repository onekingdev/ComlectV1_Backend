<template lang="pug">
  div
    .registration-card-header.p-b-20
      .row
        .col
          h4.registration-card__main-title Plan
          //p.registration-card__main-subtitle Review and confirm your subscription
        .col.text-right
          b-form-group(v-if="planComputed.id !== 1", v-slot="{ ariaDescribedby }")
            b-form-radio-group(id="btn-radios-plan"
            :checked="billingTypeSelected"
            :options="billingTypeOptions"
            :aria-describedby="ariaDescribedby"
            button-variant="outline-primary"
            size="md"
            name="radio-btn-outline"
            buttons
            @change="onBiliingChange"
            )
    .registration-card-header.p-y-20
      .row
        .col
          h4.registration-card-header__title {{ planComputed.name }}
          p.registration-card-header__subtitle {{ planComputed.description }}
        .col.text-right
          h4.registration-card-header__title {{ billingTypeSelected === 'annually' ?  planComputed.coastAnnuallyFormatted : planComputed.coastMonthlyFormatted }}
          p.registration-card-header__subtitle(v-if="planComputed.id !== 1") {{ billingTypeSelected === 'annually' ?  planComputed.usersCount + ' free users plus $' + planComputed.additionalUserAnnually + '/year per person' : planComputed.usersCount + ' free users plus $' + planComputed.additionalUserMonthly + '/mo per person' }}
    .registration-card-header.p-y-20(v-if="planComputed.id !== 1")
      .d-flex.justify-content-between
        div
          h4.registration-card-header__title Users
          p.registration-card-header__subtitle Enter the number of users (this is often your employee headcount)
        .d-block
          b-form-input.form-control-number(v-model="additionalUsersCount" type="number" min="1" max="100" @keyup="onChangeUserCount")
    .registration-card-header.p-y-20
      .d-flex.justify-content-between
        h4.m-t-1 Payment Method
        div.m-t-1
          a.btn.btn-light(@click="addBankAccount") Add Bank Account
    .card-body(v-if="cardOptions")
      dl.row(v-for="(card, i) in cardOptions")
        dt.col-sm-7
          input.mr-2.mt-1(:id="'card'+card.id" type='radio' name='card' :value='card.id' v-model="cardSelected" @click="onPaymentMethodChange(card.id)")
          label(:for="'card'+card.id") {{ card.text }}
        dd.col-sm-5.text-right.m-b-0
          | {{ card.number }} {{ card.type }}
          a.link.ml-2(href="#" @click.stop="deletePaymentMethod(card.id)") Remove
    .registration-card-header.p-y-20
      div(v-show="isActive")
        <!--p stripe-element-card:-->
        stripe-element-card(ref="elementRef"
        :pk="pk"
        @token="tokenCreated")
        <!--button(@click="submit") Generate token-->
        .row
          .col.text-right
            b-button(type='button' variant='outline-primary' @click="submit")
              b-icon.mr-2(icon="arrow-clockwise" animation="spin" font-scale="1" v-show="loading")
              | Add

</template>

<script>
  import { mapActions } from "vuex"
  import { StripeCheckout, StripeElementCard  } from '@vue-stripe/vue-stripe';

  export default {
    props: ['billingTypeSelected', 'billingTypeOptions', 'plan'],
    components: {
      StripeCheckout,
      StripeElementCard
    },
    data() {
      return {
        userType: 'business',
        // loading: false,
        // lineItems: [
        //   {
        //     price: 'price_1IiDiaGXaxE41NmqapXysseR', // The id of the one-time price you created in your Stripe dashboard
        //     quantity: 1,
        //   },
        // ],
        // successURL: 'https://example.com/success',
        // cancelURL: 'https://example.com/cancel',
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
        isActive: false,
      };
    },
    methods: {
      ...mapActions({
        generatePaymentMethod: 'settings/generatePaymentMethod',
        getPaymentMethod: 'settings/getPaymentMethod',
        deletePaymentMethod: 'settings/deletePaymentMethod'
      }),
      toast(title, str) {
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
        // handle the token
        // send it to your server
        const dataToSend = {
          userType: this.userType,
          stripeToken: token.id,
        }

        this.generatePaymentMethod(dataToSend)
          .then(response => {
            this.$emit('complitedPaymentMethod', response)
            this.toast('Success', `Payment Method successfully added!`)
            this.isActive = false
            this.cardOptions.push({ text: `Credit Card${this.cardOptions.length===0 ? ' (primary)' : ''}`, value: response.id, number: `**** **** **** ${response.last4}`, type: response.brand, id: response.id })
            this.cardSelected = response.id
          })
          .catch(error => {
            console.error(error)
            this.toast('Error', `Something wrong! ${error}`, true)
          })
      },
      // addCardDetail() {
        // this.cardOptions = Object.assign(this.cardOptions, {
        //   text: this.cardDetail.nameOnCard,
        //   value: this.cardOptions.length + 1,
        //   number: this.cardDetail.cardNumber,
        //   type: 'Visa',
        //   id: Math.floor(Math.random()) * 100
        // })
      // },
      deletePaymentMethod(cardId) {
        const dataToSend = {
          userType: this.userType,
          id: cardId,
        }

        this.deletePaymentMethod(dataToSend)
          .then(response => {
            const index = this.cardOptions.findIndex(record => record.id === payload.id);
            this.cardOptions.splice(index, 1)
            if (response.message)
              this.toast('Success', `${response.message}`)
          })
          .catch(error => {
            console.error(error)
            this.toast('Error', `Something wrong! ${error}`, true)
          })
      },
      addBankAccount() {
        this.isActive = true
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
        return process.env.STRIPE_PUBLISHABLE_KEY
      }
    },
    mounted() {
      const dataToSend = {
        userType: this.userType,
      }

      this.getPaymentMethod(dataToSend)
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
