<template lang="pug">
  .container-fluid
    TopNavbar(:userInfo="userInfo")
    main.row#main-content
      .col-xl-10.col-md-9.m-x-auto
        .card-body.white-card-body.registration-onboarding.p-lg-5
          .div
            h2 Set Up Your Account
            hr
            .steps
              .step(:class="navStep1 ? 'active' : ''")
                h4.step__name 1. Background
              .step(:class="navStep2 ? 'active' : ''")
                h4.step__name 2. Skills and education
              .step(:class="navStep3 ? 'active' : ''")
                h4.step__name 3. Choose plan
          Loading
          b-form(@submit='onSubmit' v-if='show')
            #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
              h3 What jurisdiction does your expertise extend to?
              p Providing your jurisdiction(s) will help find clients within your domain of expertise. Select all that apply.
              .row
                .col-xl-6
                  b-form-group#inputS-group-1(label='Jurisdiction' label-for='selectS-1')
                    <!--b-form-select#selectS-6(v-model='formStep2.jurisdiction' :options='options' required)-->
                    multiselect#selectS-1(
                    v-model="formStep1.jurisdiction"
                    :options="formStep1.jurisdictionOptions"
                    :multiple="true"
                    track-by="name",
                    label="name",
                    placeholder="Select jurisdiction",
                    required)
                    .invalid-feedback.d-block(v-if="errors.jurisdiction") {{ errors.jurisdiction }}
              h3 What industries do you serve?
              p Select all that apply:
              .row
                .col-xl-6
                  b-form-group#inputS-group-4(label='Industry' label-for='selectS-4')
                    multiselect#selectS-4(
                    v-model="formStep1.industry"
                    :options="formStep1.industryOptions"
                    :multiple="true"
                    track-by="name",
                    label="name",
                    placeholder="Select Industry",
                    required)
                    <!--b-form-select#selectS-4(v-model='formStep2.industry' :options='options' required)-->
                    .invalid-feedback.d-block(v-if="errors.industry") {{ errors.industry }}
              .row
                .col-xl-6
                  b-form-group#inputS-group-5(label='Sub-Industry' label-for='selectS-5')
                    <!--b-form-select#selectS-5(v-model='formStep2.subIndustry' :options='options' required)-->
                    multiselect#selectS-5(
                    v-model="formStep1.subIndustry"
                    :options="formStep1.subIndustryOptions"
                    :multiple="true"
                    track-by="name",
                    label="name",
                    placeholder="Select Sub-Industry",
                    required)
                    .invalid-feedback.d-block(v-if="errors.subIndustry") {{ errors.subIndustry }}
              h3 Are you a former regulator?
                b-icon.h5.ml-2.mb-1(icon="exclamation-circle-fill" variant="secondary")
              p Select all that apply:
              div
                b-form-group(v-slot='{ ariaDescribedby }')
                  b-form-radio-group(v-model='formStep1.regulatorSelected' :options='formStep1.regulatorOptions' :aria-describedby='ariaDescribedby' name='radios-stacked' stacked)
                b-form-group(label='Where did you work?' v-if="formStep1.regulatorSelected === 'yes'" label-for='selectS-6')
                  multiselect#selectS-6(
                  v-model="formStep1.regulator"
                  :options="formStep1.regulatorOptionsTags"
                  :multiple="true"
                  track-by="name",
                  label="name",
                  tag-placeholder="Add this as new tag",
                  placeholder="Search or add a tag",
                  :taggable="true",
                  @tag="addTag"
                  required)
                  .invalid-feedback.d-block(v-if="errors.regulator") {{ errors.regulator }}
              .text-right
                b-button(type='button' variant='dark' @click="nextStep(2)") Next
            #step2.form(v-if='!loading'  :class="step2 ? 'd-block' : 'd-none'")
              b-alert.d-none(show variant="primary" dismissible)
                h4 Verify information
                p.mb-0 The following fields were filled in based on the CRD number you provided. Please carefully review each field before proceeding.
              h3 Tell us more about yourself:
              p Enter any relevant skills and education to better match with ideal clients.
              b-form-group(label='Skills' label-for='selectS-7')
                multiselect#selectS-7(
                v-model="formStep2.skills"
                :options="formStep2.skillsTags"
                :multiple="true"
                track-by="name",
                label="name",
                tag-placeholder="Add this as new tag",
                placeholder="Search or add a tag",
                :taggable="true",
                @tag="addSkillsTag"
                required)
                .invalid-feedback.d-block(v-if="errors.skills") {{ errors.skills }}
              hr
              h3 What's your expirience?
              p Select one that the best matches your level of your expertise.
              b-form-group
                b-button-group.flex-wrap(size='lg')
                  b-button.text-left(type='button' variant='outline-primary' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onExpirienceChange('junior')")
                    b Junior
                    br
                    | Begining consulting with some experience in the field.
                  b-button.text-left(type='button' variant='outline-primary' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onExpirienceChange('intermediate')")
                    b Intermediate
                    br
                    | Good expirience and knowlage of the industry.
                  b-button.text-left(type='button' variant='outline-primary' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onExpirienceChange('expert')")
                    b Expert
                    br
                    | Deep understanding of industry with varied experience.
              hr
              h3.mb-3 (Optional) Upload you resume:
              b-form-group.mt-3
                b-form-file(v-model='formStep2.file1' :state='Boolean(formStep2.file1)' accept="application/pdf" placeholder='Choose a file or drop it here...' drop-placeholder='Drop file here...')
                .mt-3 Selected file: {{ formStep2.file1 ? formStep2.file1.name : '' }}
              .text-right
                b-button.mr-2(type='button' variant='outline-primary' @click="prevStep(1)") Go back
                b-button(type='button' variant='dark' @click="nextStep(3)") Next
            #step3.form(v-if='!loading'  :class="step3 ? 'd-block' : 'd-none'")
              .row
                .col.mb-2.text-center
                  h2.mb-3 Choose your Membership plan
                  p Want to skip selecting a plan?
                  b-form-group.mb-5
                    b-button(type='button' variant='outline-primary') Continue With Free Plan
              .row.justify-content-center
                .col-xl-3(v-for='(plan, index) in billingPlans')
                  b-card.w-100.mb-2.billing-plan(:class="[index === 0 ? 'billing-plan_low' : '', index === 1 ? 'billing-plan_medium' : '', index === 2 ? 'billing-plan_high' : '' ]")
                    b-button.mb-3(type='button' variant='outline-primary' @click="openDetails(plan)") Select Plan
                    b-card-text
                      h4.billing-plan__name {{ plan.name }}
                      p.billing-plan__descr {{ plan.description }}
                      h5.billing-plan__coast {{ billingTypeSelected === 'annually' ?  plan.coastAnnuallyFormatted : plan.coastMonthlyFormatted }}
                      p.billing-plan__users {{ billingTypeSelected === 'annually' ?  plan.usersCount + ' free users plus $' + plan.additionalUserAnnually + '/year per person' : plan.usersCount + ' free users plus $' + plan.additionalUserMonthly + '/mo per person' }}
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
  import Loading from '@/common/Loading/Loading'
  import TopNavbar from "@/auth/SignUp/TopNavbar";
  import Multiselect from 'vue-multiselect'
  import BillingDetails from './BillingDetails'
  import PurchaseSummary from './PurchaseSummary'

  import data from './BillingPlansData.json'

  export default {
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states', 'userInfo'],
    components: {
      Loading,
      TopNavbar,
      Multiselect,
      BillingDetails,
      PurchaseSummary
    },
    created() {
      // console.log('userInfo', this.userInfo)
      // console.log('industryIds', this.industryIds)
      // console.log('subIndustryIds', this.subIndustryIds)
      // console.log('jurisdictionIds', this.jurisdictionIds)
      // console.log('states', this.states)
      if(this.industryIds) this.formStep1.industryOptions = this.industryIds;
      // if(this.subIndustryIds) this.formStep2.subIndustryOptions = this.subIndustryIds;
      if(this.subIndustryIds) {
        for (const [key, value] of Object.entries(this.subIndustryIds)) {
          // console.log(`${key}: ${value}`);
          this.formStep1.subIndustryOptions.push({
            value: key,
            name: value
          })
        }
      }
      if(this.jurisdictionIds) this.formStep1.jurisdictionOptions = this.jurisdictionIds;
      if(this.states) this.formStep1.stateOptions = this.states;

      const accountInfo = localStorage.getItem('app.currentUser');
      const accountInfoParsed = JSON.parse(accountInfo);
      // console.log(JSON.parse(accountInfo))
      if(accountInfo) {
        this.formStep2.companyName = accountInfoParsed.business_name;
        // this.formStep2.website = accountInfoParsed;
        this.formStep2.aum = accountInfoParsed.aum;
        this.formStep2.aptUnit = accountInfoParsed.apartment;
        this.formStep2.numAcc = accountInfoParsed.client_account_cnt;
        // this.formStep2.businessAddress = accountInfoParsed;
        this.formStep2.city = accountInfoParsed.city;
        this.formStep2.state = accountInfoParsed.state;
        this.formStep2.zip = accountInfoParsed.zip;
        // this.formStep1.regulator = accountInfo;
        this.formStep2.industry = accountInfoParsed.industries;
        this.formStep2.subIndustry = accountInfoParsed.sub_industries;
        this.formStep2.jurisdiction = accountInfoParsed.jurisdictions;
      }


      const url = new URL(window.location);
      let stepNum = url.searchParams.get('step');
      this.currentStep = stepNum;
      if (stepNum === 2) {
        this.step1 = false;
        this.step2 = true;
        this.step3 = false;
        this.navStep1 = false;
        this.navStep2 = true;
        this.navStep3 = false;
      }
      if (stepNum === 3) {
        this.step1 = false;
        this.step2 = false;
        this.step3 = true;
        this.navStep1 = false;
        this.navStep2 = false;
        this.navStep3 = true;
      }
    },
    data() {
      return {
        userId: '',
        otpSecret: '',
        userType: 'specialist',
        formStep1: {
          regulator: [],
          regulatorSelected: 'no',
          regulatorOptions: [
            {text: 'No', value: 'no'},
            {text: 'Yes', value: 'yes'},
          ],
          regulatorOptionsTags: [],
          industry: '',
          industryOptions: [],
          subIndustry: '',
          subIndustryOptions: [],
          jurisdiction: '',
          jurisdictionOptions: [],
        },
        formStep2: {
          skills: [],
          skillsTags: [],
          file1: null,
          expirience: '',

          companyName: '',
          aum: '',
          numAcc: '',

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
        billingPlans: data.billingPlans,
        openId: null,
        isSidebarOpen: false,
        selectedPlan: [],
        additionalUsers: 0,
        paymentSourceId: null,
        disabled: true,
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      addTag (newTag) {
        const tag = {
          name: newTag,
          code: newTag.substring(0, 2) + Math.floor((Math.random() * 10000000))
        }
        this.formStep1.regulatorOptionsTags.push(tag)
        this.formStep1.regulator.push(tag)
      },
      addSkillsTag (newTag) {
        const tag = {
          name: newTag,
          code: newTag.substring(0, 2) + Math.floor((Math.random() * 10000000))
        }
        this.formStep2.skillsTags.push(tag)
        this.formStep2.skills.push(tag)
      },
      onExpirienceChange(value){
        this.formStep2.expirience = value;
      },
      onSubmit(event){
        event.preventDefault()
        console.log(this.form)
      },
      navigation(stepNum){
        const url = new URL(window.location);
        url.searchParams.set('step', stepNum);
        window.history.pushState({}, '', url);
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

        if (this.formStep1.regulatorSelected === 'yes' && !this.formStep1.regulator.length) {
          this.errors = Object.assign({}, this.errors, { regulator: `Field can't be empty!` })
          return
        }
        if (stepNum === 2 && this.formStep1.regulatorSelected === 'no' || this.formStep1.regulator) {

          if (!this.formStep1.industry) this.errors = Object.assign({}, this.errors, { industry: `Field can't be empty!` })
          if (!this.formStep1.subIndustry) this.errors = Object.assign({}, this.errors, { subIndustry: `Field can't be empty!` })
          if (!this.formStep1.jurisdiction) this.errors = Object.assign({}, this.errors, { jurisdiction: `Field can't be empty!` })
          if (!this.formStep1.industry || !this.formStep1.subIndustry || !this.formStep1.jurisdiction ) return

          this['step'+(stepNum-1)] = false
          this['navStep'+stepNum] = true
          this['step'+stepNum] = true
          this.currentStep = stepNum
          this.navigation(this.currentStep)
        }

        if (stepNum === 3) {

          // const params = {
          //   specialist: {
          //     industry_ids: this.formStep1.industry.map(record => record.id),
          //     sub_industry_ids: this.formStep1.subIndustry.map(record => record.id),
          //     jurisdiction_ids: this.formStep1.jurisdiction.map(record => record.id),
          //
          //     first_name: 'Alex556',
          //     last_name: 'Willkinson556',
          //     former_regulator: this.formStep1.regulator,
          //     // skill_names: this.formStep2.skills,
          //     skill_names: 'css',
          //     // certifications: '',
          //     resume: '',
          //     experience: this.formStep2.expirience,
          //   }
          // }
          // console.log('params', params)
          // // Add resume if it exist
          // if (this.formStep2.file1) params.specialist.resume = this.formStep2.file1
          //
          // let formData = new FormData()
          //
          // Object.entries(params.specialist).forEach(
          //   ([key, value]) => formData.append(key, value)
          // )
          // console.log('formData', formData)

          const dataToSend = {
            specialist: {
              industry_ids: this.formStep1.industry.map(record => record.id),
              sub_industry_ids: this.formStep1.subIndustry.map(record => record.id),
              jurisdiction_ids: this.formStep1.jurisdiction.map(record => record.id),

              first_name: 'Alex556',
              last_name: 'Willkinson556',
              former_regulator: this.formStep1.regulator,
              skill_names: this.formStep2.skills,
              // certifications: '',
              // resume: '',
              experience: this.formStep2.expirience,
            }
          }

          this.$store
            .dispatch('updateAccountInfo', dataToSend)
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
                this.navigation(this.currentStep)
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
      complitedPaymentMethod(response) {
        this.paymentSourceId = response.id
        this.disabled = false;
      },
      selectPlanAndComplitePurchase (selectedPlan) {
        console.log('selectedPlan', selectedPlan)
        // console.log('this.billingTypeSelected', this.billingTypeSelected)
        // CLEAR ERRORS
        this.errors = []

        let planName;
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
            console.log('response', response)

            if(response.errors) {
              this.makeToast('Error', `Something wrong!`)
            }

            if(!response.errors) {
              this.makeToast('Success', `Update subscribe successfully finished!`)
              this.paySeats(selectedPlan)
            }
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Something wrong! ${error}`)
          })
          .finally(() => this.disabled = true)
      },
      paySeats(selectedPlan) {
        const freeUsers = selectedPlan.usersCount;
        const neededUsers = +this.additionalUsers;
        console.log(neededUsers, freeUsers)
        if (neededUsers <= freeUsers) return
        const countPayedUsers = neededUsers - freeUsers
        console.log(countPayedUsers)

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
            console.log('response', response)

            for(let i=0; i <= response.length; i++) {
              if(response[i].data.errors) {
                for (const type of Object.keys(response[i].data.errors)) {
                  this.makeToast('Error', `Something wrong! ${response[i].data.errors[type]}`)
                }
              }
              if(!response[i].data.errors) {
                this.makeToast('Success', `Update seat subscribe successfully finished!`)
              }
            }
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Something wrong! ${error}`)
          })
          .finally(() => this.disabled = true)
      },
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
