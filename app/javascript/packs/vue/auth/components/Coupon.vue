<template lang="pug">
  b-form-group#inputCoupon-group-1.mb-0(label='Promo Code' label-for='inputCoupon')
    .d-flex.coupon
      b-form-input#inputCoupon.coupon__input(v-model='coupon' type='text' placeholder='Enter promo code' required :class="{'is-invalid': errors.coupon }" @keyup="onKeyUp")
      button.btn.btn-secondary.coupon__btn(v-if="!loading" type="button" :disabled="disabled" @click="activatePromoCode") Apply
      button.btn.btn-secondary.coupon__btn(v-if="loading")
        .lds-ring.lds-ring-small
          div
          div
          div
          div
    .valid-feedback.d-block(v-if="message") {{ message }}
    .invalid-feedback.d-block(v-if="errors.coupon") {{ errors.coupon }}
</template>

<script>
  export default {
    data() {
      return {
        coupon: '',
        message: '',
        errors: {},
        loading: false,
        disabled: false
      }
    },
    methods: {
      onKeyUp(e){
        if (e.keyCode === 13) {
          // ENTER KEY CODE
          this.activatePromoCode()
        }
      },
      clearErrorsAndMessages() {
        for (let value in this.errors) delete this.errors[value];
        this.message = ''
      },
      activatePromoCode () {
        this.clearErrorsAndMessages()

        this.loading = true

        const data = {
          coupon: this.coupon
        }

        this.$store.dispatch('applyCoupon', data)
          .then(response => {
            if(!response.errors) {
              // this.toast('Success', `${response.message}`)
              this.message = response.message
              this.$emit('couponApplied', response)
            }
          })
          .catch(error => {
            // this.toast('Error', `${error.data.errors.message}`, true)
            this.errors.coupon = error.data.errors.message
          })
          .finally(() => this.loading = false)
      }
    },
    watch: {
      coupon (value) {
        if (value) this.clearErrorsAndMessages()
      },
    }
  }
</script>

<style scoped>

</style>
