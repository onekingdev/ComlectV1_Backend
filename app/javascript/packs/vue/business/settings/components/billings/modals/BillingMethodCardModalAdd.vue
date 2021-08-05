<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" title="Add Card")
      .row
        .col
          stripe-element-card(ref="elementRef"
          :pk="pk"
          @token="tokenCreated")
      // .row
      //   .col
      //     b-form-group#inputBilling-group-1(label='Name on Card' label-for='inputBilling-1')
      //       b-form-input#inputBilling-1(v-model='cardDetail.nameOnCard' type='text' placeholder='Name on Card' required)
      //       .invalid-feedback.d-block(v-if="errors.nameOnCard") {{ errors.nameOnCard }}
      // .row
      //   .col-7.pr-2
      //     b-form-group#inputBilling-group-2(label='Card Number' label-for='inputBilling-2')
      //       b-form-input#inputBilling-2(v-model='cardDetail.cardNumber' type='text' placeholder='Card Number' required)
      //       .invalid-feedback.d-block(v-if="errors.cardNumber") {{ errors.cardNumber }}
      //   .col.px-2
      //     b-form-group#inputBilling-group-3(label='Exp date' label-for='inputBilling-3')
      //       b-form-input#inputBilling-3(v-model='cardDetail.expDate' type='text' placeholder='MM' required)
      //       .invalid-feedback.d-block(v-if="errors.expDate") {{ errorMonths.expDateMonth }}
      //   .col.px-2
      //     b-form-group#inputBilling-group-4(label='.' label-for='inputBilling-4')
      //       b-form-input#inputBilling-4(v-model='cardDetail.expDateYear' type='text' placeholder='YY' required)
      //       .invalid-feedback.d-block(v-if="errors.expDateYear") {{ errors.expDateYear }}
      //   .col.pl-2
      //     b-form-group#inputBilling-group-5(label='CVC/CVV' label-for='inputBilling-5')
      //       b-form-input#inputBilling-5(v-model='cardDetail.CVV' type='text' placeholder='3 or 4 digits' required)
      //       .invalid-feedback.d-block(v-if="errors.CVV") {{ errors.CVV }}
      // .row
      //   .col.pr-2
      //     b-form-group#inputBilling-group-6(label='Country' label-for='inputBilling-6')
      //       b-form-input#inputBilling-6(v-model='cardDetail.country' type='text' placeholder='Country' required)
      //       .invalid-feedback.d-block(v-if="errors.country") {{ errors.country }}
      //   .col.pl-2
      //     b-form-group#inputBilling-group-7(label='Zip' label-for='inputBilling-7')
      //       b-form-input#inputBilling-7(v-model='cardDetail.zip' type='text' placeholder='Enter zip code' required)
      //       .invalid-feedback.d-block(v-if="errors.zip") {{ errors.zip }}

      template(slot="modal-footer")
        button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") Save
</template>

<script>
  import { StripeCheckout, StripeElementCard  } from '@vue-stripe/vue-stripe';
  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

  export default {
    props: {
      inline: {
        type: Boolean,
        default: true
      },
      billingMethod: {
        type: String,
        default: ''
      }
    },
    components: {
      StripeCheckout,
      StripeElementCard
    },
    data() {
      return {
        userType: 'business',
        modalId: `modal_${rnd()}`,
        cardDetail: {
          nameOnCard: '',
          cardNumber: '',
          expDate: '',
          expDateYear: '',
          CVV: '',
          country: '',
          zip: '',
        },
        errors: {}
      }
    },
    methods: {
      submit(e) {
        e.preventDefault();

        // this will trigger the process
        this.$refs.elementRef.submit()

        // this.toast('Success', `....!`)
        // this.$emit('saved')
        // this.$bvModal.hide(this.modalId)
      },
      async tokenCreated (token) {
        console.log(token)
        // handle the token
        // send it to your server

        try {
          const dataToSend = {
            userType: this.userType,
            stripeToken: token.id,
          }

          await this.$store.dispatch('settings/generatePaymentMethod', dataToSend)
            .then(response => {
              this.$emit('complitedPaymentMethod', response)
              this.toast('Success', `Payment Method successfully added!`)
            })
            .catch(error => {
              console.error(error)
              this.toast('Error', `Something wrong! ${error}`)
            })
        } catch (error) {
          console.error(error)
        }
      },
    },
    computed: {
      pk() {
        return process.env.STRIPE_PUBLISHABLE_KEY
      }
    },
  }
</script>
