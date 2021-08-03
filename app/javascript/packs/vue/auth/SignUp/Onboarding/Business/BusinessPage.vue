<template lang="pug">
  div.registration-onboarding(:class="{ full: isSidebarOpen }")
    Overlay(v-if="overlay.active")
    .col.m-x-auto(v-if="!isSidebarOpen")
      .card
        .card-header
          h2.registration-onboarding__title Set Up Your Account
        .card-body.white-card-body.borderless.onboarding
          Steps(:steps="steps", :currentStep="currentStep")
          //Loading
          b-form(@submit='onSubmit' @change="onChangeInput" v-if='show')
            #step1.form(:class="currentStep === 1 ? 'd-block' : 'd-none'")
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
            #step2.form(:class="currentStep === 2 ? 'd-block' : 'd-none'")
              Notifications.m-b-20(v-if="formStep1.crd_number && formStep1.crd_number.length" :notify="notify")
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
                      :options="staticCollection.industries"
                      :multiple="true"
                      :show-labels="false"
                      track-by="name",
                      label="name",
                      placeholder="Select Industry",
                      @input="onChangeIndustries",
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
                      :options="staticCollection.jurisdictions"
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
                      :options="staticCollection.timezones"
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
                      :options="staticCollection.states"
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
            #step3.form(:class="currentStep === 3 ? 'd-block' : 'd-none'")
              SelectPlan(:userType="userType" @goBack="prevStep(2)" @openDetails="openDetails")
    SelectPlanPaymentAndSummary(:userType="userType" :isSidebarOpen="isSidebarOpen" :selectedPlan="selectedPlan" @sidebarToggle="isSidebarOpen = $event")

</template>

