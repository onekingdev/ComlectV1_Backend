<template lang="pug">
  div
    .card-body
      .div
        h2 Set Up Client Billing
        hr
        .steps
          .step(:class="navStep1 ? 'active' : ''")
            h4.step__name 1. Account information
          .step(:class="navStep2 ? 'active' : ''")
            h4.step__name 2. Personal Information
          .step(:class="navStep3 ? 'active' : ''")
            h4.step__name 3. Payout type
      Overlay(v-if="overlay", :status="overlayStatus", :statusText="overlayStatusText", :show="overlay")
      .div
        Loading
        b-form(@submit='onSubmit' @change="onChangeInput" v-if='show')
          #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
            .row.d-none
              .col-md-6
                .row
                  .col
                    b-form-group#inputB-group-4(label='Account type' label-for='selectB-4' label-class="required")
                      div(
                      :class="{ 'invalid': errors.account_type }"
                      )
                        multiselect#selectB-4(
                        v-model="formStep1.business.account_type"
                        :options="accountTypeOptions"
                        :multiple="true"
                        :show-labels="false"
                        track-by="name",
                        label="name",
                        placeholder="Select Industry",
                        @input="onChange",
                        required)
                        .invalid-feedback.d-block(v-if="errors.account_type") {{ errors.account_type[0] }}
                .row
                  .col-sm.pr-sm-2
                    b-form-group#inputB-group-2(label='Legal first name' label-for='inputB-2')
                      b-form-input#inputB-2(v-model='formStep1.business.first_name' type='text' placeholder='Legal first name' required :class="{'is-invalid': errors.first_name }")
                      .invalid-feedback.d-block(v-if="errors.first_name") {{ errors.first_name[0] }}
                  .col-sm.pl-sm-2
                    b-form-group#inputB-group-3(label='Legal last name' label-for='inputB-3')
                      b-form-input#inputB-3(v-model='formStep1.business.last_name' type='text' placeholder='Legal last name' required :class="{'is-invalid': errors.last_name }")
                      .invalid-feedback.d-block(v-if="errors.last_name") {{ errors.last_name[0] }}
                .row
                  .col
                    b-form-group#inputB-group-2(label='Legal business name' label-for='inputB-2')
                      b-form-input#inputB-2(v-model='formStep1.business.legal_business_name' type='text' placeholder='Legal business name' required :class="{'is-invalid': errors.legal_business_name }")
                      .invalid-feedback.d-block(v-if="errors.legal_business_name") {{ errors.legal_business_name[0] }}
                .row
                  .col
                    b-form-group#inputB-group-4(label='Country' label-for='selectB-4' label-class="required")
                      div(
                      :class="{ 'invalid': errors.country }"
                      )
                        multiselect#selectB-4(
                        v-model="formStep1.business.country"
                        :options="countryOptions"
                        :multiple="true"
                        :show-labels="false"
                        track-by="name",
                        label="name",
                        placeholder="Select Industry",
                        @input="onChange",
                        required)
                        .invalid-feedback.d-block(v-if="errors.country") {{ errors.country[0] }}
                .row
                  .col
                    b-form-group#inputB-group-2(label='Email' label-for='inputB-2' description="We'll send you a confirmation code to confirm")
                      b-form-input#inputB-2(v-model='formStep1.business.email' type='text' placeholder='Email' required :class="{'is-invalid': errors.email }")
                      .invalid-feedback.d-block(v-if="errors.email") {{ errors.email[0] }}
            .row.d-none
              .col
                .text-right
                  a.btn.link.mr-2(href="#") Cancel
                  b-button(type='button' variant='dark' @click="nextStep(2)") Next
            .row
              .col-md-6.mx-auto
                .card
                  .card-body
                    h1.text-center Confirm your email!
                    p.text-center We send a 6 digit code to email. Please enter it below.
                    div
                      b-form
                        b-form-group
                          .col.text-center
                            ion-icon(name="mail-outline")
                        b-form-group
                          .row
                            .col-12.mx-0
                              .d-flex.justify-content-space-around.mx-auto
                                b-form-input#inputCode1.code-input.ml-auto(type='number' maxlength="1" required)
                                b-form-input#inputCode2.code-input(type='number' maxlength="1" required)
                                b-form-input#inputCode3.code-input(type='number' maxlength="1" required)
                                b-form-input#inputCode4.code-input(type='number' maxlength="1" required)
                                b-form-input#inputCode5.code-input(type='number' maxlength="1" required)
                                b-form-input#inputCode6.code-input.mr-auto(type='number' maxlength="1" required)
                              <!--.invalid-feedback.d-block.text-center(v-if="errors.code") {{ errors.code }}-->
                          .row
                            .col
                              input(type='hidden')
                        b-button.w-100.mb-2(type='submit' variant='dark' ref="codesubmit") Submit
                        b-form-group
                          .row
                            .col-12.text-center
                              button.btn.link  Resend code
          #step2.form(v-if='!loading'  :class="step2 ? 'd-block' : 'd-none'")
            div.d-flex.justify-content-between
              .text-left
                h3.onboarding__title Tell us more about yourself:
                p.onboarding__sub-title We will use this to verify your identity
            .row
              .col-sm-6.pr-sm-2
                InputDate(v-model="formStep2.business.date_of_birth" :errors="errors.date_of_birth" :options="datepickerOptions") Date of birth
              .col-sm-6.pl-sm-2
                b-form-group#inputB-group-7(label='Last 4 digits of Security Social Number' label-for='inputB-7')
                  b-form-input#inputB-7.form-control(v-model='formStep2.business.last4ssn' type='text' placeholder='Enter last 4 digits of SSN' :class="{'is-invalid': errors.last4ssn }")
                  .invalid-feedback.d-block(v-if="errors.last4ssn") {{ errors.last4ssn[0] }}
            .row
              .col-sm-6.pr-sm-2
                b-form-group#inputB-group-7(label='Business operation name' label-for='inputB-7' description="optional")
                  b-form-input#inputB-7.form-control(v-model='formStep2.business.business_name' type='text' placeholder='Doing business as' :class="{'is-invalid': errors.business_name }")
                  .invalid-feedback.d-block(v-if="errors.business_name") {{ errors.business_name[0] }}
              .col-sm-6.pl-sm-2
                b-form-group#inputB-group-7(label='Business Website' label-for='inputB-7' description="Optional")
                  b-form-input#inputB-7.form-control(v-model='formStep2.business.website' type='text' placeholder='Business Website' :class="{'is-invalid': errors.website }")
                  .invalid-feedback.d-block(v-if="errors.website") {{ errors.website[0] }}
            hr
            .row
              .col-xl-9.pr-xl-2
                b-form-group#inputB-group-9(label='Home Address' label-for='inputB-9' label-class="required")
                  vue-google-autocomplete#map(ref="address" classname='form-control' :class="{'is-invalid': errors.address_1 }" v-model='formStep2.business.address_1' placeholder='Business Address'  :fields="['address_components', 'adr_address', 'geometry', 'formatted_address', 'name']" v-on:placechanged='getAddressData')
                  .invalid-feedback.d-block(v-if="errors.address_1") {{ errors.address_1[0] }}
              .col-xl-3.pl-xl-2
                b-form-group#inputB-group-10(label='Apt/Unit:' label-for='inputB-10')
                  b-form-input#inputB-10(v-model='formStep2.business.apartment' type='text' placeholder='Apt/Unit' required :class="{'is-invalid': errors.apartment }")
                  .invalid-feedback.d-block(v-if="errors.apartment") {{ errors.apartment[0] }}
            .row
              .col-xl-4.pr-xl-2
                b-form-group#inputB-group-12(label='City' label-for='inputB-12' label-class="required")
                  b-form-input#inputB-12(v-model='formStep2.business.city' type='text' placeholder='City' required :class="{'is-invalid': errors.city }")
                  .invalid-feedback.d-block(v-if="errors.city") {{ errors.city[0] }}
              .col-xl-4.px-xl-2
                b-form-group#inputB-group-13(label='State' label-for='selectB-13' label-class="required")
                  div(
                  :class="{ 'invalid': errors.state }"
                  )
                    multiselect#selectB-13(
                    v-model="formStep2.business.state"
                    :options="stateOptions"
                    :show-labels="false"
                    placeholder="Select state",
                    @input="onChangeState",
                    required)
                    .invalid-feedback.d-block(v-if="errors.state") {{ errors.state[0] }}
              .col-xl-4.pl-xl-2
                b-form-group#inputB-group-11(label='Zip' label-for='inputB-11' label-class="required")
                  b-form-input#inputB-11(v-model='formStep2.business.zipcode' placeholder='Zip' required :class="{'is-invalid': errors.zipcode }")
                  .invalid-feedback.d-block(v-if="errors.zipcode") {{ errors.zipcode[0] }}
            .text-right.m-t-3
              b-button.mr-2(type='button' variant='default' @click="prevStep(1)") Go back
              // b-button.mr-2(type='button' variant='outline-primary' @click="nextStep(3)") Skip this step
              b-button(type='button' variant='dark' @click="nextStep(3)") Next
          #step3.form(v-if='!loading'  :class="step3 ? 'd-block' : 'd-none'")
            .row
              .col-md-6
                div.d-flex.justify-content-between
                  .text-left
                    h3.onboarding__title Tell us where you'd like to recieve your payments
                .row
                  .col
                    b-form-group#inputB-group-7(label='Routing Number' label-for='inputB-7')
                      b-form-input#inputB-7.form-control(v-model='formStep3.business.routing_number' type='text' placeholder='000123456789' :class="{'is-invalid': errors.routing_number }")
                      .invalid-feedback.d-block(v-if="errors.routing_number") {{ errors.routing_number[0] }}
                .row
                  .col
                    b-form-group#inputB-group-7(label='Account Number' label-for='inputB-7')
                      b-form-input#inputB-7.form-control(v-model='formStep3.business.acc_num' type='text' placeholder='000123456789' :class="{'is-invalid': errors.acc_num }")
                      .invalid-feedback.d-block(v-if="errors.acc_num") {{ errors.acc_num[0] }}
                .row
                  .col
                    b-form-group#inputB-group-7(label='Confirm Account Number' label-for='inputB-7')
                      b-form-input#inputB-7.form-control(v-model='formStep3.business.confirm_acc_num' type='text' placeholder='000123456789' :class="{'is-invalid': errors.confirm_acc_num }")
                      .invalid-feedback.d-block(v-if="errors.confirm_acc_num") {{ errors.confirm_acc_num[0] }}
            .row
              .col.text-right.mt-3
                b-button.mr-2(type='button' variant='default' @click="prevStep(2)") Go back
                b-button(type='button' variant='primary') Submit
