<template lang="pug">
  .container-fluid.onboarding
    TopNavbar(:userInfo="userInfo")
    main.row#main-content
      .col-xl-10.col-md-9.m-x-auto
        Overlay(v-if="overlay", :status="overlayStatus", :statusText="overlayStatusText", :show="overlay")
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
          b-form(@submit='onSubmit' @change="onChangeInput" v-if='show')
            #step1.form(v-if='!loading' :class="step1 ? 'd-block' : 'd-none'")
              h3 What jurisdiction does your expertise extend to?
              p Providing your jurisdiction(s) will help find clients within your domain of expertise. Select all that apply.
              .row
                .col-xl-6
                  b-form-group#inputS-group-1(label='Jurisdiction' label-for='selectS-1' label-class="required")
                    div(
                    :class="{ 'invalid': errors.jurisdiction }"
                    )
                      multiselect#selectS-1(
                      v-model="formStep1.jurisdiction"
                      :options="formStep1.jurisdictionOptions"
                      :multiple="true"
                      :show-labels="false"
                      track-by="name",
                      label="name",
                      placeholder="Select jurisdiction",
                      required)
                      .invalid-feedback.d-block(v-if="errors.jurisdiction") {{ errors.jurisdiction }}
              .row
                .col-xl-6
                  b-form-group#inputB-group-7(label='Time Zone' label-for='selectB-7' label-class="required")
                    div(
                    :class="{ 'invalid': errors.time_zone }"
                    )
                      multiselect#selectB-7(
                      v-model="formStep1.time_zone"
                      :options="formStep1.timeZoneOptions"
                      :multiple="false"
                      :show-labels="false"
                      placeholder="Select Time Zone",
                      required)
                      .invalid-feedback.d-block(v-if="errors.time_zone") {{ errors.time_zone }}
              h3 What industries do you serve?
              p Select all that apply:
              .row
                .col-xl-6
                  b-form-group#inputS-group-4(label='Industry' label-for='selectS-4' label-class="required")
                    div(
                    :class="{ 'invalid': errors.industry }"
                    )
                      multiselect#selectS-4(
                      v-model="formStep1.industry"
                      :options="formStep1.industryOptions"
                      :multiple="true"
                      :show-labels="false"
                      track-by="name",
                      label="name",
                      placeholder="Select Industry",
                      @input="onChange",
                      required)
                      .invalid-feedback.d-block(v-if="errors.industry") {{ errors.industry }}
              .row
                .col-xl-6
                  b-form-group#inputS-group-5(label='Sub-Industry' label-for='selectS-5' label-class="required")
                    div(
                    :class="{ 'invalid': errors.subIndustry }"
                    )
                      multiselect#selectS-5(
                      v-model="formStep1.subIndustry"
                      :options="formStep1.subIndustryOptions"
                      :multiple="true"
                      :show-labels="false"
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
                  div(
                  :class="{ 'invalid': errors.regulator }"
                  )
                    multiselect#selectS-6(
                    v-model="formStep1.regulator"
                    :options="formStep1.regulatorOptionsTags"
                    :multiple="true"
                    :show-labels="false"
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
              div.d-flex.justify-content-between
                .text-left
                  h3.onboarding__title Tell us more about yourself:
                  p.onboarding__sub-title Enter any relevant skills and education to better match with ideal clients.
                // .text-right
                //   SpecialistModalSkipStep(@skipConfirmed="skipStep(3)", :inline="false")
                //     b-button.mr-2(type='button' variant='outline-primary') Skip this step
              b-form-group(label='Skills' class="onboarding-group" label-for='selectS-7' label-class="required")
                div(
                :class="{ 'invalid': errors.skills }"
                )
                  multiselect#selectS-7(
                  v-model="formStep2.skills"
                  :options="formStep2.skillsTags"
                  :multiple="true"
                  :show-labels="false"
                  track-by="name",
                  label="name",
                  tag-placeholder="Add this as new tag",
                  placeholder="Search or add a tag",
                  :taggable="true",
                  @tag="addSkillsTag"
                  required)
                  .invalid-feedback.d-block(v-if="errors.skills") {{ errors.skills }}
              hr
              h3.onboarding__title.m-t-2 What's your experience?
              p.onboarding__sub-title Select one that the best matches your level of your expertise.
              b-form-group(class="onboarding-group")
                b-button.exp__btn(variant="default" :class="formStep2.experience === 0 ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, 0)")
                  span.exp__btn--main Junior
                  span.exp__btn--sub Begining consulting with some experience in the field.
                b-button.exp__btn(variant="default" :class="formStep2.experience === 1 ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, 1)")
                  span.exp__btn--main Intermediate
                  span.exp__btn--sub Good experience and knowlage of the industry.
                b-button.exp__btn(variant="default" :class="formStep2.experience === 2 ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, 2)")
                  span.exp__btn--main Expert
                  span.exp__btn--sub Deep understanding of industry with varied experience.
              hr
              // h3.onboarding__title.m-b-3.m-t-2 (Optional) Upload you resume:
              // b-form-group.m-t-2(class="onboarding-group")
              //   b-form-file(v-model='formStep2.file' :state='Boolean(formStep2.file)' accept="application/pdf" placeholder='Choose a file or drop it here...' drop-placeholder='Drop file here...')
              //   .m-t-3 Selected file: {{ formStep2.file ? formStep2.file.name : '' }}
              // hr
              h3.onboarding__title.m-b-3.m-t-2 (Optional) Upload you resume:
              label.dropbox.w-100(for="upload-file")
                input.input-file(type="file" id="upload-file" accept="application/pdf" ref="file" @change="selectFile")
                p(v-if="!formStep2.file") Drag your resume here
                  br
                  | or
                  br
                  button.btn.btn-default Upload
                p(v-if="formStep2.file") Selected file: {{ formStep2.file.name }}
              hr
              .text-right.m-t-2
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
                  b-card.w-100.mb-2.billing-plan(:class="[index === 0 ? 'billing-plan_default' : '', index === 1 ? 'billing-plan_high' : '' ]")
                    b-button.mb-3(type='button' :variant="currentPlan.status && currentPlan.id === index+1 ? 'dark' : 'outline-primary'" @click="openDetails(plan)")
                      | {{ currentPlan.status && currentPlan.id === index+1 ? 'Current' : 'Select' }} Plan
                    b-card-text
                      h4.billing-plan__name {{ plan.name }}
                      p.billing-plan__descr {{ plan.description }}
                      h5.billing-plan__coast {{ billingTypeSelected === 'annually' ?  plan.coastAnnuallyFormatted : plan.coastMonthlyFormatted }}
                      // p.billing-plan__users {{ billingTypeSelected === 'annually' ?  plan.usersCount + ' free users plus $' + plan.additionalUserAnnually + '/year per person' : plan.usersCount + ' free users plus $' + plan.additionalUserMonthly + '/mo per person' }}
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

    return `(GMT ${rhoursView}:${rminutes}) ${zoneNameView}`
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
  // import SpecialistModalSkipStep from './Modals/SpecialistModalSkipStep'
  import Overlay from '../Overlay'

  import data from './BillingPlansData.json'

  export default {
    props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states', 'userInfo'],
    components: {
      Loading,
      TopNavbar,
      Multiselect,
      BillingDetails,
      PurchaseSummary,
      // SpecialistModalSkipStep,
      Overlay
    },
    created() {
      if(luxonValidTimezones) this.formStep1.timeZoneOptions = luxonValidTimezones;
      if(this.industryIds) this.formStep1.industryOptions = this.industryIds;
      // if(this.subIndustryIds) this.formStep2.subIndustryOptions = this.subIndustryIds;
      // if(this.subIndustryIds) {
      //   for (const [key, value] of Object.entries(this.subIndustryIds)) {
      //     this.formStep1.subIndustryOptions.push({
      //       value: key,
      //       name: value
      //     })
      //   }
      // }
      if(this.jurisdictionIds) this.formStep1.jurisdictionOptions = this.jurisdictionIds;
      if(this.states) this.formStep1.stateOptions = this.states;

      const accountInfo = localStorage.getItem('app.currentUser');
      const accountInfoParsed = JSON.parse(accountInfo);
      if(accountInfo) {
        this.formStep1.industry = accountInfoParsed.industries || ''
        this.onChange(accountInfoParsed.industries)
        this.formStep1.subIndustry = accountInfoParsed.sub_industries || ''
        this.formStep1.jurisdiction = accountInfoParsed.jurisdiction || ''
        // this.formStep1.regulatorSelected = accountInfoParsed.former_regulator ? 'yes' : 'no';

        this.formStep2.skills = accountInfoParsed.skills || []
        this.formStep2.experience = accountInfoParsed.experience
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
          time_zone: [],
          timeZoneOptions: [],
        },
        formStep2: {
          skills: [],
          skillsTags: [],
          file: null,
          experience: '',

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
      onexperienceChange(event, value){
        document.querySelectorAll('.exp__btn').forEach((el) => el.classList.remove('active'))
        if (event.target.classList.contains('exp__btn')) {
          event.target.classList.toggle('active')
        } else {
          event.target.closest(".exp__btn").classList.toggle('active')
        }
        this.formStep2.experience = value;
      },
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

        if (this.formStep1.regulatorSelected === 'yes' && !this.formStep1.regulator.length) {
          this.errors = Object.assign({}, this.errors, { regulator: `Field can't be empty!` })
          return
        }
        if (stepNum === 2) {
          if (!this.formStep1.jurisdiction.length) this.errors = Object.assign({}, this.errors, { jurisdiction: `Field can't be empty!` })
          if (!this.formStep1.time_zone.length) this.errors = Object.assign({}, this.errors, { time_zone: `Field can't be empty!` })
          if (!this.formStep1.industry.length) this.errors = Object.assign({}, this.errors, { industry: `Field can't be empty!` })
          if (!this.formStep1.subIndustry.length) this.errors = Object.assign({}, this.errors, { subIndustry: `Field can't be empty!` })
          if (!this.formStep1.industry || !this.formStep1.time_zone || !this.formStep1.subIndustry || !this.formStep1.jurisdiction ) return

          this.navigation(stepNum)
        }

        if (stepNum === 3) {

          if (!this.formStep2.skills) this.errors = Object.assign({}, this.errors, { skills: `Field can't be empty!` })
          if (!this.formStep2.skills) return

          const params = {
            specialist: {
              // industry_ids: this.formStep1.industry.map(record => record.id),
              // jurisdiction_ids: this.formStep1.jurisdiction.map(record => record.id),

              time_zone: this.formStep1.time_zone,
              first_name: this.currentUser.first_name,
              last_name: this.currentUser.last_name,
              former_regulator: this.formStep1.regulatorSelected === 'yes',
              specialist_other: this.formStep1.regulator.join(', '),
              experience: this.formStep2.experience,
              // certifications: '',
              resume: this.formStep2.file ? this.formStep2.file : '',
            },
            sub_industry_ids: this.formStep1.subIndustry.map(record => record.value),
            skill_names: this.formStep2.skills.map(skill => skill.name),
          }

          let formData = new FormData()
          formData.append(`specialist[industry_ids][]`, this.formStep1.industry.map(record => record.id))
          formData.append(`specialist[jurisdiction_ids][]`, this.formStep1.jurisdiction.map(record => record.id))
          Object.keys(params.specialist)
            .map(specAttr => formData.append(`specialist[${specAttr}]`, params.specialist[specAttr]))
          params.sub_industry_ids
            .map(subIindustryIds => formData.append(`sub_industry_ids[]`, subIindustryIds))
          params.skill_names
            .map(skillName => formData.append(`skill_names[]`, skillName))

          this.$store.dispatch('updateAccountInfoWithFile', formData)
            .then(response => {
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
              this.makeToast('Error', `Something wrong! ${error.error}`)
            })
        }
      },
      // skipStep(stepNum){
      //   this['step'+(stepNum-1)] = false
      //   this['navStep'+stepNum] = true
      //   this['step'+stepNum] = true
      //   this.currentStep = stepNum
      //   this.navigation(this.currentStep)
      //
      //   this.formStep2 = {
      //       skills: [],
      //       skillsTags: [],
      //       file: null,
      //       experience: '',
      //   }
      // },
      openDetails(plan) {
        if(plan.id === 1) {
          const dataToSend = {
            userType: this.userType,
            planName: 'free',
            paymentSourceId : null,
          }

          this.$store.dispatch('updateSubscribe', dataToSend)
            .then(response => {
              this.makeToast('Success', `Update subscribe successfully finished! You will be redirect.`)
              this.currentPlan = { id: 1, status: true }
              this.redirect()
            })
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
        this.project = null
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
          planName = 'specialist_pro';
        }

        const dataToSend = {
          userType: this.userType,
          planName,
          paymentSourceId : this.paymentSourceId,
        }

        this.$store
          .dispatch('updateSubscribe', dataToSend)
          .then(response => {
            if(response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                // this.makeToast('Error', `${key}: ${value}`)
                // this.errors = Object.assign(this.errors, { [key]: value })
                throw new Error(`${[key]} ${value}`)
              }
            }

            if(!response.errors) {
              this.makeToast('Success', `Update subscribe successfully finished!`)

              // OVERLAY
              if(+this.additionalUsers === 0) {
                this.overlayStatusText = 'Account successfully purchased, you will be redirect to the dashboard...'
                this.overlayStatus = 'success'
                // this.overlay = false
                this.redirect()
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
      selectFile(event){
        this.formStep2.file = event.target.files[0]
      },
      onChange (industries) {
        if(industries) {
          delete this.errors.industries
          this.formStep1.subIndustryOptions = []
          const results = industries.map(industry => industry.id)

          if(this.subIndustryIds) {
            for (const [key, value] of Object.entries(this.subIndustryIds)) {
              for (const i of results) {
                if (i === +key.split('_')[0]) {
                  this.formStep1.subIndustryOptions.push({
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
      redirect() {
        const dashboard = this.userType === 'business' ? '/business' : '/specialist'
        setTimeout(() => {
          window.location.href = `${dashboard}`;
        }, 3000)
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      currentUser() {
        return this.$store.getters.getUser
      },
    },
    async mounted () {
      try {
        await this.$store.dispatch('getSkills')
          .then(response => this.formStep2.skillsTags = response)
          .catch(error => error)
      } catch (error) {
        console.error(error)
      }
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
