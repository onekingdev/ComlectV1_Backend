<template lang="pug">
  ModelLoader(:url="projectId ? endpointUrl : undefined" :default="defaultProject" @loaded="loadProject" :callback="transformBackendModel")
    .page-header
      .d-flex.flex-column
        Breadcrumbs.mb-2(:items="['Projects', pageTitle]")
        .page-header__title.my-0.ml-0.m-b-10 {{ pageTitle }}
        p.page-header__subtitle.mb-0 Tell us more about your project and get connected to our experienced specialists.
    .white-card-body.card-body_full-height.h-100
      WizardProgress(v-bind="{step,steps}")
      .row.no-gutters
        .col-lg-6(v-if="step === steps[0]")

          InputText(v-model="project.title" :errors="errors.title") Name
          .row.m-t-1
            .col-sm: InputDate(v-model="project.starts_on" :errors="errors.starts_on" :options="datepickerOptions") Start Date
            .col-sm: InputDate(v-model="project.ends_on" :errors="errors.ends_on" :options="datepickerOptions") Due Date

          InputTextarea.m-t-1(v-model="project.description" :errors="errors.description" placeholder="General project description") Description
          InputTextarea.m-t-1(v-model="project.role_details" :errors="errors.role_details" placeholder="Describe specific specialist role in the project") Role Details
          //.form-text.text-muted Project post information for the specialist

          InputSelect.m-t-1.form-control_no-icon(v-model="project.location_type" :errors="errors.location_type" :options="locationTypes") Location Type

          div.m-t-1(v-if="isLocationVisible")
            label.form-label Location
            input.form-control(v-model="project.location" type="text" v-google-maps-autocomplete)
            Errors(:errors="errors.location")

          label.m-t-1.form-label Industry
          ComboBox(v-model="project.industry_ids" :options="industryIdsOptions" :multiple="true")
          Errors(:errors="errors.industry_ids")

          label.m-t-1.form-label Jurisdiction
          ComboBox(v-model="project.jurisdiction_ids" :options="jurisdictionIdsOptions" :multiple="true")
          Errors(:errors="errors.jurisdiction_ids")

      .row.no-gutters
        .col-lg-6(v-if="step === steps[1]")
          InputSelect.form-control_no-icon(v-model="project.minimum_experience" :errors="errors.minimum_experience" :options="experienceOptions") Minimum Experience

          b-form-checkbox.m-y-1(v-model="project.only_regulators") Only former regulators
          Errors(:errors="errors.only_regulators")

          label.form-label Skills
          Get(skills="/api/skills" :callback="getSkillOptions"): template(v-slot="{skills}")
            ComboBox(v-model="project.skill_names" :multiple="true" :id-as-label="true" :tree-props="comboboxProps(skills)" @input="inputSkills")
          Errors(:errors="errors.skill_names")

      .row.no-gutters
        .col-lg-6(v-if="step === steps[2]")

          b-row.no-gutters
            .card.project-card.col-sm.pointer(v-for="(type, i) in pricingTypes" :class="cardClass(type, i)" :key="i" @click="project.pricing_type = type.id")
              .card-body.project-card__body
                div
                  ion-icon.project-card__icon(:name="i === 0 ? 'pricetags-outline' : 'time-outline'")
                .d-block
                  h5.card-title.project-card__title {{type.label}}
                  p.card-text.project-card__text {{type.text}}

          .m-t-1(v-if="project.pricing_type === pricingTypes[0].id")
            InputText(v-model="project.est_budget" :errors="errors.est_budget") Estimated Budget
            InputSelect.form-control_no-icon.m-t-1(v-model="project.fixed_payment_schedule" :errors="errors.fixed_payment_schedule" :options="fixedPaymentScheduleOptions") Method of Payment

          div(v-else)
            .m-t-1
              InputText(v-model="project.hourly_rate" :errors="errors.hourly_rate") Estimated Hourly Rate
            .m-t-1
              InputText(v-model="project.upper_hourly_rate" :errors="errors.upper_hourly_rate") Upper Hourly Rate
            .m-t-1
              InputSelect.form-control_no-icon.m-t-1(v-model="project.hourly_payment_schedule" :errors="errors.hourly_payment_schedule" :options="hourlyPaymentScheduleOptions") Method of Payment

      .row.no-gutters
        .col-lg-6.m-t-2
          .d-flex
            button.btn.btn-default.float-left(v-if="prevEnabled" @click="prev")
              b-icon.mr-2(icon="chevron-left")
              | Previous
            button.btn.btn-link.m-r-1.ml-auto(@click="back") Exit
            button.btn.btn-default.m-r-1(v-if="saveDraftEnabled && !canSaveDraft" @click="toast('Error', 'Please enter title')") Save as Draft
            Post(v-else-if="saveDraftEnabled" :action="endpointUrl" :model="draftProject" :method="method" @saved="saved" @errors="errors = $event")
              button.btn.btn-default.m-r-1 Save as Draft
            button.btn.btn-dark(v-if="nextEnabled" @click="next") Next
              b-icon.ml-2(icon="chevron-right")
            Post(v-else :action="endpointUrl" :model="publishedProject" :method="method" @saved="saved" @errors="errors = $event")
              button.btn.btn-dark Submit