</template>

<script>
  import VueGoogleAutocomplete from 'vue-google-autocomplete'

  const {DateTime} = require('luxon')
  const {zones} = require('tzdata')
  const luxonValidTimeZoneName = function (zoneName) {
    let hours = (DateTime.local().setZone(zoneName).offset / 60);
    let rhours = Math.floor(hours)
    let rhoursView = Math.floor(hours) < 10 && Math.floor(hours) >= 0 ? '0'+Math.round(hours) : '-0'+Math.abs(hours)
    let minutes = (hours - rhours) * 60;
    let rminutes = Math.round(minutes) === 0 ? '0'+Math.round(minutes) : Math.round(minutes)
    let zoneNameView = zoneName.split('/')[1] ? zoneName.split('/')[1].replace('_', ' ') : zoneName

    return `(GMT ${rhoursView}:${rminutes}) ${zoneNameView}`
  }
  const luxonValidTimezones = Object.entries(zones)
    .filter(([zoneName, v]) => Array.isArray(v))
    .map(([zoneName, v]) => zoneName)
    .filter(tz => DateTime.local().setZone(tz).isValid)
    .map(zoneName => `${luxonValidTimeZoneName(zoneName)}`)

  import Loading from '@/common/Loading/Loading'
  import TopNavbar from "@/auth/components/TopNavbar";
  import Multiselect from 'vue-multiselect'
  import BillingDetails from './BillingDetails'
  import PurchaseSummary from './PurchaseSummary'
  import Overlay from './Overlay'

  import data from './BillingPlansData.json'
  import OtpConfirm from "@/auth/components/OtpConfirm";

  const initialAccountInfo = () => ({
    business: {
      contact_phone: '',
      business_name: '',
      website: '',
      aum: '',
      apartment: '',
      client_account_cnt: '',
      address_1: '',
      city: '',
      state: '',
      zipcode: '',
      industries: [],
      sub_industries: [],
      jurisdictions: [],
      time_zone: [],
    }
  })

  const initialPersonalInfo = () => ({
    business: {
      date_of_birth: '',
      last4ssn: '',
      business_name: '',
      website: '',
      address_1: '',
      city: '',
      state: '',
      zipcode: '',
    }
  })

  const initialPayoutType = () => ({
    business: {
      routing_number: '',
      acc_num: '',
      confirm_acc_num: '',
    }
  })

  export default {
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states', 'userInfo', 'timezones'],
    components: {
      OtpConfirm,
      Loading,
      TopNavbar,
      Multiselect,
      BillingDetails,
      PurchaseSummary,
      Overlay,
      VueGoogleAutocomplete
    },
    created() {
      // if(luxonValidTimezones) this.timeZoneOptions = luxonValidTimezones;
      if(luxonValidTimezones) {
        for (const value of luxonValidTimezones) {
          const [ gmt, zone ] = value.split(') ')
          this.timeZoneOptions.push({
            value: zone,
            name: value
          })
        }
      }
      if(this.industryIds) this.industryOptions = this.industryIds;
      // if(this.subIndustryIds) this.formStep2.subIndustryOptions = this.subIndustryIds;
      // if(this.subIndustryIds) {
      //   for (const [key, value] of Object.entries(this.subIndustryIds)) {
      //     this.formStep2.subIndustryOptions.push({
      //       value: key,
      //       name: value
      //     })
      //   }
      // }
      if(this.jurisdictionIds) this.jurisdictionOptions = this.jurisdictionIds;
      if(this.states) this.stateOptions = this.states;

      const accountInfo = localStorage.getItem('app.currentUser');
      const accountInfoParsed = JSON.parse(accountInfo);
      if(accountInfo) {
        if(accountInfo.crd_number) this.formStep1.crd_number = accountInfo.crd_number
        this.formStep2.business = Object.assign({}, this.formStep2.business, { ...accountInfoParsed })
        this.onChange(accountInfoParsed.industries)

        this.formStep2.business.sub_industries = accountInfoParsed.sub_industries ? accountInfoParsed.sub_industries.map((subInd, idx) => {
          const subIndfromOpt = this.subIndustryOptions.find(opt => {
            if (opt.name === subInd)
              return opt
          })
          return {
            name: subIndfromOpt.name,
            value: subIndfromOpt.value
          }
        }) : []
      }

      const url = new URL(window.location);
      const stepNum = +url.searchParams.get('step');
      this.currentStep = stepNum;

      if (stepNum === 2) {
        this.step1 = false;
        this.step2 = true;
        this.step3 = false;
        this.navStep1 = true;
        this.navStep2 = true;
        this.navStep3 = false;
      }
      if (stepNum === 3) {
        this.step1 = false;
        this.step2 = false;
        this.step3 = true;
        this.navStep1 = true;
        this.navStep2 = true;
        this.navStep3 = true;
      }
    },
    data() {
      return {
        userType: 'business',
        formStep1: initialAccountInfo(),
        accountTypeOptions: [],
        countryOptions: [],

        formStep2: initialPersonalInfo(),
        stateOptions: [],
        show: true,

        formStep3: initialPayoutType(),

        errors: {},
        step1: true,
        step2: false,
        step3: false,
        currentStep: 1,
        navStep1: true,
        navStep2: false,
        navStep3: false,

        overlay: false,
        overlayStatus: '',
        overlayStatusText: '',
      }
    },
    methods: {
      onSubmit(event){
        event.preventDefault()
      },
      navigation(stepNum){
        const url = new URL(window.location);
        url.searchParams.set('step', stepNum);
        window.history.pushState({}, '', url);

        this['step'+(stepNum-1)] = false
        this['navStep'+stepNum] = true
        this['step'+stepNum] = true
        this.currentStep = stepNum
      },
      prevStep(stepNum) {
        this['step'+(stepNum+1)] = false
        this['navStep'+(stepNum+1)] = false
        this['step'+stepNum] = true
        this.currentStep = stepNum
        this.navigation(this.currentStep)
      },
      nextStep(stepNum) {
        // CLEAR ERRORS
        this.errors = []

        if (stepNum === 2) {
          if (this.formStep1.crd_numberSelected === 'yes') {
            this.checkCDRinfo(stepNum)
            return
          }
          if (this.formStep1.crd_numberSelected === 'no') this.formStep1.crd_number = ''

          this['step'+(stepNum-1)] = false
          this['navStep'+stepNum] = true
          this['step'+stepNum] = true
          this.currentStep = stepNum
          this.navigation(this.currentStep)
        }

        if (stepNum === 3) {

          // if (!this.formStep2.business.industry) this.errors = Object.assign({}, this.errors, { industry: `Field can't be empty!` })
          // if (!this.formStep2.business.subIndustry) this.errors = Object.assign({}, this.errors, { subIndustry: `Field can't be empty!` })
          // if (!this.formStep2.business.jurisdiction) this.errors = Object.assign({}, this.errors, { jurisdiction: `Field can't be empty!` })
          // if (!this.formStep2.business.industry || !this.formStep2.business.subIndustry || !this.formStep2.business.jurisdiction ) return

          delete this.formStep2.errors
          const dataToSend = this.formStep2
          if(!this.formStep1.crd_number.length) delete dataToSend.business.crd_number

          dataToSend.business.industry_ids = this.formStep2.business.industries ? this.formStep2.business.industries.map(record => record.id) : []
          dataToSend.business.sub_industry_ids = this.formStep2.business.sub_industries ? this.formStep2.business.sub_industries.map(record => record.value) : []
          dataToSend.business.jurisdiction_ids = this.formStep2.business.jurisdictions ? this.formStep2.business.jurisdictions.map(record => record.id) : []
          dataToSend.business.time_zone = this.formStep2.business.time_zone ? this.formStep2.business.time_zone.value : ''

          // delete dataToSend.business.industries
          // delete dataToSend.business.sub_industries
          // delete dataToSend.business.jurisdictions

          this.$store.dispatch('updateAccountInfo', dataToSend)
            .then(response => {
              if(response.errors) {
                for (const type of Object.keys(response.errors)) {
                  this.errors = response.errors[type]
                  this.toast('Error', `Form has errors! Please recheck fields!`)
                }
              }
              if(!response.errors) {
                this['step'+(stepNum-1)] = false
                this['navStep'+stepNum] = true
                this['step'+stepNum] = true
                this.currentStep = stepNum
                this.navigation(this.currentStep)
                this.toast('Success', `Company info successfully sended!`)
              }
            })
            .catch(error => {
              console.error(error)
              this.toast('Error', `Something wrong! ${error}`)
            })
        }
      },

      onBiliingChange(event) {
        this.billingTypeSelected = event
      },
      updateAdditionalUsers(event){
        this.additionalUsers = event
      },
      complitedPaymentMethod(response) {
        this.paymentSourceId = response.id
        this.disabled = false;
      },
      onChangeInput(e) {
        if(e.target) e.target.classList.remove('is-invalid')
        if(e.target.nextElementSibling) e.target.nextElementSibling.classList.remove('d-block')
      },
      onChangeState(){
        delete this.errors.state
      },
      onAdressChange() {
        const address = this.formStep2.business.address_1
        console.log('address', address)

        this.$store.dispatch('getGeo', address)
          .then(response => console.log('response', response))
          .catch(error => console.error(error))
      },
      getAddressData (addressData, placeResultData, id) {
        // console.log('addressData', addressData)
        // console.log('placeResultData', placeResultData)
        // console.log('id', id)
        const input = document.getElementById(id)
        const { administrative_area_level_1, locality, postal_code } = addressData

        this.formStep2.business.address_1 = input.value
        this.formStep2.business.city = locality
        this.formStep2.business.state = administrative_area_level_1
        this.formStep2.business.zipcode = postal_code
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      datepickerOptions() {
        return {
          min: new Date
        }
      },
    }
  }
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style>
  /* MULTISELECT */
  .multiselect {
    min-height: 20px;
  }
  .multiselect__placeholder {
    margin-bottom: 0;
    padding-top: 0;
    padding-bottom: 2px;
  }
  .multiselect__tags {
    min-height: 20px;
    padding: 5px 40px 0 10px;
    margin-bottom: 0;
    border-color: #ced4da;
    border-radius: 0.25rem;
  }
  .invalid .multiselect__tags {
    border-color: #cd1837;
  }
  .multiselect__tag {
    padding: 2px 26px 2px 10px;
    margin-bottom: 0;
    color: #0479ff;
    background: #ecf4ff;
  }
  .multiselect__tag-icon:after {
    color: #0479ff;
  }
  .multiselect__option--highlight {
    color: #0479ff;
    background: #ecf4ff;
  }
  .multiselect__option--highlight::after{
    background: #0479ff;
  }
  .multiselect__tag-icon {
    line-height: 1.2rem;
  }
  .multiselect__tag-icon:hover {
    color: white;
    background: #0479ff;
  }
  .multiselect__select {
    height: 30px;
  }
  .multiselect__single {
    margin-bottom: 0;
    font-size: 1.2rem;
    line-height: 14px;
  }

  /* ALERTS*/
  .alert-primary {
    color: #303132;
    background-color: #ecf4ff;
    border-color: transparent;
    /*border-left-color: #0479ff;*/
    border-radius: 0;
    border-width: 0;
    box-shadow: inset 5px 0 0 #0479ff;
  }
  .alert-dismissible .close {
    top: 10px;
    font-size: 1.8rem;
  }

  /*BUTTONS*/
  .btn-outline-primary {
    color: #303132;
    border-color: #303132;
    font-weight: bold;
  }
  .btn-outline-primary:hover:not(:disabled):not(.disabled),
  .btn-outline-primary.active:not(:disabled):not(.disabled) {
    color: #fff;
    background-color: #303132;
    border-color: #303132;
  }

  /*RADIO BUTTONS*/
  .custom-control-label{
    line-height: 2.1;
  }
  .custom-control-input:not(:disabled):active ~ .custom-control-label::before,
  .custom-control-input:checked ~ .custom-control-label::before {
    color: #fff;
    border-color: #303132;
    background-color: #303132;
  }
  .custom-control-label::before,
  .custom-control-label::after {
    left: -2rem;
    width: 1.5rem;
    height: 1.5rem;
  }
  .custom-radio .custom-control-input:checked ~ .custom-control-label::after {
    background-image: none;
    background-color: black;
    padding: 2px;
    border: solid 3px white;
    border-radius: 50%;
    box-shadow: 0 0 0px 2px black;
  }
</style>

