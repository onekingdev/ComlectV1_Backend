<template lang="pug">
  div.registration-onboarding(:class="{ full: isSidebarOpen }")
    Overlay(v-if="overlay.active")
    .col.m-x-auto(v-if="!isSidebarOpen")
      .card
        .card-header
          h2.registration-onboarding__title Set Up Your Account
        .card-body.white-card-body.borderless.onboarding
          Steps(:steps="steps", :currentStep="currentStep")
          // Loading
          b-form(@submit='onSubmit' @change="onChangeInput" v-if='show')
            #step1.form(:class="currentStep === 1 ? 'd-block' : 'd-none'")
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
                      :options="staticCollection.jurisdictions"
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
                      :options="staticCollection.timezones"
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
                      :options="staticCollection.industries"
                      :multiple="true"
                      :show-labels="false"
                      track-by="name",
                      label="name",
                      placeholder="Select Industry",
                      @input="onChangeIndustries",
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
              .row
                .col
                  .text-right.m-t-30
                    b-button(type='button' variant='dark' @click="nextStep(2)") Next
                      b-icon.ml-2(icon="chevron-right")
            #step2.form(:class="currentStep === 2 ? 'd-block' : 'd-none'")
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
                    div
                      b-icon.file-card__icon(icon="file-earmark-text-fill")
                    div.ml-0.mr-auto
                      p.file-card__name {{ formStep2.file.name }}
                      a.file-card__link.link(:href="formStep2.file.file_url" target="_blank") Download
                    div.ml-auto.align-self-start.actions
                      b-dropdown(size="sm" class="m-0 p-0" right)
                        template(#button-content)
                          b-icon(icon="three-dots")
                        b-dropdown-item.delete(@click="removeFile") Delete File
              hr
              .row
                .col
                  .text-right.m-t-30
                    b-button.mr-2(type='button' variant='default' @click="prevStep(1)")
                      b-icon.mr-2(icon="chevron-left")
                      | Go back
                    b-button(type='button' variant='dark' @click="nextStep(3)") Next
                      b-icon.ml-2(icon="chevron-right")
            #step3.form(:class="currentStep === 3 ? 'd-block' : 'd-none'")
              SelectPlan(:userType="userType" @goBack="prevStep(2)" @openDetails="openDetails")
    SelectPlanPaymentAndSummary(:userType="userType" :isSidebarOpen="isSidebarOpen" :selectedPlan="selectedPlan" @sidebarToggle="isSidebarOpen = $event")

</template>

<script>
  // import Loading from '@/common/Loading/Loading'
  import TopNavbar from "@/auth/components/TopNavbar";
  import Steps from "@/auth/components/Steps";
  import Multiselect from 'vue-multiselect'
  import SelectPlan from '@/auth/components/SelectPlan/Specialist'
  import SelectPlanPaymentAndSummary from '@/auth/components/SelectPlan/Specialist/components/SelectPlanDetails'
  import Overlay from '../Overlay'

  export default {
    // props: ['industryIds', 'jurisdictionIds', 'subIndustryIds', 'states', 'userInfo', 'timezones'],
    props: ['userInfo'],
    components: {
      Steps,
      // Loading,
      TopNavbar,
      Multiselect,
      SelectPlan,
      SelectPlanPaymentAndSummary,
      Overlay
    },
    created() {
      // if(this.timezones) {
      //   for (const value of this.timezones) {
      //     const [ zone, city ] = value
      //     this.formStep1.timeZoneOptions.push({
      //       value: city,
      //       name: zone
      //     })
      //   }
      // }
      // if(this.industryIds) this.formStep1.industryOptions = this.industryIds;
      // if(this.jurisdictionIds) this.formStep1.jurisdictionOptions = this.jurisdictionIds;
      // if(this.states) this.formStep1.stateOptions = this.states;

      const accountInfo = localStorage.getItem('app.currentUser');
      const accountInfoParsed = JSON.parse(accountInfo);
      if(accountInfo) {
        this.formStep1.industry = accountInfoParsed.industries || []
        this.onChangeIndustries(accountInfoParsed.industries)
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
      const currentStep = +url.searchParams.get('step')
      this.currentStep = currentStep ? currentStep : 1;
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
          // industryOptions: [],
          subIndustry: '',
          subIndustryOptions: [],
          jurisdiction: '',
          // jurisdictionOptions: [],
          time_zone: [],
          // timeZoneOptions: [],
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
          // state: '',
          // stateOptions: [],
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

        currentStep: 1,

        billingTypeSelected: 'annually',
        billingTypeOptions: [
          { text: 'Billed Annually', value: 'annually' },
          { text: 'Billed Monthly', value: 'monthly' },
        ],

        openId: null,
        isSidebarOpen: false,
        selectedPlan: [],
        additionalUsers: 0,
        paymentSourceId: null,
        disabled: true,

        currentPlan: { id: null, status: false }
      }
    },
    methods: {
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

        this.currentStep = stepNum
      },
      prevStep(stepNum) {
        this.navigation(stepNum)
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
                this.navigation(stepNum)
                // this.toast('Success', `Company info successfully sended!`)
              }
            })
            .catch(error => console.error('updateAccountInfoWithFile', error))
        }
      },
      openDetails(plan) {
        if(plan.id === 1) {

          this.$store.dispatch('setOverlay', {
            active: true,
            message: 'Setting up account...',
            status: ''
          })

          const data = {
            userType: this.userType,
            planName: 'free',
            paymentSourceId : null,
          }

          this.$store.dispatch('updateSubscribe', data)
            .then(response => {
              this.currentPlan = { id: 1, status: true }

              this.$store.dispatch('setOverlay', {
                active: true,
                message: 'Setting up account...',
                status: 'success'
              })
              setTimeout(() => this.redirect() , 3000)
            })
            .catch(error =>{
              console.error('updateSubscribe', error)

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
              }), 3000)
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
      selectFile(event){
        this.formStep2.file = event.target.files[0]
      },
      onChangeIndustries (industries) {
        if(industries) {
          delete this.errors.industries
          this.formStep1.subIndustryOptions = []
          const results = industries.map(industry => industry.id)

          if(this.staticCollection.sub_industries_specialist) {
            for (const [key, value] of Object.entries(this.staticCollection.sub_industries_specialist)) {
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
      // onChangeState(){
      //   delete this.errors.state
      // },
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
      this.$store.dispatch('getSkills')
        .then(response => this.formStep2.skillsTags = response)
        .catch(error => console.error(error))

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
