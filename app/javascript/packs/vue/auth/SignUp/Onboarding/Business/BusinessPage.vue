<template lang="pug">
  .container-fluid
    TopNavbar(:userInfo="userInfo")
    main.row#main-content
      .col-xl-10.col-md-9.m-x-auto
        Overlay(v-if="overlay", :status="overlayStatus", :statusText="overlayStatusText", :show="overlay")
        .card.registration-onboarding
          .card-header
            h2.registration-onboarding__title Set Up Your Account
          .card-body.white-card-body.borderless.onboarding
            Steps(:steps="steps", :currentStep="currentStep")
            //Loading
            b-form(@submit='onSubmit' @change="onChangeInput" v-if='show')
              #step1.form(:class="step1 ? 'd-block' : 'd-none'")
                .row
                  .col
                    h3.onboarding__title.m-b-10 Do you have a CRD number?
                      b-icon.onboarding__icon(icon="exclamation-circle-fill" variant="secondary" v-b-tooltip.hover title="Automated update company info by CRD number")
                    p.onboarding__sub-title.m-b-20 The CRD number will be used to gather additional information about your business.
                .row
                  .col
                    b-form-group(v-slot='{ ariaDescribedby }')
                      b-form-radio-group(v-model='formStep1.crd_numberSelected' :options='formStep1.crd_numberOptions' :aria-describedby='ariaDescribedby' name='radios-stacked' stacked)
                .row
                  .col-lg-6
                    .row
                      .col.offset-lg-1.pr-0.pl-0
                        b-form-group(v-if="formStep1.crd_numberSelected === 'yes'" label='What is your CRD number?' label-class="onboarding__label label pb-0")
                          b-form-input(v-model="formStep1.crd_number" placeholder="Enter your CRD number" :class="{'is-invalid': errors.crd_number }")
                          .invalid-feedback.d-block(v-if="errors.crd_number") {{ errors.crd_number }}
                .row
                  .col
                    .text-right.m-t-30
                      b-button(type='button' variant='dark' @click="nextStep(2)") Next
                        b-icon.ml-2(icon="chevron-right")
              #step2.form(:class="step2 ? 'd-block' : 'd-none'")
                Notifications.m-b-20(v-if="formStep1.crd_number && formStep1.crd_number.length" :notify="notify" @clicked="clickNotify")
                h3.onboarding__title.m-b-20 Tell us more about your business
                .row
                  .col-xl-6.pr-xl-2
                    b-form-group#inputB-group-1(label='Company Name' label-for='inputB-1' label-class="onboarding__label required")
                      b-form-input#inputB-1(v-model='formStep2.business.business_name' type='text' placeholder='Company Name' required :class="{'is-invalid': errors.business_name }")
                      .invalid-feedback.d-block(v-if="errors.business_name") {{ errors.business_name[0] }}
                .row
                  .col-sm.pr-sm-2
                    b-form-group#inputB-group-2(label='AUM' label-for='inputB-2' label-class="onboarding__label")
                      b-form-input#inputB-2(v-model='formStep2.business.aum' type='text' placeholder='AUM' required :class="{'is-invalid': errors.aum }")
                      .invalid-feedback.d-block(v-if="errors.aum") {{ errors.aum[0] }}
                  .col-sm.pl-sm-2
                    b-form-group#inputB-group-3(label='Number of Accounts' label-for='inputB-3')
                      b-form-input#inputB-3(v-model='formStep2.business.client_account_cnt' type='text' placeholder='Number of Accounts' required :class="{'is-invalid': errors.client_account_cnt }")
                      .invalid-feedback.d-block(v-if="errors.client_account_cnt") {{ errors.client_account_cnt[0] }}
                .row
                  .col-sm-6.pr-sm-2
                    b-form-group#inputB-group-4(label='Industry' label-for='selectB-4' label-class="onboarding__label required")
                      div(
                      :class="{ 'invalid': errors.industries }"
                      )
                        multiselect#selectB-4(
                        v-model="formStep2.business.industries"
                        :options="industryOptions"
                        :multiple="true"
                        :show-labels="false"
                        track-by="name",
                        label="name",
                        placeholder="Select Industry",
                        @input="onChange",
                        required)
                        .invalid-feedback.d-block(v-if="errors.industries") {{ errors.industries[0] }}
                        // label.typo__label.form__label(v-if="errors.industries") {{ errors.industries[0] }}
                  .col-sm-6.pl-sm-2
                    b-form-group#inputB-group-5(label='Sub-Industry' label-for='selectB-5')
                      div(
                      :class="{ 'invalid': errors.subIndustry }"
                      )
                        multiselect#selectB-5(
                        v-model="formStep2.business.sub_industries"
                        :options="subIndustryOptions"
                        :multiple="true"
                        :show-labels="false"
                        track-by="name",
                        label="name",
                        placeholder="Select Sub-Industry",
                        required)
                        .invalid-feedback.d-block(v-if="errors.subIndustry") {{ errors.subIndustry[0] }}
                .row
                  .col-sm-6.pr-sm-2
                    b-form-group#inputB-group-6(label='Jurisdiction' label-for='selectB-6')
                      div(
                      :class="{ 'invalid': errors.jurisdiction }"
                      )
                        multiselect#selectB-6(
                        v-model="formStep2.business.jurisdictions"
                        :options="jurisdictionOptions"
                        :multiple="true"
                        :show-labels="false"
                        track-by="name",
                        label="name",
                        placeholder="Select Jurisdiction",
                        required)
                        .invalid-feedback.d-block(v-if="errors.jurisdiction") {{ errors.jurisdiction[0] }}
                  .col-sm-6.pl-sm-2
                    b-form-group#inputB-group-7(label='Time Zone' label-for='selectB-7')
                      div(
                      :class="{ 'invalid': errors.time_zone }"
                      )
                        multiselect#selectB-7(
                        v-model="formStep2.business.time_zone"
                        :options="timeZoneOptions"
                        :multiple="false"
                        :show-labels="false"
                        track-by="name",
                        label="name"
                        placeholder="Select Time Zone",
                        required)
                        .invalid-feedback.d-block(v-if="errors.time_zone") {{ errors.time_zone[0] }}
                .row
                  .col-sm-6.pr-sm-2
                    b-form-group#inputB-group-8(label='Phone Number' label-for='inputB-8' label-class='onboarding__label')
                      b-form-input#inputB-8(v-model='formStep2.business.contact_phone' type='text' placeholder='Phone Number' required :class="{'is-invalid': errors.contact_phone }")
                      .invalid-feedback.d-block(v-if="errors.contact_phone") {{ errors.contact_phone[0] }}
                  .col-sm-6.pl-sm-2
                    b-form-group#inputB-group-7(label='Company Website' label-for='inputB-7' label-class='onboarding__label' description="Optional")
                      b-form-input#inputB-7.form-control(v-model='formStep2.business.website' type='text' placeholder='Company Website' :class="{'is-invalid': errors.website }")
                      .invalid-feedback.d-block(v-if="errors.website") {{ errors.website[0] }}
                hr
                .row
                  .col-xl-9.pr-xl-2
                    b-form-group#inputB-group-9(label='Business Address' label-for='inputB-9' label-class='onboarding__label')
                      // b-form-input#inputB-9(v-model='formStep2.business.address_1' placeholder='Business Address' required :class="{'is-invalid': errors.address_1 }" v-debounce:1000ms="onAdressChange")
                      vue-google-autocomplete#map(ref="address" classname='form-control' :class="{'is-invalid': errors.address_1 }" v-model='formStep2.business.address_1' placeholder='Business Address'  :fields="['address_components', 'adr_address', 'geometry', 'formatted_address', 'name']" v-on:placechanged='getAddressData')
                      .invalid-feedback.d-block(v-if="errors.address_1") {{ errors.address_1[0] }}
                  .col-xl-3.pl-xl-2
                    b-form-group#inputB-group-10(label='Apt/Unit:' label-for='inputB-10' label-class='onboarding__label')
                      b-form-input#inputB-10(v-model='formStep2.business.apartment' type='text' placeholder='Apt/Unit' required :class="{'is-invalid': errors.apartment }")
                      .invalid-feedback.d-block(v-if="errors.apartment") {{ errors.apartment[0] }}
                .row
                  .col-xl-4.pr-xl-2
                    b-form-group#inputB-group-12(label='City' label-for='inputB-12' label-class="onboarding__label required")
                      b-form-input#inputB-12(v-model='formStep2.business.city' type='text' placeholder='City' required :class="{'is-invalid': errors.city }")
                      .invalid-feedback.d-block(v-if="errors.city") {{ errors.city[0] }}
                  .col-xl-4.px-xl-2
                    b-form-group#inputB-group-13(label='State' label-for='selectB-13' label-class="onboarding__label required")
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
                    b-form-group#inputB-group-11(label='Zip' label-for='inputB-11' label-class='onboarding__label')
                      b-form-input#inputB-11(v-model='formStep2.business.zipcode' placeholder='Zip' required :class="{'is-invalid': errors.zipcode }")
                      .invalid-feedback.d-block(v-if="errors.zipcode") {{ errors.zipcode[0] }}
                .row
                  .col
                    .text-right.m-t-30
                      b-button.mr-2(type='button' variant='default' @click="prevStep(1)")
                        b-icon.mr-2(icon="chevron-left")
                        | Go back
                      // b-button.mr-2(type='button' variant='outline-primary' @click="nextStep(3)") Skip this step
                      b-button(type='button' variant='dark' @click="nextStep(3)") Next
                        b-icon.ml-2(icon="chevron-right")
              #step3.form(:class="step3 ? 'd-block' : 'd-none'")
                .row
                  .col.mb-2.text-center
                    h2.m-b-20 Choose your plan
                    b-form-group.m-b-40(v-slot="{ ariaDescribedby }")
                      b-form-radio-group(id="btn-radios-plan"
                      v-model="billingTypeSelected"
                      :options="billingTypeOptions"
                      :aria-describedby="ariaDescribedby"
                      button-variant="outline-primary"
                      size="lg"
                      name="radio-btn-outline"
                      buttons)
                .billing-plans
                  b-card.billing-plan(v-for='(plan, index) in billingPlans' :class="[index === 0 ? 'billing-plan_low' : '', index === 1 ? 'billing-plan_medium' : '', index === 2 ? 'billing-plan_high' : '' ]")
                    b-button.m-b-20(type='button' :variant="currentPlan.status && currentPlan.id === index+1 ? 'dark' : 'outline-primary'" @click="openDetails(plan)")
                      | {{ currentPlan.status && currentPlan.id === index+1 ? 'Current' : 'Select' }} Plan
                    b-card-text
                      h4.billing-plan__name {{ plan.name }}
                      p.billing-plan__descr {{ plan.description }}
                      h5.billing-plan__coast {{ billingTypeSelected === 'annually' ?  plan.coastMonthlyDiscountFormatted : plan.coastMonthlyFormatted }}
                      p.billing-plan__users(v-if="plan.id === 1") {{ plan.users }}
                      p.billing-plan__users(v-if="plan.id !== 1 && billingTypeSelected === 'annually'")
                        span.billing-plan__discount {{ plan.coastMonthlyFormatted }}
                        span.text-success &nbsp;{{ plan.coastAnnuallyFormatted }}
                      p.billing-plan__users(v-if="plan.id !== 1") {{ billingTypeSelected === 'annually' ?  plan.usersCount + ' free users plus $' + plan.additionalUserAnnually + '/year per person' : plan.usersCount + ' free users plus $' + plan.additionalUserMonthly + '/mo per person' }}
                      hr
                      ul.list-unstyled.billing-plan__list
                        li.billing-plan__item(v-for="feature in plan.features")
                          b-icon.billing-plan__icon(icon="check-circle-fill" variant="success")
                          span(v-html="feature")
                .row
                  .col
                    .text-right.m-t-30
                      b-button(type='button' variant='default' @click="prevStep(2)") Go back

        b-sidebar#BillingPlanSidebar(@hidden="closeSidebar" v-model="isSidebarOpen" backdrop-variant='dark' backdrop left no-header width="60%" no-close-on-backdrop)
          .card.registration-card
            .card-header.borderless.m-b-80.px-0.pt-0
              .d-flex.justify-content-between.m-b-40
                b-button(variant="default" @click="isSidebarOpen = false")
                  b-icon.mr-2(icon="chevron-left" variant="dark")
                  | Back
              .registration-card__header
                h2.registration-card__main-title Time to power up
                p.registration-card__main-subtitle Review and confirm your subscription
            BillingDetails(
            :billingTypeSelected="billingTypeSelected"
            :billingTypeOptions="billingTypeOptions"
            :plan="selectedPlan"
            @updateBiliing="onBiliingChange"
            @updateAdditionalUsers="updateAdditionalUsers"
            @complitedPaymentMethod="complitedPaymentMethod"
            )
        PurchaseSummary(
        v-if="isSidebarOpen"
        :billingTypeSelected="billingTypeSelected"
        :billingTypeOptions="billingTypeOptions"
        :plan="selectedPlan"
        :additionalUsers="additionalUsers"
        @complitePurchaseConfirmed="selectPlanAndComplitePurchase",
        :disabled="disabled"
        )
