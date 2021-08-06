<template lang="pug">
  b-form-group#inputCoupon-group-1.mb-0(label='Promo Code' label-for='inputCoupon')
    .d-flex.coupon
      b-form-input#inputCoupon.coupon__input(v-model='promo_code' type='text' placeholder='Enter promo code' required :class="{'is-invalid': errors.promo_code }")
      a.btn.btn-secondary.coupon__btn(@click="activatePromoCode") Apply
    .invalid-feedback.d-block(v-if="errors.promo_code") {{ errors.promo_code[0] }}
</template>

<script>
  export default {
    data() {
      return {
        promo_code: '',
        errors: {}
      }
    },
    methods: {
      activatePromoCode () {
        console.log(this.promo_code)

        this.toast('Success', 'Discount successfully applied.')
        this.toast('Error', 'Invalid code. Discount was not applied.')

        this.$emit('couponApplied')
      }
    }
  }
</script>

<style scoped>

</style>