</template>

<script>
import WizardProgress from '@/common/WizardProgress'
import { redirectWithToast } from '@/common/Toast'
import {
  PRICING_TYPES,
  LOCATION_TYPES,
  SORT_INDUSTRIES,
  SORT_JURISDICTIONS,
  FIXED_PAYMENT_SCHEDULE_OPTIONS_FILTERED,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS_FILTERED,
  MINIMUM_EXPERIENCE_OPTIONS,
} from '@/common/ProjectInputOptions'

const REQUIRED = 'This field is required'
const STEPS = ['Project Details', 'Expertise', 'Budget']
const DEFAULT_TYPE = 'rfp'

const toOption = ({ id, name: label }) => ({ id, label })

const initialProject = (localProject) => ({
  // common defaults
  type: DEFAULT_TYPE,
  local_project_id: (localProject && localProject.id) || null,
  // 1
  title: (localProject && localProject.title) || null,
  starts_on: (localProject && localProject.starts_on) || null,
  ends_on: (localProject && localProject.ends_on) || null,
  description: (localProject && localProject.description) || null,
  role_details: null,
  industry_ids: [],
  jurisdiction_ids: [],
  location_type: null,
  location: null,
  // 2
  minimum_experience: null,
  only_regulators: null,
  skill_names: [],
  // 3
  pricing_type: PRICING_TYPES[0].id,
  est_budget: null,
  hourly_rate: null,
  fixed_payment_schedule: null,
  hourly_payment_schedule: null,
  status: null,
})