<script>
  import VueGoogleAutocomplete from 'vue-google-autocomplete'
  import Multiselect from 'vue-multiselect'
  // import Loading from '@/common/Loading/Loading'
  import TopNavbar from "@/auth/components/TopNavbar";
  import Steps from "@/auth/components/Steps";
  import Notifications from "@/common/Notifications/Notifications";

  import SelectPlan from '@/auth/components/SelectPlan/Business'
  import SelectPlanPaymentAndSummary from '@/auth/components/SelectPlan/Business/components/SelectPlanDetails'
  import Overlay from '../Overlay'

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
    // props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states', 'userInfo', 'timezones'],
    props: ['userInfo'],
    components: {
      Steps,
      Notifications,
      // Loading,
      TopNavbar,
      Multiselect,
      Overlay,
      VueGoogleAutocomplete,
      SelectPlan,
      SelectPlanPaymentAndSummary,
    },
    created() {
      console.log('userInfo', this.userInfo)
      // if(this.timezones) {
      //   for (const value of this.timezones) {
      //     const [ zone, city ] = value
      //     this.timeZoneOptions.push({
      //       value: city,
      //       name: zone
      //     })
      //   }
      // }
      // if(this.industryIds) this.industryOptions = this.industryIds;
      // if(this.jurisdictionIds) this.jurisdictionOptions = this.jurisdictionIds;
      // if(this.states) this.stateOptions = this.states;

      const accountInfo = localStorage.getItem('app.currentUser');
      const accountInfoParsed = JSON.parse(accountInfo);
      if(accountInfo) {
        if(accountInfo.crd_number) this.formStep1.crd_number = accountInfo.crd_number
        this.formStep2.business = Object.assign({}, this.formStep2.business, { ...accountInfoParsed })
        this.onChangeIndustries(accountInfoParsed.industries)

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
      const currentStep = +url.searchParams.get('step')
      this.currentStep = currentStep ? currentStep : 1;
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
        // industryOptions: [],
        subIndustryOptions: [],
        // jurisdictionOptions: [],
        // stateOptions: [],
        // timeZoneOptions: [],

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
        currentStep: 1,

        openId: null,
        isSidebarOpen: false,
        selectedPlan: null,

        currentPlan: { id: null, status: false }
      }
    },
    methods: {
      onSubmit(event){
        event.preventDefault()
      },
      checkCDRinfo(stepNum) {
        // CLEAR ERRORS
        for (var value in this.errors) delete this.errors[value];

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

              this.navigation(stepNum)
            }
          })
          .catch(error => console.error('getInfoByCRDNumber', error))
      },
      navigation(stepNum){
        const url = new URL(window.location);
        url.searchParams.set('step', stepNum);
        window.history.pushState({}, '', url);

        this.currentStep = stepNum
      },
      prevStep(stepNum) {
        this.currentStep = stepNum
      },
      nextStep(stepNum) {
        // CLEAR ERRORS
        for (var value in this.errors) delete this.errors[value];

        if (stepNum === 2) {
          if (this.formStep1.crd_numberSelected === 'yes') {
            this.checkCDRinfo(stepNum)
            return
          }
          if (this.formStep1.crd_numberSelected === 'no') this.formStep1.crd_number = ''

          this.navigation(stepNum)
        }

        if (stepNum === 3) {

          delete this.formStep2.errors
          const dataToSend = this.formStep2
          if(!this.formStep1.crd_number.length) delete dataToSend.business.crd_number

          dataToSend.business.industry_ids = this.formStep2.business.industries ? this.formStep2.business.industries.map(record => record.id) : []
          dataToSend.business.sub_industry_ids = this.formStep2.business.sub_industries ? this.formStep2.business.sub_industries.map(record => record.value) : []
          dataToSend.business.jurisdiction_ids = this.formStep2.business.jurisdictions ? this.formStep2.business.jurisdictions.map(record => record.id) : []
          dataToSend.business.time_zone = this.formStep2.business.time_zone ? this.formStep2.business.time_zone.value : ''

          this.$store.dispatch('updateAccountInfo', dataToSend)
            .then(response => {
              if(response.errors) {
                for (const type of Object.keys(response.errors)) {
                  this.errors = response.errors[type]
                }
              }
              if(!response.errors) {
                this.navigation(stepNum)
              }
            })
            .catch(error => console.error(error) )
        }
      },
      openDetails(plan) {
        if(plan.id === 1) {

          // OVERLAY
          this.$store.dispatch('setOverlay', {
            active: true,
            message: 'Setting up account...',
            status: ''
          })

          const dataToSend = {
            userType: this.userType,
            planName: 'free',
            paymentSourceId : null,
          }

          this.$store.dispatch('updateSubscribe', dataToSend)
            .then(response => {
              this.currentPlan = { id: 1, status: true }

              // OVERLAY
              this.$store.dispatch('setOverlay', {
                active: true,
                message: 'Setting up account...',
                status: 'success'
              })

              setTimeout(() => this.redirect() , 2000)
            })
            .catch(error => {
              console.error(error)

              // OVERLAY
              this.$store.dispatch('setOverlay', {
                active: true,
                message: `Something wrong! ${error}`,
                status: 'error'
              })
              setTimeout(() => this.$store.dispatch('setOverlay', {
                active: false,
                message: '',
                status: ''
              }), 2000)
            })

          return
        }

        this.isSidebarOpen = true
        this.selectedPlan = plan;
      },
      closeSidebar() {
        this.isSidebarOpen = false
      },
      onChangeIndustries (industries) {
        if(industries) {
          delete this.errors.industries
          this.subIndustryOptions = []
          const results = industries.map(industry => industry.id)

          if(this.staticCollection.sub_industries_business) {
            for (const [key, value] of Object.entries(this.staticCollection.sub_industries_business)) {
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
        const input = document.getElementById(id)
        const { administrative_area_level_1, locality, postal_code } = addressData

        this.formStep2.business.address_1 = input.value
        this.formStep2.business.city = locality
        this.formStep2.business.state = administrative_area_level_1
        this.formStep2.business.zipcode = postal_code
      },
      redirect() {
        localStorage.setItem('app.currentUser.firstEnter', JSON.stringify(true))
        window.location.href = `${this.userType}`;
      }
    },
    computed: {
      // loading() {
      //   return this.$store.getters.loading;
      // },
      staticCollection() {
        return this.$store.getters.staticCollection;
      },
      currentUser() {
        return this.$store.getters.getUser
      },
      overlay() {
        return this.$store.getters.overlay;
      }
    },
    mounted () {
      const accountInfo = localStorage.getItem('app.currentUser');
      const accountInfoParsed = JSON.parse(accountInfo);

      this.$store.dispatch('getStaticCollection')
        .then(response => this.onChangeIndustries(accountInfoParsed.industries))
        .catch(error => console.error(error))
    }
  }
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style scoped>
  @import "../../../styles.css";
</style>