</template>

<script>
  import VueGoogleAutocomplete from 'vue-google-autocomplete'
  import Multiselect from 'vue-multiselect'

  // const {DateTime} = require('luxon')
  // const {zones} = require('tzdata')
  // const luxonValidTimeZoneName = function (zoneName) {
  //   let hours = (DateTime.local().setZone(zoneName).offset / 60);
  //   let rhours = Math.floor(hours)
  //   let rhoursView = Math.floor(hours) < 10 && Math.floor(hours) >= 0 ? '0'+Math.round(hours) : '-0'+Math.abs(hours)
  //   let minutes = (hours - rhours) * 60;
  //   let rminutes = Math.round(minutes) === 0 ? '0'+Math.round(minutes) : Math.round(minutes)
  //   let zoneNameView = zoneName.split('/')[1] ? zoneName.split('/')[1].replace('_', ' ') : zoneName
  //
  //   return `(GMT ${rhoursView}:${rminutes}) ${zoneNameView}`
  // }
  // const luxonValidTimezones = Object.entries(zones)
  //   .filter(([zoneName, v]) => Array.isArray(v))
  //   .map(([zoneName, v]) => zoneName)
  //   .filter(tz => DateTime.local().setZone(tz).isValid)
  //   .map(zoneName => `${luxonValidTimeZoneName(zoneName)}`)

  // import Loading from '@/common/Loading/Loading'
  import TopNavbar from "@/auth/components/TopNavbar";
  import Steps from "@/auth/components/Steps";
  import Notifications from "@/common/Notifications/Notifications";
  import BillingDetails from './BillingDetails'
  import PurchaseSummary from './PurchaseSummary'
  import Overlay from '../Overlay'

  import data from './BillingPlansData.json'

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

  export default {
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states', 'userInfo', 'timezones'],
    components: {
      Notifications,
      Steps,
      // Loading,
      TopNavbar,
      Multiselect,
      BillingDetails,
      PurchaseSummary,
      Overlay,
      VueGoogleAutocomplete
    },
    created() {
      // if(luxonValidTimezones) this.timeZoneOptions = luxonValidTimezones;
      // if(luxonValidTimezones) {
      //   for (const value of luxonValidTimezones) {
      //     const [ gmt, zone ] = value.split(') ')
      //     this.timeZoneOptions.push({
      //       value: zone,
      //       name: value
      //     })
      //   }
      // }
      if(this.timezones) {
        for (const value of this.timezones) {
          const [ zone, city ] = value
          this.timeZoneOptions.push({
            value: city,
            name: zone
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

        this.formStep2.business.time_zone = {
          name: accountInfoParsed.time_zone,
          value: accountInfoParsed.time_zone
        }
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
        steps: [
          'CRD Number',
          'Company Information',
          'Choose plan'
        ],
        formStep1: {
          crd_number: '',
          crd_numberSelected: 'no',
          crd_numberOptions: [
            {text: 'No', value: 'no'},
            {text: 'Yes', value: 'yes'},
          ],
        },
        formStep2: initialAccountInfo(),
        industryOptions: [],
        subIndustryOptions: [],
        jurisdictionOptions: [],
        stateOptions: [],
        timeZoneOptions: [],

        notify: {
          show: 'show',
          mainText: 'Verify information',
          subText: 'The following fields were filled in based on the CRD number you provided. Please carefully review each field before proceeding.',
          variant: 'primary',
          dismissible: true,
          icon: null,
          scale: 2,
        },

        show: true,
        errors: {},
        step1: true,
        step2: false,
        step3: false,
        currentStep: 1,
        navStep1: true,
        navStep2: false,
        navStep3: false,
        billingTypeSelected: 'annually',
        billingTypeOptions: [
          { text: 'Billed Annually', value: 'annually' },
          { text: 'Billed Monthly', value: 'monthly' },
        ],
        billingPlans: data.billingPlans,
        openId: null,
        isSidebarOpen: false,
        selectedPlan: [],
        additionalUsers: 0,
        paymentSourceId: null,
        disabled: true,
        overlay: false,
        overlayStatus: '',
        overlayStatusText: '',
        currentPlan: { id: null, status: false }
      }
    },
    methods: {
      clickNotify(value) {
        console.log(value)
      },
      onSubmit(event){
        event.preventDefault()
      },
      checkCDRinfo(stepNum) {
        // CLEAR ERRORS
        this.errors = []

        if (!this.formStep1.crd_number.length) {
          this.errors = { crd_number: `Can't be empty!` }
          return
        }

        const dataToSend = {
          crd_number: this.formStep1.crd_number
        }

        this.$store.dispatch('getInfoByCRDNumber', dataToSend)
          .then(response => {
            if (!response.errors) {
              this.formStep1.crd_number = response.crd_number
              this.formStep2.business = { ...response }
              // this.toast('Success', `Successfully sended!`)
              this.navigation(stepNum)
            }
          })
          .catch(error => {
            console.error(error)
            // this.toast('Error', `Something wrong! ${error}`)
          })
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
                  // this.toast('Error', `Form has errors! Please recheck fields!`)
                }
              }
              if(!response.errors) {
                this['step'+(stepNum-1)] = false
                this['navStep'+stepNum] = true
                this['step'+stepNum] = true
                this.currentStep = stepNum
                this.navigation(this.currentStep)
                // this.toast('Success', `Company info successfully sended!`)
              }
            })
            .catch(error => {
              console.error(error)
              // this.toast('Error', `Something wrong! ${error}`)
            })
        }
      },
      openDetails(plan) {
        if(plan.id === 1) {
          this.overlay = true
          this.overlayStatusText = 'Setting up account...'

          const dataToSend = {
            userType: this.userType,
            planName: 'free',
            paymentSourceId : null,
          }

          this.$store.dispatch('updateSubscribe', dataToSend)
            .then(response => {
              // this.toast('Success', `Update subscribe successfully finished! You will be redirect.`)
              this.currentPlan = { id: 1, status: true }
              this.overlayStatus = 'success'
              this.redirect();
            })
            .catch(error => {
              console.error(error)
              this.toast('Error', `Something wrong! ${error}`)
              this.overlay = false
            })

          return
        }

        this.openId = plan.id
        // history.pushState({}, '', `${'new'}/${id}`)
        this.isSidebarOpen = true
        this.selectedPlan = plan;
      },
      closeSidebar() {
        this.openId = null
        // this.project = null
        // history.pushState({}, '', '')
        this.isSidebarOpen = false
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
      selectPlanAndComplitePurchase (selectedPlan) {
        // CLEAR ERRORS
        this.errors = []

        this.overlay = true
        this.overlayStatusText = 'Processing payment...'

        let planName;
        if (selectedPlan.id === 1) {
          planName = 'free';
        }
        if (selectedPlan.id === 2) {
          planName = this.billingTypeSelected === 'annually' ? 'team_tier_annual' : 'team_tier_monthly';
        }
        if (selectedPlan.id === 3) {
          planName = this.billingTypeSelected === 'annually' ? 'business_tier_annual' : 'business_tier_monthly'
        }

        const dataToSend = {
          userType: this.userType,
          planName,
          paymentSourceId : this.paymentSourceId,
        }

        this.$store
          .dispatch('updateSubscribe', dataToSend)
          .then(response => {
            if(response.errors) throw new Error(`Response error!`)
            if(!response.errors) {
              // this.toast('Success', `Update subscribe successfully finished!`)
              if(+this.additionalUsers > 0) this.paySeats(selectedPlan)
              // OVERLAY
              if(+this.additionalUsers === 0) {
                this.overlayStatusText = 'Payment complete! Setting up account...'
                this.overlayStatus = 'success'
                // this.overlay = false
                this.redirect()
              }
            }
          })
          .catch(error => {
            console.error(error)
            // this.toast('Error', `Something wrong! ${error}`)

            // OVERLAY
            this.overlayStatus = 'error'
            this.overlayStatusText = `Payment failed to process.`
            this.toast('Error', 'Payment failed to process.')
            setTimeout(() => {
              this.overlay = false
            }, 3000)
          })
          .finally(() => this.disabled = true)
      },
      paySeats(selectedPlan) {
        // const freeUsers = selectedPlan.usersCount;
        const neededUsers = +this.additionalUsers;
        // if (neededUsers <= freeUsers) {
        //   this.overlayStatusText = 'Account successfully purchased, you will be redirect to the dashboard...'
        //   this.overlayStatus = 'success'
        //   // this.overlay = false
        //   this.redirect()
        //   return
        // }
        // const countPayedUsers = neededUsers - freeUsers // OLD VERSION
        const countPayedUsers = neededUsers

        this.overlayStatusText = 'Subscribing additional seats...'

        let planName = this.billingTypeSelected === 'annually' ? 'seats_annual' : 'seats_monthly'

        const dataToSend = {
          userType: this.userType,
          planName,
          paymentSourceId : this.paymentSourceId,
          countPayedUsers,
        }

        this.$store
          .dispatch('updateSeatsSubscribe', dataToSend)
          .then(response => {

            if(response.errors) {
              for (const type of Object.keys(response[i].data.errors)) {
                // this.toast('Error', `Something wrong! ${response[i].data.errors[type]}`)
              }
            }

            if(!response.errors) {
              // this.toast('Success', `Update seat subscribe successfully finished!`)

              // OVERLAY
              this.overlayStatusText = `Account and ${countPayedUsers} seats successfully purchased, you will be redirect to the dashboard...`
              this.overlayStatus = 'success'
              // this.overlay = false
              this.redirect()
            }
          })
          .catch(error => {
            console.error(error)
            // this.toast('Error', `Something wrong! ${error}`)

            // OVERLAY
            this.overlayStatus = 'error'
            this.overlayStatusText = `Something wrong! ${error}`
            setTimeout(() => {
              this.overlay = false
            }, 3000)
          })
          .finally(() => this.disabled = true)
      },
      onChange (industries) {
        if(industries) {
          delete this.errors.industries
          this.subIndustryOptions = []
          const results = industries.map(industry => industry.id)

          if(this.subIndustryIds) {
            for (const [key, value] of Object.entries(this.subIndustryIds)) {
              for (const i of results) {
                if (i === +key.split('_')[0]) {
                  this.subIndustryOptions.push({
                    value: key,
                    name: value
                  })
                }
              }
            }
          }
        }
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
      redirect() {
        localStorage.setItem('app.currentUser.firstEnter', JSON.stringify(true))
        const dashboard = this.userType === 'business' ? '/business' : '/specialist'
        setTimeout(() => {
          window.location.href = `${dashboard}`;
        }, 3000)
      }
    },
    computed: {
      // loading() {
      //   return this.$store.getters.loading;
      // },
    }
  }
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style>
  /* MULTISELECT */
  .multiselect {
    min-height: calc(1.5em + 0.75rem + 2px);
  }
  .multiselect__placeholder {
    margin-bottom: 0;
    padding-top: 5px;
    padding-bottom: 2px;
    font-size: 0.875rem;
    font-weight: 400;
    line-height: 1;
  }
  .multiselect__tags {
    min-height: 2.2rem;
    padding: 5px 40px 0 5px;
    margin-bottom: 0;
    border-color: #ced4da;
    border-radius: 0.25rem;
  }
  .invalid .multiselect__tags {
    border-color: #CE1938;
  }
  .multiselect__tag {
    padding: 5px 26px 5px 5px;
    margin-bottom: 0;
    font-size: 0.75rem;
    color: #0479FF;
    background: #ECF4FF;
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
    line-height: 1.5rem;
  }
  .multiselect__tag-icon:hover {
    color: white;
    background: #0479ff;
  }
  .multiselect__select {
    height: 2.2rem;
  }
  .multiselect__single {
    margin-bottom: 0;
    font-size: 0.875rem;
    line-height: 1.4rem;
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
</style>

<style scoped>
  @import "../../../styles.css";
</style>
