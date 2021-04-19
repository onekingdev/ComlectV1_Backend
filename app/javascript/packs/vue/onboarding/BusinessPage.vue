<template lang="pug">
  .col-xl-10.col-md-9.m-x-auto
    .card-body.white-card-body.registration.p-5
      .div
        h2 Set Up Your Account
        hr
        .steps
          .step(:class="currentStep === 1 || step2 ? 'active' : ''")
            h4.step__name 1. CRD Number
          .step(:class="currentStep === 2 || step3 ? 'active' : ''")
            h4.step__name 2. Company Information
          .step(:class="currentStep === 3 ? 'active' : ''")
            h4.step__name 3. Choose plan
      Loading
      b-form(@submit='onSubmit' v-if='show')
        #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
          h3 Do you have a CRD number?
            b-icon.h5.ml-2(icon="exclamation-circle-fill" variant="info")
          p The CRD number will be used to gather additional information about your business.
          div
            b-form-group(v-slot='{ ariaDescribedby }')
              b-form-radio-group(v-model='form.selected' :options='form.options' :aria-describedby='ariaDescribedby' name='radios-stacked' stacked)
            b-form-group(label='What is your CRD number?' v-if="form.selected === 'yes'")
              b-form-input.w-lg-50(v-model="form.crd" placeholder="Enter your CRD number")
          .text-right
            b-button(type='button' variant='dark' @click="nextStep(2)") Next
        #step2.form(v-if='!loading'  :class="step2 ? 'd-block' : 'd-none'")
          h3 Tell us more about your business
          .row
            .col-xl-6.pr-xl-2
              b-form-group#input-group-1(label='Company Name' label-for='input-1')
                b-form-input#input-1(v-model='form.companyName' type='text' placeholder='Company Name' required)
                .invalid-feedback.d-block(v-if="errors.companyName") {{ errors.companyName }}
          .row
            .col.pr-2
              b-form-group#input-group-2(label='AUM' label-for='input-2')
                b-form-input#input-2(v-model='form.aum' type='text' placeholder='AUM' required)
                .invalid-feedback.d-block(v-if="errors.aum") {{ errors.aum }}
            .col.pl-2
              b-form-group#input-group-3(label='Number of Accounts' label-for='input-3')
                b-form-input#input-3(v-model='form.numAcc' type='text' placeholder='Number of Accounts' required)
                .invalid-feedback.d-block(v-if="errors.numAcc") {{ errors.numAcc }}
          .row
            .col.pr-2
              b-form-group#input-group-4(label='Industry' label-for='select-4')
                multiselect#select-4(v-model="form.industry" :options="options" required)
                <!--b-form-select#select-4(v-model='form.industry' :options='options' required)-->
                .invalid-feedback.d-block(v-if="errors.industry") {{ errors.industry }}
            .col.pl-2
              b-form-group#input-group-5(label='Sub-Industry' label-for='select-5')
                b-form-select#select-5(v-model='form.subIndustry' :options='options' required)
                .invalid-feedback.d-block(v-if="errors.subIndustry") {{ errors.subIndustry }}
          .row
            .col.pr-2
              b-form-group#input-group-6(label='Jurisdiction' label-for='select-6')
                b-form-select#select-6(v-model='form.jurisdiction' :options='options' required)
                .invalid-feedback.d-block(v-if="errors.jurisdiction") {{ errors.jurisdiction }}
            .col.pl-2
              b-form-group#input-group-7(label='Company Website' label-for='input-7' description="Optional")
                b-form-input#input-7(v-model='form.companyWebsite' type='text' placeholder='Company Website' required)
                .invalid-feedback.d-block(v-if="errors.companyWebsite") {{ errors.companyWebsite }}
          .row
            .col-xl-6.pr-xl-2
              b-form-group#input-group-8(label='Phone Number' label-for='input-8')
                b-form-input#input-8(v-model='form.phoneNumber' type='text' placeholder='Phone Number' required)
                .invalid-feedback.d-block(v-if="errors.phoneNumber") {{ errors.phoneNumber }}
          hr
          .row
            .col-xl-8.pr-xl-2
              b-form-group#input-group-9(label='Business Address' label-for='input-9')
                b-form-input#input-9(v-model='form.businessAddress' placeholder='Business Address' required)
                .invalid-feedback.d-block(v-if="errors.businessAddress") {{ errors.businessAddress }}
            .col-xl-4.pl-xl-2
              b-form-group#input-group-10(label='Apt/Unit:' label-for='input-10')
                b-form-input#input-10(v-model='form.aptUnit' type='text' placeholder='Apt/Unit' required)
                .invalid-feedback.d-block(v-if="errors.aptUnit") {{ errors.aptUnit }}
          .row
            .col-xl-4.pr-xl-2
              b-form-group#input-group-11(label='Zip' label-for='input-11')
                b-form-input#input-11(v-model='form.zip' placeholder='Zip' required)
                .invalid-feedback.d-block(v-if="errors.zip") {{ errors.zip }}
            .col-xl-4.px-xl-2
              b-form-group#input-group-12(label='City' label-for='input-12')
                b-form-input#input-12(v-model='form.city' type='text' placeholder='City' required)
                .invalid-feedback.d-block(v-if="errors.city") {{ errors.city }}
            .col-xl-4.pl-xl-2
              b-form-group#input-group-13(label='State' label-for='select-13')
                b-form-select#select-13(v-model='form.state' :options='options' required)
                .invalid-feedback.d-block(v-if="errors.state") {{ errors.state }}
          .text-right
            b-button.mr-2(type='button' variant='light' @click="prevStep(1)") Go back
            b-button(type='button' variant='dark' @click="nextStep(3)") Next
        #step3.form(v-if='!loading'  :class="step3 ? 'd-block' : 'd-none'")
          div 3
          .text-right
            b-button.mr-2(type='button' variant='light' @click="prevStep(2)") Go back
            b-button(type='submit' variant='dark') Submit

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import Multiselect from 'vue-multiselect'

  export default {
    components: {
      Loading,
      Multiselect
    },
    data() {
      return {
        userId: '',
        otpSecret: '',
        userType: '',
        form: {
          crd: '',
          selected: 'no',
          options: [
            { text: 'No', value: 'no' },
            { text: 'Yes', value: 'yes' },
          ],
          companyName: '',
          aum: '',
          numAcc: '',
          industry: this.options,
          subIndustry: this.options,
          jurisdiction: '',
          companyWebsite: '',
          phoneNumber: '',
          businessAddress: '',
          aptUnit: '',
          zip: '',
          city: '',
          state: this.options,
        },
        options: [
          { value: null, text: 'Please select an option' },
          { text: 'Value 1', value: 'val1' },
          { text: 'Value 2', value: 'val2' },
        ],
        show: true,
        errors: {},
        step1: false,
        step2: true,
        step3: false,
        currentStep: 2,
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      onSubmit(event) {
        event.preventDefault()
        // CLEAR ERRORS
        this.errors = []

        const dataToSend = {
          crd: this.form.crd
        }
        console.log(dataToSend)
      },
      prevStep(stepNum) {
        this['step'+(stepNum+1)] = false
        this['step'+(stepNum-1)] = true
        this.currentStep = stepNum
      },
      nextStep(stepNum) {
        this['step'+(stepNum-1)] = false
        this['step'+stepNum] = true
        this.currentStep = stepNum
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
  }
</script>

<style scoped>
  .registration {
    margin-top: 2rem;
  }
  .steps {
    display: flex;
    justify-content: space-between;
    margin: 3.5rem 0;
  }
  .step {
    position: relative;
    width: 32%;
  }
  .step::before {
    display: block;
    position: absolute;
    top: -1rem;
    left: 0;
    right: 0;
    content: '';
    width: 100%;
    height: 3px;
    color: #dcdee4;
    background-color: #dcdee4;
  }
  .step.active::before {
    color: black;
    background-color: black;
  }
  .step__name {
    color: #dcdee4;
  }
  .step.active .step__name{
    color: black;
  }
</style>
