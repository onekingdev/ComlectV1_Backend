<template lang="pug">
  .container-fluid
    TopNavbar
    main.row#main-content
      .col-xl-10.col-md-9.m-x-auto
        .card-body.white-card-body.registration.p-5
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
          b-form(@submit='onSubmit' v-if='show')
            #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
              h3 Do you have a CRD number?
                b-icon.h5.ml-2.mb-1(icon="exclamation-circle-fill" variant="secondary")
              p The CRD number will be used to gather additional information about your business.
              div
                b-form-group(v-slot='{ ariaDescribedby }')
                  b-form-radio-group(v-model='formStep1.CRDnumberSelected' :options='formStep1.CRDnumberOptions' :aria-describedby='ariaDescribedby' name='radios-stacked' stacked)
                b-form-group(label='What is your CRD number?' v-if="formStep1.CRDnumberSelected === 'yes'")
                  b-form-input.w-50(v-model="formStep1.CRDnumber" placeholder="Enter your CRD number")
              .text-right
                b-button(type='button' variant='dark' @click="nextStep(2)") Next
            #step2.form(v-if='!loading'  :class="step2 ? 'd-block' : 'd-none'")
              b-alert(show variant="primary" dismissible)
                h4 Verify information
                p.mb-0 The following fields were filled in based on the CRD number you provided. Please carefully review each field before proceeding.
              h3 Tell us more about your business
              .row
                .col-xl-6.pr-xl-2
                  b-form-group#input-group-1(label='Company Name' label-for='input-1')
                    b-form-input#input-1(v-model='formStep2.companyName' type='text' placeholder='Company Name' required)
                    .invalid-feedback.d-block(v-if="errors.companyName") {{ errors.companyName }}
              .row
                .col.pr-2
                  b-form-group#input-group-2(label='AUM' label-for='input-2')
                    b-form-input#input-2(v-model='formStep2.aum' type='text' placeholder='AUM' required)
                    .invalid-feedback.d-block(v-if="errors.aum") {{ errors.aum }}
                .col.pl-2
                  b-form-group#input-group-3(label='Number of Accounts' label-for='input-3')
                    b-form-input#input-3(v-model='formStep2.numAcc' type='text' placeholder='Number of Accounts' required)
                    .invalid-feedback.d-block(v-if="errors.numAcc") {{ errors.numAcc }}
              .row
                .col.pr-2
                  b-form-group#input-group-4(label='Industry' label-for='select-4')
                    multiselect#select-4(
                    v-model="formStep2.industry"
                    :options="formStep2.industryOptions"
                    :multiple="true"
                    track-by="name",
                    label="name",
                    placeholder="Select Industry",
                    required)
                    <!--b-form-select#select-4(v-model='formStep2.industry' :options='options' required)-->
                    .invalid-feedback.d-block(v-if="errors.industry") {{ errors.industry }}
                .col.pl-2
                  b-form-group#input-group-5(label='Sub-Industry' label-for='select-5')
                    <!--b-form-select#select-5(v-model='formStep2.subIndustry' :options='options' required)-->
                    multiselect#select-5(
                    v-model="formStep2.subIndustry"
                    :options="formStep2.subIndustryOptions"
                    :multiple="true"
                    track-by="name",
                    label="name",
                    placeholder="Select Sub-Industry",
                    required)
                    .invalid-feedback.d-block(v-if="errors.subIndustry") {{ errors.subIndustry }}
              .row
                .col.pr-2
                  b-form-group#input-group-6(label='Jurisdiction' label-for='select-6')
                    <!--b-form-select#select-6(v-model='formStep2.jurisdiction' :options='options' required)-->
                    multiselect#select-6(
                    v-model="formStep2.jurisdiction"
                    :options="formStep2.jurisdictionOptions"
                    :multiple="true"
                    track-by="name",
                    label="name",
                    placeholder="Select Sub-Industry",
                    required)
                    .invalid-feedback.d-block(v-if="errors.jurisdiction") {{ errors.jurisdiction }}
                .col.pl-2
                  b-form-group#input-group-7(label='Company Website' label-for='input-7' description="Optional")
                    b-form-input#input-7.form-control(v-model='formStep2.website' type='text' placeholder='Company Website')
                    .invalid-feedback.d-block(v-if="errors.website") {{ errors.website }}
              .row
                .col-xl-6.pr-xl-2
                  b-form-group#input-group-8(label='Phone Number' label-for='input-8')
                    b-form-input#input-8(v-model='formStep2.phoneNumber' type='text' placeholder='Phone Number' required)
                    .invalid-feedback.d-block(v-if="errors.phoneNumber") {{ errors.phoneNumber }}
              hr
              .row
                .col-xl-9.pr-xl-2
                  b-form-group#input-group-9(label='Business Address' label-for='input-9')
                    b-form-input#input-9(v-model='formStep2.businessAddress' placeholder='Business Address' required)
                    .invalid-feedback.d-block(v-if="errors.businessAddress") {{ errors.businessAddress }}
                .col-xl-3.pl-xl-2
                  b-form-group#input-group-10(label='Apt/Unit:' label-for='input-10')
                    b-form-input#input-10(v-model='formStep2.aptUnit' type='text' placeholder='Apt/Unit' required)
                    .invalid-feedback.d-block(v-if="errors.aptUnit") {{ errors.aptUnit }}
              .row
                .col-xl-4.pr-xl-2
                  b-form-group#input-group-11(label='Zip' label-for='input-11')
                    b-form-input#input-11(v-model='formStep2.zip' placeholder='Zip' required)
                    .invalid-feedback.d-block(v-if="errors.zip") {{ errors.zip }}
                .col-xl-4.px-xl-2
                  b-form-group#input-group-12(label='City' label-for='input-12')
                    b-form-input#input-12(v-model='formStep2.city' type='text' placeholder='City' required)
                    .invalid-feedback.d-block(v-if="errors.city") {{ errors.city }}
                .col-xl-4.pl-xl-2
                  b-form-group#input-group-13(label='State' label-for='select-13')
                    <!--b-form-select#select-13(v-model='formStep2.state' :options='options' required)-->
                    multiselect#select-13(
                    v-model="formStep2.state"
                    :options="formStep2.stateOptions"
                    placeholder="Select state",
                    required)
                    .invalid-feedback.d-block(v-if="errors.state") {{ errors.state }}
              .text-right
                b-button.mr-2(type='button' variant='outline-primary' @click="prevStep(1)") Go back
                <!--b-button.mr-2(type='button' variant='outline-primary' @click="nextStep(3)") Skip this step-->
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
                .col-xl-4(v-for='(plan, index) in billingPlan')
                  b-card.w-100.mb-2.billing-plan(:class="[index === 0 ? 'billing-plan_low' : '', index === 1 ? 'billing-plan_medium' : '', index === 2 ? 'billing-plan_high' : '' ]")
                    b-button.mb-3(type='button' variant='outline-primary' @click="openDetails(plan)") Select Plan
                    b-card-text
                      h4.billing-plan__name {{ plan.name }}
                      p.billing-plan__descr {{ plan.description }}
                      h5.billing-plan__coast {{ billingTypeSelected === 'annually' ?  plan.coastAnnuallyFormatted : plan.coastMonthlyFormatted }}
                      p.billing-plan__users {{ plan.users }}
                      hr
                      ul.list-unstyled.billing-plan__list
                        li.billing-plan__item(v-for="feature in plan.features")
                          b-icon.h4.mr-2.mb-0(icon="check-circle-fill" variant="success")
                          | {{ feature }}
              .row
                .col.text-right
                  b-button.mr-2(type='button' variant='outline-primary' @click="prevStep(2)") Go back

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
            )
        PurchaseSummary(
        v-if="isSidebarOpen"
        :billingTypeSelected="billingTypeSelected"
        :billingTypeOptions="billingTypeOptions"
        :plan="selectedPlan"
        :additionalUsers="additionalUsers"
        @complitePurchaseConfirmed="selectPlanAndComplitePurchase"
        )
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import TopNavbar from "@/auth/SignUp/TopNavbar";
  import Multiselect from 'vue-multiselect'
  import BillingDetails from './BillingDetails'
  import PurchaseSummary from './PurchaseSummary'

  export default {
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states'],
    components: {
      Loading,
      TopNavbar,
      Multiselect,
      BillingDetails,
      PurchaseSummary
    },
    created() {
      // console.log('industryIds', this.industryIds)
      // console.log('subIndustryIds', this.subIndustryIds)
      // console.log('jurisdictionIds', this.jurisdictionIds)
      // console.log('states', this.states)
      if(this.industryIds) this.formStep2.industryOptions = this.industryIds;
      // if(this.subIndustryIds) this.formStep2.subIndustryOptions = this.subIndustryIds;
      for (const [key, value] of Object.entries(this.subIndustryIds)) {
        // console.log(`${key}: ${value}`);
        this.formStep2.subIndustryOptions.push({
          value: key,
          name: value
        })
      }
      if(this.jurisdictionIds) this.formStep2.jurisdictionOptions = this.jurisdictionIds;
      if(this.states) this.formStep2.stateOptions = this.states;
    },
    data() {
      return {
        userId: '',
        otpSecret: '',
        userType: '',
        formStep1: {
          CRDnumber: '',
          CRDnumberSelected: 'no',
          CRDnumberOptions: [
            {text: 'No', value: 'no'},
            {text: 'Yes', value: 'yes'},
          ],
        },
        formStep2: {
          companyName: '',
          aum: '',
          numAcc: '',
          industry: '',
          industryOptions: [],
          subIndustry: '',
          subIndustryOptions: [],
          jurisdiction: '',
          jurisdictionOptions: [],
          website: '',
          phoneNumber: '',
          businessAddress: '',
          aptUnit: '',
          zip: '',
          city: '',
          state: '',
          stateOptions: [],
        },
        // options: [
        //   { value: null, text: 'Please select an option' },
        //   { text: 'Value 1', value: 'val1' },
        //   { text: 'Value 2', value: 'val2' },
        // ],
        value: null,
        options: ['list', 'of', 'options'],
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
        billingPlan: [
          {
            id: 1,
            api_id: 'price_1IiE98GXaxE41NmqMgX2ln1u',
            name: 'Starter',
            description: 'Try out our product for free!',
            coast: 'FREE',
            coastMonthly: 'FREE',
            coastMonthlyFormatted: `FREE`,
            coastAnnually: 'FREE',
            coastAnnuallyFormatted: `FREE`,
            users: '1 admin user',
            usersCount: 0,
            additionalUserMonthly: 0,
            additionalUserAnnually: 0,
            features: [
              'Compilance Calendar',
              'Project Management',
            ]
          },
          {
            id: 2,
            api_id: 'price_1IiYD7GXaxE41Nmqu9aE7eRC',
            name: 'Team',
            description: 'Small teams and startups',
            coast: '$125/mo',
            coastMonthly: 145,
            coastMonthlyFormatted: `$145/mo`,
            coastAnnually: 1500,
            coastAnnuallyFormatted: `$1500`,
            users: '3 free users plus $15/mo per person',
            usersCount: 3,
            additionalUserMonthly: 15,
            additionalUserAnnually: 120,
            features: [
              'Compilance Calendar',
              'Project Management',
              'Policies and Procedures',
              '1 Internal Review per year',
              'Exam Management',
              '5GB storage for books and records',
              'Unlimited intefrations',
            ]
          },
          {
            id: 3,
            api_id: 'price_1IiYDOGXaxE41Nmq4Uc27JUf',
            name: 'Business',
            description: 'Medium-sized organizations',
            coast: '$250/mo',
            coastMonthly: 270,
            coastMonthlyFormatted: `$270/mo`,
            coastAnnually: 3000,
            coastAnnuallyFormatted: `$3000`,
            users: '10 free users plus $15/mo per person',
            usersCount: 10,
            additionalUserMonthly: 15,
            additionalUserAnnually: 120,
            features: [
              'Compilance Calendar',
              'Project Management',
              'Policies and Procedures',
              '1 Internal Review per year',
              'Exam Management',
              'Auditor Portal',
              '10GB storage for books and records',
              'Unlimited intefrations',
              'Free Personalized Onboarding'
            ]
          },
        ],
        openId: null,
        isSidebarOpen: false,
        selectedPlan: [],
        additionalUsers: 0,
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      onSubmit(event){
        event.preventDefault()
        console.log(this.form)
      },
      checkCDRinfo() {
        // CLEAR ERRORS
        this.errors = []

        const dataToSend = {
          crd: this.formStep1.CRDnumber
        }

        this.$store
          .dispatch('getInfoByCRDNumber', dataToSend)
          .then(response => {
            console.log('response', response)
            this.makeToast('Success', `CRD Number successfully sended!`)
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Something wrong! ${error}`)
          })

        console.log(dataToSend)
      },
      prevStep(stepNum) {
        this['step'+(stepNum+1)] = false
        this['navStep'+(stepNum+1)] = false
        this['step'+stepNum] = true
        this.currentStep = stepNum
      },
      nextStep(stepNum) {
        if (this.formStep1.CRDnumberSelected === 'yes') {
          this.checkCDRinfo()
          return
        }
        if (stepNum === 2 && this.formStep1.CRDnumberSelected === 'no') {
          this['step'+(stepNum-1)] = false
          this['navStep'+stepNum] = true
          this['step'+stepNum] = true
          this.currentStep = stepNum
        }

        if (stepNum === 3) {
          // CLEAR ERRORS
          this.errors = []

          const dataToSend = {
            // contact_first_name: 'x',
            // contact_last_name: 'x',
            // contact_email: 'x',
            // contact_job_title: 'x',
            // contact_phone: 'x',
            business_name: this.formStep2.companyName,
            website: this.formStep2.website,
            aum: this.formStep2.aum,
            apartment: this.formStep2.aptUnit,
            client_account_cnt: this.formStep2.numAcc,
            // logo: 'x',
            address_1: this.formStep2.businessAddress,
            // country: 'x',
            city: this.formStep2.city,
            state: this.formStep2.state,
            zipcode: this.formStep2.zip,
            crd_number: this.formStep1.CRDnumber,
            industry_ids: this.formStep2.industry.map(record => record.id),
            sub_industry_ids: this.formStep2.subIndustry.map(record => record.id),
            jurisdiction_ids: this.formStep2.jurisdiction.map(record => record.id),
          }

          this.$store
            .dispatch('updateBusinnesInfo', dataToSend)
            .then(response => {
              console.log('response', response)

              if(response.errors) {
                this.makeToast('Error', `Something wrong!`)

                for (const type of Object.keys(response.errors)) {
                  this.errors = response.errors[type]
                  this.makeToast('Error', `Form has errors! Please recheck fields! ${response.errors[type]}`)
                }

                return
              }

              if(!response.errors) {
                this['step'+(stepNum-1)] = false
                this['navStep'+stepNum] = true
                this['step'+stepNum] = true
                this.currentStep = stepNum
                this.makeToast('Success', `Company info successfully sended!`)
              }
            })
            .catch(error => {
              console.error(error)
              this.makeToast('Error', `Something wrong! ${error}`)

              return
            })
        }
      },
      openDetails(id) {
        this.openId = id
        // history.pushState({}, '', `${'new'}/${id}`)
        this.isSidebarOpen = true
        this.selectedPlan = id;
      },
      closeSidebar() {
        this.openId = null
        this.project = null
        // history.pushState({}, '', '')
        this.isSidebarOpen = false
      },
      onBiliingChange(event) {
        this.billingTypeSelected = event
      },
      updateAdditionalUsers(event){
        // console.log('users', event)
        this.additionalUsers = event
      },
      selectPlanAndComplitePurchase (selectedPlan) {
        console.log(selectedPlan)
        // CLEAR ERRORS
        this.errors = []

        const dataToSend = {
          "plan": this.billingTypeSelected === 'annually' ? 'team_tier_annual' : 'team_tier_monthly'
        }

        this.$store
          .dispatch('updateSubscribe', dataToSend)
          .then(response => {
            console.log('response', response)

            if(response.errors) {
              this.makeToast('Error', `Something wrong!`)
            }

            if(!response.errors) {
              this.makeToast('Success', `Update subscribe successfully finished!`)
            }
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Something wrong! ${error}`)
          })
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
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
  @import "../../styles.css";
</style>
