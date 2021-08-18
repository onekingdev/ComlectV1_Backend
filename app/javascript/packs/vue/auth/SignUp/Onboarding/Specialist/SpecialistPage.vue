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
                    :class="{ 'invalid': errors.jurisdiction_ids }"
                    )
                      multiselect#selectS-1(
                      v-model="form.specialist.jurisdiction_ids"
                      :options="staticCollection.jurisdictions"
                      :multiple="true"
                      :show-labels="false"
                      track-by="name",
                      label="name",
                      placeholder="Select jurisdiction",
                      required)
                      .invalid-feedback.d-block(v-if="errors.jurisdiction_ids") {{ errors.jurisdiction_ids[0] }}
              .row
                .col-xl-6
                  b-form-group#inputB-group-7.m-b-40(label='Your Time Zone' label-for='selectB-7' label-class="onboarding__label required")
                    div(
                    :class="{ 'invalid': errors.time_zone }"
                    )
                      multiselect#selectB-7(
                      v-model="form.specialist.time_zone"
                      :options="staticCollection.timezones"
                      :multiple="false"
                      :show-labels="false"
                      track-by="name",
                      label="name",
                      placeholder="Select Time Zone",
                      required)
                      .invalid-feedback.d-block(v-if="errors.time_zone") {{ errors.time_zone[0] }}
              .row
                .col
                  h3.onboarding__title.m-b-10 What industries do you serve?
                  p.onboarding__sub-title Select all that apply:
              .row
                .col-xl-6
                  b-form-group#inputS-group-4(label='Industry' label-for='selectS-4' label-class="onboarding__label required")
                    div(
                    :class="{ 'invalid': errors.industry_ids }"
                    )
                      multiselect#selectS-4(
                      v-model="form.specialist.industry_ids"
                      :options="staticCollection.industries"
                      :multiple="true"
                      :show-labels="false"
                      track-by="name",
                      label="name",
                      placeholder="Select Industry",
                      @input="onChangeIndustries",
                      required)
                      .invalid-feedback.d-block(v-if="errors.industry_ids") {{ errors.industry_ids[0] }}
              .row
                .col-xl-6
                  b-form-group#inputS-group-5.m-b-40(label='Sub-Industry' label-for='selectS-5' label-class="onboarding__label required")
                    div(
                    :class="{ 'invalid': errors.sub_industries }"
                    )
                      multiselect#selectS-5(
                      v-model="form.specialist.sub_industry_ids"
                      :options="subIndustryOptions"
                      :multiple="true"
                      :show-labels="false"
                      track-by="name",
                      label="name",
                      placeholder="Select Sub-Industry",
                      required)
                      .invalid-feedback.d-block(v-if="errors.sub_industries") {{ errors.sub_industries[0] }}
              .row
                .col
                  h3.onboarding__title Are you a former regulator?
                  p.onboarding__sub-title Select all that apply:
              .row
                .col
                  b-form-group(v-slot='{ ariaDescribedby }')
                    b-form-radio-group(v-model='form.specialist.former_regulator' :options='regulatorOptions' :aria-describedby='ariaDescribedby' name='radios-stacked' stacked)
              .row
                .col-lg-6
                  .row
                    .col-md-11.offset-lg-1
                      b-form-group(v-if="form.specialist.former_regulator" label='Where did you work?'  label-for='selectS-6' label-class="onboarding__label pb-0" )
                        div(
                        :class="{ 'invalid': errors.specialist_other }"
                        )
                          multiselect#selectS-6(
                          v-model="specialist_other"
                          :options="specialistOtherOptions"
                          :multiple="true"
                          :show-labels="false"
                          track-by="name",
                          label="name",
                          tag-placeholder="Add this as new tag",
                          placeholder="Search or add a tag",
                          :taggable="true",
                          @tag="addTag"
                          required)
                          .invalid-feedback.d-block(v-if="errors.specialist_other") {{ errors.specialist_other[0] }}
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
              b-form-group(label='Skills' class="onboarding-group m-b-30" label-for='selectS-7' label-class="onboarding__label")
                div(
                :class="{ 'invalid': errors.skill_names }"
                )
                  multiselect#selectS-7(
                  v-model="form.specialist.skill_names"
                  :options="skillsTags"
                  :multiple="true"
                  :show-labels="false"
                  track-by="name",
                  label="name",
                  tag-placeholder="Add this as new tag",
                  placeholder="Search or add a tag",
                  :taggable="true",
                  @tag="addSkillsTag"
                  required)
                  .invalid-feedback.d-block(v-if="errors.skill_names") {{ errors.skill_names }}
              h3.onboarding__title What's your experience?
              label.onboarding__sub-title(class='label required') Select one that best matches your level of your expertise.
              b-form-group(class="onboarding-group m-b-30")
                b-button.exp__btn(variant="default" :class="form.specialist.experience === '0' ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, '0')")
                  span.exp__btn--main Junior
                  span.exp__btn--sub Beginner consultant with some industry experience.
                b-button.exp__btn(variant="default" :class="form.specialist.experience === '1' ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, '1')")
                  span.exp__btn--main Intermediate
                  span.exp__btn--sub Good experience and solid knowledge of the industry.
                b-button.exp__btn(variant="default" :class="form.specialist.experience === '2' ? 'active' : ''" type='button' data-toggle="button" aria-pressed="false" autocomplete="off" @click="onexperienceChange($event, '2')")
                  span.exp__btn--main Expert
                  span.exp__btn--sub Deep understanding of industry with varied experience.
                .invalid-feedback.d-block(v-if="errors.experience") {{ errors.experience[0] }}
              // h3.onboarding__title.m-b-3.m-t-2 (Optional) Upload you resume:
              // b-form-group.m-t-2(class="onboarding-group")
              //   b-form-file(v-model='form.file' :state='Boolean(form.file)' accept="application/pdf" placeholder='Choose a file or drop it here...' drop-placeholder='Drop file here...')
              //   .m-t-3 Selected file: {{ form.file ? form.file.name : '' }}
              // hr
              h3.onboarding__title.m-b-10 Upload your resume:
              p.onboarding__sub-title Optional
              label.dropbox.w-100(v-if="!file" for="upload-file")
                input.input-file(type="file" id="upload-file" accept="application/pdf" ref="file" @change="selectFile")
                p(v-if="!file") Drop resume here OR
                  button.btn.btn-default Upload
                p(v-if="file") Selected file: {{ file.name }}
              .row(v-if="file")
                .col-md-12.m-b-1
                  .file-card
                    div
                      b-icon.file-card__icon(icon="file-earmark-text-fill")
                    .ml-0.mr-auto
                      p.file-card__name {{ file.name }}
                      a.file-card__link.link(:href="file.file_url" target="_blank") Download
                    .ml-auto.my-auto.align-self-start.actions
                      b-dropdown(size="sm" class="m-0 p-0" right)
                        template(#button-content)
                          b-icon(icon="three-dots")
                        b-dropdown-item.delete(@click="removeFile") Delete File
              .row
                .col
                  .text-right.m-t-30
                    b-button.mr-2(type='button' variant='default' @click="prevStep(1)")
                      b-icon.mr-2(icon="chevron-left")
                      | Go Back
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

  const initialAccountInfo = () => ({
    specialist: {
      jurisdiction_ids: [],
      time_zone: '', // "International Date Line West"
      industry_ids: [],
      sub_industry_ids: [],
      former_regulator: false, // Boolean
      //specialist_other: [], //# if former_regulator -> true "specialist_other"=>"val1, val2"
      skill_names: [], // "#finra", "#cfdc"
      experience: null, // integer 0 1 2//
      resume:  null,
    },
  })

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
      const accountInfo = localStorage.getItem('app.currentUser');
      const accountInfoParsed = JSON.parse(accountInfo);
      if(accountInfo) {
        this.form.specialist.industry_ids = accountInfoParsed.industries || []
        this.onChangeIndustries(accountInfoParsed.industries)
        this.form.specialist.jurisdiction_ids = accountInfoParsed.jurisdictions || []

        this.form.specialist.time_zone = {
          name: accountInfoParsed.time_zone,
          value: accountInfoParsed.time_zone
        }

        this.form.specialist.skill_names = accountInfoParsed.skills || []
        this.form.specialist.experience = accountInfoParsed.experience
        if(accountInfoParsed.resume_url)
          this.file = {
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
        form: initialAccountInfo(),
        subIndustryOptions: [],
        regulatorOptions: [
         { text: 'No', value: false },
         { text: 'Yes', value: true },
        ],
        specialist_other: [],
        specialistOtherOptions: [],
        regulatorOptionsTags: [],
        skillsTags: [],
        file: null,

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
        this.regulatorOptionsTags.push(tag)
        this.specialistOtherOptions.push(tag)
      },
      addSkillsTag (newTag) {
        const tag = {
          name: newTag,
          code: newTag.substring(0, 2) + Math.floor((Math.random() * 10000000))
        }
        this.skillsTags.push(tag)
        this.form.skill_names.push(tag)
      },
      onexperienceChange(event, value){
        document.querySelectorAll('.exp__btn').forEach((el) => el.classList.remove('active'))
        if (event.target.classList.contains('exp__btn')) {
          event.target.classList.toggle('active')
        } else {
          event.target.closest(".exp__btn").classList.toggle('active')
        }
        this.form.specialist.experience = value;
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
      applyData(formData, field, data) {
        if (data.length) {
          data.forEach((item) => formData.append(field, item))
        } else {
          formData.append(field, data);
        }
      },
      nextStep(stepNum) {

        if (stepNum === 2) {
          this.navigation(stepNum)
        }

        if (stepNum === 3) {
          // CLEAR ERRORS
          for (var value in this.errors) delete this.errors[value];

          console.log('form', this.form)

          const params = {
            specialist: {
              jurisdiction_ids: this.form.specialist.jurisdiction_ids ? this.form.specialist.jurisdiction_ids.map(record => record.id) : [],
              time_zone: this.form.specialist.time_zone.value  ? this.form.specialist.time_zone.value : '',
              industry_ids: this.form.specialist.industry_ids ? this.form.specialist.industry_ids.map(record => record.id) : [],
              sub_industry_ids: this.form.specialist.sub_industry_ids ? this.form.specialist.sub_industry_ids.map(record => record.value) : [],
              former_regulator: this.form.specialist.former_regulator,
              //specialist_other: this.form.specialist_other.join(', '),
              skill_names: this.form.specialist.skill_names ? this.form.specialist.skill_names.map(skill => skill.name) : [],
              experience: this.form.specialist.experience,
              resume: this.file ? this.file : '',
            },
          }

          const specialist = params.specialist
          let formData = new FormData()

          this.applyData(formData, 'specialist[jurisdiction_ids][]', specialist.jurisdiction_ids)
          formData.append('specialist[time_zone]', specialist.time_zone);
          this.applyData(formData, 'specialist[industry_ids][]', specialist.industry_ids)
          this.applyData(formData, 'specialist[sub_industry_ids][]', specialist.sub_industry_ids)
          formData.append('specialist[former_regulator]', specialist.former_regulator);
          this.applyData(formData, 'specialist[skill_names][]', specialist.skill_names)
          formData.append('specialist[experience]', specialist.experience);
          formData.append('specialist[resume]', specialist.resume);

          if (this.form.specialist.former_regulator) {
            formData.append('specialist[specialist_other]', this.specialist_other ? this.specialist_other.map(record => record.name).join(', ') : [])
          }

          this.$store.dispatch('updateAccountInfoWithFile', formData)
            .then(response => {
              if(response.errors) {
                for (const type of Object.keys(response.errors)) {
                  this.errors = response.errors[type]
                }
                console.log('this.errors')

                if (response.errors.specialist.industry_ids || response.errors.specialist.jurisdiction_ids || response.errors.specialist.sub_industries || response.errors.specialist.time_zone || response.errors.specialist.specialist_other) {
                  this.navigation(1)
                }
              }
              if(!response.errors) {
                this.navigation(stepNum)
              }
            })
            .catch(error => {
              // this.navigation(1)
              console.error('updateAccountInfoWithFile', error)
              this.toast('Error', `${error.status} ${error.statusText}`, true)
            })
        }
      },
      openDetails(plan) {
        if(plan.id === 1) {

          this.$store.dispatch('setOverlay', {
            active: true,
            message: 'Setting up account',
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

              // this.$store.dispatch('setOverlay', {
              //   active: true,
              //   message: 'Setting up account...',
              //   status: 'success'
              // })
              // setTimeout(() => this.redirect() , 2000)
              this.redirect()
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
              }), 2000)
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
        this.file = event.target.files[0]
      },
      onChangeIndustries (industries) {
        if(industries) {
          delete this.errors.industry_ids
          this.subIndustryOptions = []
          const results = industries.map(industry => industry.id)

          if(this.staticCollection.sub_industries_specialist) {
            for (const [key, value] of Object.entries(this.staticCollection.sub_industries_specialist)) {
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
      redirect() {
        localStorage.setItem('app.currentUser.firstEnter', JSON.stringify(true))
        window.location.href = `/${this.userType}`;
      },
      removeFile() {
        this.file = null
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
      },
    },
    mounted () {
      this.$store.dispatch('getSkills')
        .then(response => this.skillsTags = response)
        .catch(error => console.error(error))

      const accountInfo = localStorage.getItem('app.currentUser');
      const accountInfoParsed = JSON.parse(accountInfo);

      this.$store.dispatch('getStaticCollection')
        .then(() => {
          this.onChangeIndustries(accountInfoParsed.industries)

          const results = accountInfoParsed.sub_industries
          if(results) {
            for (const [key, value] of Object.entries(this.staticCollection.sub_industries_specialist)) {
              for (const i of results) {
                if (i === value) {
                  this.form.specialist.sub_industry_ids.push({
                    name: value,
                    value: key
                  })
                }
              }
            }
          }
        })
        .catch(error => console.error(error))
    },
    watch: {
      form: function (newForm) {
        console.log('newForm', newForm)
        Object.entries(newForm).forEach(
          ([key, value]) => console.log(key, value)
        )
      }
    },
  }
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style scoped>
  @import "../../../styles.css";
</style>
