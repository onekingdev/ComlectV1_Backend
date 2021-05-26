<template lang="pug">
  .container-fluid
    TopNavbar(:userInfo="userInfo")
    main.row#main-content
      .col-xl-10.col-md-9.m-x-auto
        Overlay(v-if="overlay", :status="overlayStatus", :statusText="overlayStatusText", :show="overlay")
        .card-body.white-card-body.registration-onboarding.p-5
          .div
            h2 Set Up Your Account
            hr
            .steps
              .step(:class="navStep1 ? 'active' : ''")
                h4.step__name 1. CRD Number
              .step(:class="navStep2 ? 'active' : ''")
                h4.step__name 2. Company Information
              .step(:class="navStep3 ? 'active' : ''")
                h4.step__name 3. Choose plan
          Loading
          b-form(@submit='onSubmit' @change="onChangeInput" v-if='show')
            #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
              h3 Do you have a CRD number?
                b-icon.h5.ml-2.mb-1(icon="exclamation-circle-fill" variant="secondary" v-b-tooltip.hover title="Automated update company info by CRD number")
              p The CRD number will be used to gather additional information about your business.
              div
                b-form-group(v-slot='{ ariaDescribedby }')
                  b-form-radio-group(v-model='formStep1.crd_numberSelected' :options='formStep1.crd_numberOptions' :aria-describedby='ariaDescribedby' name='radios-stacked' stacked)
                b-form-group(label='What is your CRD number?' v-if="formStep1.crd_numberSelected === 'yes'")
                  b-form-input.w-50(v-model="formStep1.crd_number" placeholder="Enter your CRD number")
                  .invalid-feedback.d-block(v-if="errors.crd_number") {{ errors.crd_number[0] }}
              .text-right
                b-button(type='button' variant='dark' @click="nextStep(2)") Next
            #step2.form(v-if='!loading'  :class="step2 ? 'd-block' : 'd-none'")
              b-alert(v-if="formStep1.crd_number && formStep1.crd_number.length" show variant="primary" dismissible)
                h4 Verify information
                p.mb-0 The following fields were filled in based on the CRD number you provided. Please carefully review each field before proceeding.
              h3 Tell us more about your business
              .row
                .col-xl-6.pr-xl-2
                  b-form-group#inputB-group-1(label='Company Name' label-for='inputB-1' label-class="required")
                    b-form-input#inputB-1(v-model='formStep2.business.business_name' type='text' placeholder='Company Name' required :class="{'is-invalid': errors.business_name }")
                    .invalid-feedback.d-block(v-if="errors.business_name") {{ errors.business_name[0] }}
              .row
                .col.pr-2
                  b-form-group#inputB-group-2(label='AUM' label-for='inputB-2')
                    b-form-input#inputB-2(v-model='formStep2.business.aum' type='text' placeholder='AUM' required :class="{'is-invalid': errors.aum }")
                    .invalid-feedback.d-block(v-if="errors.aum") {{ errors.aum[0] }}
                .col.pl-2
                  b-form-group#inputB-group-3(label='Number of Accounts' label-for='inputB-3')
                    b-form-input#inputB-3(v-model='formStep2.business.client_account_cnt' type='text' placeholder='Number of Accounts' required :class="{'is-invalid': errors.client_account_cnt }")
                    .invalid-feedback.d-block(v-if="errors.client_account_cnt") {{ errors.client_account_cnt[0] }}
              .row
                .col.pr-2
                  b-form-group#inputB-group-4(label='Industry' label-for='selectB-4' label-class="required")
                    div(
                    :class="{ 'invalid': errors.industries }"
                    )
                      multiselect#selectB-4(
                      v-model="formStep2.business.industries"
                      :options="industryOptions"
                      :multiple="true"
                      track-by="name",
                      label="name",
                      placeholder="Select Industry",
                      @input="onChange",
                      required)
                      .invalid-feedback.d-block(v-if="errors.industries") {{ errors.industries[0] }}
                      // label.typo__label.form__label(v-if="errors.industries") {{ errors.industries[0] }}
                .col.pl-2
                  b-form-group#inputB-group-5(label='Sub-Industry' label-for='selectB-5' label-class="required")
                    div(
                    :class="{ 'invalid': errors.subIndustry }"
                    )
                      multiselect#selectB-5(
                      v-model="formStep2.business.sub_industries"
                      :options="subIndustryOptions"
                      :multiple="true"
                      track-by="name",
                      label="name",
                      placeholder="Select Sub-Industry",
                      required)
                      .invalid-feedback.d-block(v-if="errors.subIndustry") {{ errors.subIndustry[0] }}
              .row
                .col.pr-2
                  b-form-group#inputB-group-6(label='Jurisdiction' label-for='selectB-6' label-class="required")
                    div(
                    :class="{ 'invalid': errors.jurisdiction }"
                    )
                      multiselect#selectB-6(
                      v-model="formStep2.business.jurisdictions"
                      :options="jurisdictionOptions"
                      :multiple="true"
                      track-by="name",
                      label="name",
                      placeholder="Select Jurisdiction",
                      required)
                      .invalid-feedback.d-block(v-if="errors.jurisdiction") {{ errors.jurisdiction[0] }}
                .col.pl-2
                  b-form-group#inputB-group-7(label='Time Zone' label-for='selectB-7' label-class="required")
                    div(
                    :class="{ 'invalid': errors.time_zone }"
                    )
                      multiselect#selectB-7(
                      v-model="formStep2.business.time_zone"
                      :options="timeZoneOptions"
                      :multiple="false"
                      :show-labels="false"
                      placeholder="Select Time Zone",
                      required)
                      .invalid-feedback.d-block(v-if="errors.time_zone") {{ errors.time_zone[0] }}
              .row
                .col.pr-2
                  b-form-group#inputB-group-8(label='Phone Number' label-for='inputB-8')
                    b-form-input#inputB-8(v-model='formStep2.business.contact_phone' type='text' placeholder='Phone Number' required :class="{'is-invalid': errors.contact_phone }")
                    .invalid-feedback.d-block(v-if="errors.contact_phone") {{ errors.contact_phone[0] }}
                .col.pl-2
                  b-form-group#inputB-group-7(label='Company Website' label-for='inputB-7' description="Optional")
                    b-form-input#inputB-7.form-control(v-model='formStep2.business.website' type='text' placeholder='Company Website' :class="{'is-invalid': errors.website }")
                    .invalid-feedback.d-block(v-if="errors.website") {{ errors.website[0] }}
              hr
              .row
                .col-xl-9.pr-xl-2
                  b-form-group#inputB-group-9(label='Business Address' label-for='inputB-9' label-class="required")
                    b-form-input#inputB-9(v-model='formStep2.business.address_1' placeholder='Business Address' required :class="{'is-invalid': errors.address_1 }"
                                          v-debounce:1000ms="onAdressChange")
                    .invalid-feedback.d-block(v-if="errors.address_1") {{ errors.address_1[0] }}
                .col-xl-3.pl-xl-2
                  b-form-group#inputB-group-10(label='Apt/Unit:' label-for='inputB-10')
                    b-form-input#inputB-10(v-model='formStep2.business.apartment' type='text' placeholder='Apt/Unit' required :class="{'is-invalid': errors.apartment }")
                    .invalid-feedback.d-block(v-if="errors.apartment") {{ errors.apartment[0] }}
              .row
                .col-xl-4.pr-xl-2
                  b-form-group#inputB-group-11(label='Zip' label-for='inputB-11' label-class="required")
                    b-form-input#inputB-11(v-model='formStep2.business.zipcode' placeholder='Zip' required :class="{'is-invalid': errors.zipcode }")
                    .invalid-feedback.d-block(v-if="errors.zipcode") {{ errors.zipcode[0] }}
                .col-xl-4.px-xl-2
                  b-form-group#inputB-group-12(label='City' label-for='inputB-12' label-class="required")
                    b-form-input#inputB-12(v-model='formStep2.business.city' type='text' placeholder='City' required :class="{'is-invalid': errors.city }")
                    .invalid-feedback.d-block(v-if="errors.city") {{ errors.city[0] }}
                .col-xl-4.pl-xl-2
                  b-form-group#inputB-group-13(label='State' label-for='selectB-13' label-class="required")
                    div(
                    :class="{ 'invalid': errors.state }"
                    )
                      multiselect#selectB-13(
                      v-model="formStep2.business.state"
                      :options="stateOptions"
                      placeholder="Select state",
                      @input="onChangeState",
                      required)
                      .invalid-feedback.d-block(v-if="errors.state") {{ errors.state[0] }}
              .text-right
                b-button.mr-2(type='button' variant='outline-primary' @click="prevStep(1)") Go back
                // b-button.mr-2(type='button' variant='outline-primary' @click="nextStep(3)") Skip this step
                b-button(type='button' variant='dark' @click="nextStep(3)") Next
            #step3.form(v-if='!loading'  :class="step3 ? 'd-block' : 'd-none'")
              .row
                .col.mb-2.text-center
                  h2.mb-3 Choose your plan
                  b-form-group.mb-5(v-slot="{ ariaDescribedby }")
                    b-form-radio-group(id="btn-radios-plan"
                    v-model="billingTypeSelected"
                    :options="billingTypeOptions"
                    :aria-describedby="ariaDescribedby"
                    button-variant="outline-primary"
                    size="lg"
                    name="radio-btn-outline"
                    buttons)
              .row
                .col-xl-4(v-for='(plan, index) in billingPlans')
                  b-card.w-100.mb-2.billing-plan(:class="[index === 0 ? 'billing-plan_low' : '', index === 1 ? 'billing-plan_medium' : '', index === 2 ? 'billing-plan_high' : '' ]")
                    b-button.mb-3(type='button' variant='outline-primary' @click="openDetails(plan)") Select Plan
                    b-card-text
                      h4.billing-plan__name {{ plan.name }}
                      p.billing-plan__descr {{ plan.description }}
                      h5.billing-plan__coast {{ billingTypeSelected === 'annually' ?  plan.coastAnnuallyFormatted : plan.coastMonthlyFormatted }}
                      p.billing-plan__users(v-if="plan.id === 1") 0 free users
                      p.billing-plan__users(v-if="plan.id !== 1") {{ billingTypeSelected === 'annually' ?  plan.usersCount + ' free users plus $' + plan.additionalUserAnnually + '/year per person' : plan.usersCount + ' free users plus $' + plan.additionalUserMonthly + '/mo per person' }}
                      hr
                      ul.list-unstyled.billing-plan__list
                        li.billing-plan__item(v-for="feature in plan.features")
                          b-icon.h4.mr-2.mb-0(icon="check-circle-fill" variant="success")
                          | {{ feature }}
              .row
                .col.text-right
                  b-button(type='button' variant='outline-primary' @click="prevStep(2)") Go back

        b-sidebar#BillingPlanSidebar(@hidden="closeSidebar" v-model="isSidebarOpen" backdrop-variant='dark' backdrop left no-header width="60%")
          .card
            .card-header.borderless
              .d-flex.justify-content-between
                b-button(variant="default" @click="isSidebarOpen = false")
                  b-icon.mr-2(icon="chevron-left" variant="dark")
                  | Back
              .d-block.m-t-1
                h2 Time to power up
                p Review and confirm your subscription
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
  const {DateTime} = require('luxon')
  const {zones} = require('tzdata')
  const luxonValidTimeZoneName = function (zoneName) {
    let hours = (DateTime.local().setZone(zoneName).offset / 60);
    let rhours = Math.floor(hours)
    let rhoursView = Math.floor(hours) < 10 && Math.floor(hours) >= 0 ? '0'+Math.round(hours) : '-0'+Math.abs(hours)
    let minutes = (hours - rhours) * 60;
    let rminutes = Math.round(minutes) === 0 ? '0'+Math.round(minutes) : Math.round(minutes)
    let zoneNameView = zoneName.split('/')[1] ? zoneName.split('/')[1].replace('_', ' ') : zoneName

    return `(GMT ${rhoursView}:${rminutes})  ${zoneNameView}`
  }
  const luxonValidTimezones = Object.entries(zones)
    .filter(([zoneName, v]) => Array.isArray(v))
    .map(([zoneName, v]) => zoneName)
    .filter(tz => DateTime.local().setZone(tz).isValid)
    .map(zoneName => `${luxonValidTimeZoneName(zoneName)}`)

  import Loading from '@/common/Loading/Loading'
  import TopNavbar from "@/auth/SignUp/TopNavbar";
  import Multiselect from 'vue-multiselect'
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
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states', 'userInfo'],
    components: {
      Loading,
      TopNavbar,
      Multiselect,
      BillingDetails,
      PurchaseSummary,
      Overlay
    },
    created() {
      if(luxonValidTimezones) this.timeZoneOptions = luxonValidTimezones;
      // if(luxonValidTimezones) {
      //   for (const [key, value] of Object.entries(luxonValidTimezones)) {
      //     this.timeZoneOptions.push({
      //       value: key,
      //       name: value
      //     })
      //   }
      // }
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
        this.formStep1.crd_number = accountInfo.crd_number
        this.formStep2.business = Object.assign({}, this.formStep2.business, { ...accountInfoParsed })
        this.onChange(accountInfoParsed.industries)
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
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
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
              this.makeToast('Success', `Successfully sended!`)
              this.navigation(stepNum)
            }
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Something wrong! ${error}`)
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
          if(this.formStep1.crd_number) dataToSend.business.crd_number = this.formStep1.crd_number

          dataToSend.business.industry_ids = this.formStep2.business.industries.map(record => record.id) || []
          dataToSend.business.sub_industry_ids = this.formStep2.business.sub_industries.map(record => record.value) || []
          dataToSend.business.jurisdiction_ids = this.formStep2.business.jurisdictions.map(record => record.id) || []

          this.$store.dispatch('updateAccountInfo', dataToSend)
            .then(response => {
              if(response.errors) {
                for (const type of Object.keys(response.errors)) {
                  this.errors = response.errors[type]
                  this.makeToast('Error', `Form has errors! Please recheck fields!`)
                }
              }
              if(!response.errors) {
                this['step'+(stepNum-1)] = false
                this['navStep'+stepNum] = true
                this['step'+stepNum] = true
                this.currentStep = stepNum
                this.navigation(this.currentStep)
                this.makeToast('Success', `Company info successfully sended!`)
              }
            })
            .catch(error => {
              console.error(error)
              this.makeToast('Error', `Something wrong! ${error}`)
            })
        }
      },
      openDetails(plan) {
        if(plan.id === 1) {
          const dataToSend = {
            userType: this.userType,
            planName: 'free',
            paymentSourceId : null,
          }

          this.$store.dispatch('updateSubscribe', dataToSend)
            .then(response => this.makeToast('Success', `Update subscribe successfully finished!`))
            .catch(error =>this.makeToast('Error', `Something wrong!`))

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
        this.overlayStatusText = 'Setting up account. Subscribing a plan...'

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
              this.makeToast('Success', `Update subscribe successfully finished!`)
              this.paySeats(selectedPlan)

              // OVERLAY
              if(+this.additionalUsers === 0) {
                this.overlayStatusText = 'Account successfully purchased, you will be redirect to the dashboard...'
                this.overlayStatus = 'success'
                // this.overlay = false
                const dashboard = this.userType === 'business' ? '/business' : '/specialist'
                setTimeout(() => {
                  window.location.href = `${dashboard}`;
                }, 3000)
              }
            }
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Something wrong! ${error}`)

            // OVERLAY
            this.overlayStatus = 'error'
            this.overlayStatusText = `Something wrong! ${error}`
            setTimeout(() => {
              this.overlay = false
            }, 3000)
          })
          .finally(() => this.disabled = true)
      },
      paySeats(selectedPlan) {
        const freeUsers = selectedPlan.usersCount;
        const neededUsers = +this.additionalUsers;
        if (neededUsers <= freeUsers) return
        const countPayedUsers = neededUsers - freeUsers

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
                this.makeToast('Error', `Something wrong! ${response[i].data.errors[type]}`)
              }
            }

            if(!response.errors) {
              this.makeToast('Success', `Update seat subscribe successfully finished!`)

              // OVERLAY
              this.overlayStatusText = `Account and ${countPayedUsers} seats successfully purchased, you will be redirect to the dashboard...`
              this.overlayStatus = 'success'
              // this.overlay = false
              const dashboard = this.userType === 'business' ? '/business' : '/specialist'
              setTimeout(() => {
                window.location.href = `${dashboard}`;
              }, 3000)
            }
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Something wrong! ${error}`)

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
        // console.log('address', address)

        // this.$store.dispatch('getGeo', address)
        //   .then(response => console.log('response', response))
        //   .catch(error => console.error(error))
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
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

<style scoped>
  @import "../../../styles.css";
</style>