export default {
  props: {
    projectId: {
      type: Number
    },
    industryIds: {
      type: Array,
      required: true
    },
    jurisdictionIds: {
      type: Array,
      required: true
    },
    localProject: {
      type: Object
    }
  },
  data() {
    return {
      step: STEPS[0],
      project: initialProject(this.localProject),
      errors: {}
    }
  },
  methods: {
    inputSkills() {
      const e = document.getElementsByClassName('vue-treeselect__input')[0]
      e && (e.value = '')
    },
    comboboxProps(skills) {
      return {
        async: true,
        loadOptions: ({ action, searchQuery, callback }) => {
          if (action === 'ASYNC_SEARCH') {
            callback(null, [{ id: searchQuery, label: searchQuery }, ...skills])
          } else {
            callback(null, skills)
          }
        }
      }
    },
    loadProject(project) {
      this.project = Object.assign({}, this.project, project)
    },
    next() {
      if (this.nextEnabled) {
        if (this.preValidateStep()) {
          this.step = this.steps[1 + this.currentStep]
        }
      }
    },
    prev() {
      if (this.prevEnabled) {
        this.step = this.steps[this.currentStep - 1]
      }
    },
    cardClass(type, i) {
      return { 'border-dark': this.project.pricing_type === type.id, 'm-r-1': i === 0 }
    },
    preValidateStep() {
      this.errors = {}
      if (this.currentStep === 0) {
        ['title', 'description', 'role_details', 'starts_on', 'location_type'].map(f => {
          if (!this.project[f]) {
            this.errors[f] = [REQUIRED]
          }
        })
        if (this.isLocationVisible && !this.project.location) {
          this.errors.location = [REQUIRED]
        }
        ['industry_ids', 'jurisdiction_ids'].map(f => {
          if (!this.project[f].length) {
            this.errors[f] = [REQUIRED]
          }
        })
      } else if (this.currentStep === 1) {
        if (!this.project.minimum_experience) {
          this.errors.minimum_experience = [REQUIRED]
        }
      }
      return !Object.keys(this.errors).length
    },
    saved() {
      const redirectUrl = `/business/projects/${this.project.local_project_id || ''}`
      redirectWithToast(redirectUrl, 'The project has been saved')
    },
    getSkillOptions(skills) {
      return skills.map(({ name }) => ({ id: name, label: name }))
    }
  },
  computed: {
    draftProject() {
      return { ...this.project, status: 'draft' }
    },
    publishedProject() {
      const { status, ...result } = this.project
      return result
    },
    method() {
      return this.projectId ? 'PUT' : 'POST'
    },
    transformBackendModel() {
      const getColumn = (array, column) => array.map(i => i[column]),
        fromDecimal = val => +val || null
      return model => ({
        ...model,
        "skill_names":      getColumn(model.skills, 'name'),
        "industry_ids":     getColumn(model.industries, 'id'),
        "jurisdiction_ids": getColumn(model.jurisdictions, 'id'),
        "est_budget":       fromDecimal(model.est_budget),
        "only_regulators":  !!model.only_regulators,
      })
    },
    pageTitle() {
      return this.projectId ? 'Edit Project' : 'Post Project'
    },
    defaultProject() {
      return () => initialProject(this.localProject)
    },
    endpointUrl() {
      return '/api/business/projects/' + (this.projectId || '')
    },
    steps: () => STEPS,
    pricingTypes: () => PRICING_TYPES,
    locationTypes: () => LOCATION_TYPES,
    fixedPaymentScheduleOptions() {
      return FIXED_PAYMENT_SCHEDULE_OPTIONS_FILTERED(this.project.starts_on, this.project.ends_on)
    },
    hourlyPaymentScheduleOptions() {
      return HOURLY_PAYMENT_SCHEDULE_OPTIONS_FILTERED(this.project.starts_on, this.project.ends_on)
    },
    experienceOptions: () => MINIMUM_EXPERIENCE_OPTIONS,
    skillsOptions: () => ['SEC', 'Policy Writing', 'FINRA'].map(id => ({ id, label: id })),
    industryIdsOptions() {
      return SORT_INDUSTRIES(this.industryIds).map(toOption)
    },
    jurisdictionIdsOptions() {
      return SORT_JURISDICTIONS(this.jurisdictionIds).map(toOption)
    },
    currentStep() {
      return this.steps.indexOf(this.step)
    },
    nextEnabled() {
      return this.currentStep < this.steps.length - 1
    },
    prevEnabled() {
      return this.currentStep > 0
    },
    saveDraftEnabled() {
      return this.project.status !== 'published'
    },
    canSaveDraft() {
      return this.project.title && this.project.title.length
    },
    datepickerOptions() {
      return {
        min: new Date
      }
    },
    isLocationVisible() {
      return ['remote_and_travel', 'onsite'].includes(this.project.location_type)
    }
  },
  components: {
    WizardProgress
  }
}
</script>
