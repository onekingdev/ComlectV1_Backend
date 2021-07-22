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
            // Loading
            b-form(@submit='onSubmit' @change="onChangeInput" v-if='show')
              #step1.form(:class="step1 ? 'd-block' : 'd-none'")
                .row
                  .col
                    h3.onboarding__title.m-b-10 What jurisdiction does your expertise extend to?
                    p.onboarding__sub-title Providing your jurisdiction(s) will help find clients within your domain of expertise. Select all that apply.
                .row
                  .col-xl-6
                    b-form-group#inputS-group-1(label='Jurisdiction' label-for='selectS-1' label-class="onboarding__label required")
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
                    b-form-group#inputB-group-7.m-b-40(label='Your Time Zone' label-for='selectB-7' label-class="onboarding__label required")
                      div(
                      :class="{ 'invalid': errors.time_zone }"
                      )
                        multiselect#selectB-7(
                        v-model="formStep1.time_zone"
                        :options="formStep1.timeZoneOptions"
                        :multiple="false"
                        :show-labels="false"
                        track-by="name",
                        label="name",
                        placeholder="Select Time Zone",
                        required)
                        .invalid-feedback.d-block(v-if="errors.time_zone") {{ errors.time_zone }}
                .row
                  .col
                    h3.onboarding__title.m-b-10 What industries do you serve?
                    p.onboarding__sub-title Select all that apply:
                .row
                  .col-xl-6
                    b-form-group#inputS-group-4(label='Industry' label-for='selectS-4' label-class="onboarding__label required")
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
                    b-form-group#inputS-group-5.m-b-40(label='Sub-Industry' label-for='selectS-5' label-class="onboarding__label required")
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
                .row
                  .col
                    h3.onboarding__title Are you a former regulator?
                      b-icon.onboarding__icon(icon="exclamation-circle-fill" variant="secondary")
                    p.onboarding__sub-title Select all that apply:
                .row
                  .col
                    b-form-group(v-slot='{ ariaDescribedby }')
                      b-form-radio-group(v-model='formStep1.regulatorSelected' :options='formStep1.regulatorOptions' :aria-describedby='ariaDescribedby' name='radios-stacked' stacked)
                .row
                  .col-lg-6
                    .row
                      .col-md-11.offset-lg-1
                        b-form-group(v-if="formStep1.regulatorSelected === 'yes'" label='Where did you work?'  label-for='selectS-6' label-class="onboarding__label pb-0" )
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
                    b-icon.ml-2(icon="chevron-right")
              #step2.form(:class="step2 ? 'd-block' : 'd-none'")
                Notifications.m-b-20.d-none(:notify="notify" @clicked="clickNotify")
                .d-flex.justify-content-between
                  .text-left
                    h3.onboarding__title Tell us more about yourself:
                    p.onboarding__sub-title Enter any relevant skills to better match you with suitable projects.
                  // .text-right
                  //   SpecialistModalSkipStep(@skipConfirmed="skipStep(3)", :inline="false")
                  //     b-button.mr-2(type='button' variant='outline-primary') Skip this step
                b-form-group(label='Skills' class="onboarding-group m-b-30" label-for='selectS-7' label-class="onboarding__label required")
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
                hr.m-b-40
                h3.onboarding__title What's your experience?
                p.onboarding__sub-title Select one that best matches your level of your expertise.
                b-form-group(class="onboarding-group m-b-30")
                  b-button.exp__btn(variant="default" :class="formStep2.experience === 0 ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, 0)")
                    span.exp__btn--main Junior
                    span.exp__btn--sub Beginner consultant with some industry experience.
                  b-button.exp__btn(variant="default" :class="formStep2.experience === 1 ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, 1)")
                    span.exp__btn--main Intermediate
                    span.exp__btn--sub Good experience and solid knowledge of the industry.
                  b-button.exp__btn(variant="default" :class="formStep2.experience === 2 ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, 2)")
                    span.exp__btn--main Expert
                    span.exp__btn--sub Deep understanding of industry with varied experience.
                hr.m-b-40
                // h3.onboarding__title.m-b-3.m-t-2 (Optional) Upload you resume:
                // b-form-group.m-t-2(class="onboarding-group")
                //   b-form-file(v-model='formStep2.file' :state='Boolean(formStep2.file)' accept="application/pdf" placeholder='Choose a file or drop it here...' drop-placeholder='Drop file here...')
                //   .m-t-3 Selected file: {{ formStep2.file ? formStep2.file.name : '' }}
                // hr
                h3.onboarding__title.m-b-20 (Optional) Upload your resume:
                label.dropbox.w-100(v-if="!formStep2.file" for="upload-file")
                  input.input-file(type="file" id="upload-file" accept="application/pdf" ref="file" @change="selectFile")
                  p(v-if="!formStep2.file") Drop resume here or
                    button.btn.btn-default Upload
                  p(v-if="formStep2.file") Selected file: {{ formStep2.file.name }}
                .row(v-if="formStep2.file")
                  .col-md-12.m-b-1
                    .file-card
                      div.mr-2
                        b-icon.file-card__icon(icon="file-earmark-text-fill" font-scale="2")
                      div.ml-0.mr-auto
                        p.file-card__name: b {{ formStep2.file.name }}
                        a.file-card__link.link(:href="formStep2.file.file_url" target="_blank") Download
                      div.ml-auto.align-self-start.actions
                        b-dropdown(size="sm" variant="none" class="m-0 p-0" right)
                          template(#button-content)
                            b-icon(icon="three-dots")
                          b-dropdown-item.delete(@click="removeFile") Delete File
                hr
                .text-right.m-t-2
                  b-button.mr-2(type='button' variant='default' @click="prevStep(1)")
                    b-icon.mr-2(icon="chevron-left")
                    | Go back
                  b-button(type='button' variant='dark' @click="nextStep(3)") Next
                    b-icon.ml-2(icon="chevron-right")
              #step3.form(:class="step3 ? 'd-block' : 'd-none'")
                .row
                  .col.mb-2.text-center
                    h2.mb-3 Choose your Membership plan
                    p Want to skip selecting a plan?
                    b-form-group.mb-5
                      b-button(type='button' variant='outline-primary') Continue With Free Plan
                .row.justify-content-center
                  .col-xl-3(v-for='(plan, index) in billingPlans')
                    b-card.billing-plan(:class="[index === 0 ? 'billing-plan_default' : '', index === 1 ? 'billing-plan_high' : '' ]")
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
                    b-button(type='button' variant='default' @click="prevStep(2)") Go back

        b-sidebar#BillingPlanSidebar(@hidden="closeSidebar" v-model="isSidebarOpen" backdrop-variant='dark' backdrop left no-header width="60%" no-close-on-backdrop)
          .card.registration-card
            .card-header.borderless.m-b-80.px-0.pt-0
              .d-flex.justify-content-between.m-b-40
                b-button(variant="default" @click="isSidebarOpen = false")
                  b-icon.mr-2(icon="chevron-left" variant="dark")
                  | Back
              .d-block
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
  import Multiselect from 'vue-multiselect'
  import BillingDetails from './BillingDetails'
  import PurchaseSummary from './PurchaseSummary'
  // import SpecialistModalSkipStep from './Modals/SpecialistModalSkipStep'
  import Overlay from '../Overlay'

  import data from './BillingPlansData.json'
  import Notifications from "../../../../common/Notifications/Notifications";

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
      // SpecialistModalSkipStep,
      Overlay
    },
    created() {
      // if(luxonValidTimezones) this.formStep1.timeZoneOptions = luxonValidTimezones;
      // if(luxonValidTimezones) {
      //   for (const value of luxonValidTimezones) {
      //     const [ gmt, zone ] = value.split(') ')
      //     this.formStep1.timeZoneOptions.push({
      //       value: zone,
      //       name: value
      //     })
      //   }
      // }
      if(this.timezones) {
        for (const value of this.timezones) {
          const [ zone, city ] = value
          this.formStep1.timeZoneOptions.push({
            value: city,
            name: zone
          })
        }
      }
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
        this.formStep1.industry = accountInfoParsed.industries || []
        this.onChange(accountInfoParsed.industries)
        // this.formStep1.subIndustry = accountInfoParsed.sub_industries ? accountInfoParsed.sub_industries.map((subInd, idx) => ({ name: subInd, value: idx })) : []
        this.formStep1.subIndustry = accountInfoParsed.sub_industries ? accountInfoParsed.sub_industries.map((subInd, idx) => {
          const subIndfromOpt = this.subIndustryOptions.find(opt => {
            if (opt.name === subInd)
              return opt
          })
          return {
            name: subIndfromOpt.name,
            value: subIndfromOpt.value
          }
        }) : []
        this.formStep1.jurisdiction = accountInfoParsed.jurisdictions || []
        // this.formStep1.regulatorSelected = accountInfoParsed.former_regulator ? 'yes' : 'no';

        this.formStep1.time_zone = {
          name: accountInfoParsed.time_zone,
          value: accountInfoParsed.time_zone
        }

        this.formStep2.skills = accountInfoParsed.skills || []
        this.formStep2.experience = accountInfoParsed.experience
        if(accountInfoParsed.resume_url)
          this.formStep2.file = {
            name: "Uploaded File",
            file_url: accountInfoParsed.resume_url
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
        userType: 'specialist',
        steps: [
          'Background',
          'Skills and education',
          'Choose plan'
        ],
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

              time_zone: this.formStep1.time_zone.value,
              first_name: this.currentUser.first_name,
              last_name: this.currentUser.last_name,
              former_regulator: this.formStep1.regulatorSelected === 'yes',
              specialist_other: this.formStep1.regulator.join(', '),
              experience: this.formStep2.experience,
              // certifications: '',
              resume: this.formStep2.file ? this.formStep2.file : '',
            },
            sub_industry_ids: this.formStep1.subIindustry ? this.formStep2.subIindustry.map(record => record.value) : [],
            skill_names: this.formStep2.skills ? this.formStep2.skills.map(skill => skill.name) : [],
          }

          let formData = new FormData()
          formData.append(`specialist[industry_ids][]`, this.formStep1.industry ? this.formStep1.industry.map(record => record.id) : [])
          formData.append(`specialist[jurisdiction_ids][]`, this.formStep1.jurisdiction ? this.formStep1.jurisdiction.map(record => record.id) : [])
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
                // this.toast('Success', `Company info successfully sended!`)
              }
            })
            .catch(error => {
              console.error(error)
              // this.toast('Error', `Something wrong! ${error.error}`)
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
          this.overlay = true
          this.overlayStatusText = 'Setting up account...'

          const data = {
            userType: this.userType,
            planName: 'free',
            paymentSourceId : null,
          }

          this.$store.dispatch('updateSubscribe', data)
            .then(response => {
              // this.toast('Success', `Update subscribe successfully finished! You will be redirect.`)
              this.currentPlan = { id: 1, status: true }
              this.overlayStatus = 'success'
              this.redirect()
            })
            .catch(error =>{
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
                // this.toast('Error', `${key}: ${value}`)
                // this.errors = Object.assign(this.errors, { [key]: value })
                throw new Error(`${[key]} ${value}`)
              }
            }

            if(!response.errors) {
              // this.toast('Success', `Update subscribe successfully finished!`)

              // OVERLAY
              if(+this.additionalUsers === 0) {
                this.overlayStatus = 'success'
                this.overlayStatusText = 'Payment complete! Setting up account...'
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
        localStorage.setItem('app.currentUser.firstEnter', JSON.stringify(true))
        const dashboard = this.userType === 'business' ? '/business' : '/specialist'
        setTimeout(() => {
          window.location.href = `${dashboard}`;
        }, 3000)
      },
      removeFile() {
        this.formStep2.file = null
      },
    },
    computed: {
      // loading() {
      //   return this.$store.getters.loading;
      // },
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
    min-height: calc(1.5em + 0.75rem + 2px);
  }
  .multiselect__placeholder {
    margin-bottom: 0;
    padding-top: 0;
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
    line-height: 1.2rem;
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
