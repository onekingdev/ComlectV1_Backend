<template lang="pug">
  b-form-group#inputCoupon-group-1(label='Optional Promo Code' label-for='inputCoupon')
    .d-flex
      b-form-input#inputCoupon(v-model='promo_code' type='text' placeholder='Enter promo code' required :class="{'is-invalid': errors.promo_code }")
      a.btn.btn-light.ml-2(@click="activatePromoCode") Apply
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
      }
    }
  }
</script>

<style scoped>

</style>
