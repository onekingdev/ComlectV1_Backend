<template lang="pug">
  div
    h2 Post Project
    p Tell us more about your project and get connected to our experienced specialists.
    WizardProgress(v-bind="{step,steps}")
    .row.no-gutters
      .col-md-6.p-t-2(v-if="step === steps[0]")

        label.form-label Title
        input.form-control(v-model="project.title" type=text)
        Errors(:errors="errors.title")

        b-row(no-gutters)
          .col-sm
            label.form-label Start Date
            DatePicker(v-model="project.starts_on")
            Errors(:errors="errors.starts_on")
          .col-sm
            label.form-label Due Date
            DatePicker(v-model="project.ends_on")
            Errors(:errors="errors.ends_on")

        label.form-label Description
        textarea.form-control(v-model="project.description" rows=3)
        Errors(:errors="errors.description")
        .form-text.text-muted Project post information for the specialist

        label.form-label Project Timing
        Dropdown(v-model="project.rfp_timing" :options="rfpTimingOptions")
        Errors(:errors="errors.rfp_timing")

        label.form-label Location Type
        Dropdown(v-model="project.location_type" :options="locationTypes")
        Errors(:errors="errors.location_type")

        label.form-label Location
        input.form-control(v-model="project.location" type=text)
        Errors(:errors="errors.location")

        label.form-label Industry
        ComboBox(v-model="project.industry_ids" :options="industryIdsOptions" :multiple="true")
        Errors(:errors="errors.industry_ids")

        label.form-label Jurisdiction
        ComboBox(v-model="project.jurisdiction_ids" :options="jurisdictionIdsOptions" :multiple="true")
        Errors(:errors="errors.jurisdiction_ids")

    .row.no-gutters
      .col-md-6.p-t-2(v-if="step === steps[1]")

        label.form-label Minimum Experience
        Dropdown(v-model="project.minimum_experience" :options="[1, 2, 3, 4, 5, 6, 7, 8, 9]")
        Errors(:errors="errors.minimum_experience")

        b-form-checkbox.m-y-1(v-model="project.only_regulators") Only former regulators
        Errors(:errors="errors.only_regulators")

        label.form-label Skills
        ComboBox(v-model="project.skill_selector" :options="skillsOptions" :multiple="true")
        Errors(:errors="errors.skill_selector")

    .row.no-gutters
      .col-md-6.p-t-2(v-if="step === steps[2]")

        b-row.no-gutters
          .card.col-sm.cursor-pointer(v-for="(type, i) in pricingTypes" :class="cardClass(type, i)" :key="i" @click="project.pricing_type = type.id")
            .card-body
              h5.card-title {{type.label}}
              p.card-text {{type.text}}

        .m-t-1(v-if="project.pricing_type === pricingTypes[0].id")
          label.form-label Estimated Budget
          input.form-control(v-model="project.est_budget" type=text)
          Errors(:errors="errors.est_budget")
          //- @todo $ prefixes in input

          label.form-label Method of Payment
          Dropdown(v-model="project.fixed_payment_schedule" :options="[]")
          Errors(:errors="errors.fixed_payment_schedule")

        .m-t-1(v-else)
          label.form-label Hourly Rate
          input.form-control(v-model="project.hourly_rate" type=text)
          Errors(:errors="errors.hourly_rate")
          //- @todo hourly rate: range (2 vals) instead of 1 field

          label.form-label Method of Payment
          Dropdown(v-model="project.hourly_payment_schedule" :options="['upon_completion', 'bi_weekly', 'monthly']")
          Errors(:errors="errors.hourly_payment_schedule")

    .row.no-gutters
      .col-md-6.text-right.m-t-1
        button.btn.m-r-1(@click.prevent) Exit
        button.btn.btn-dark.m-r-1(v-if="prevEnabled" @click="prev") Previous
        button.btn.btn-dark(v-if="nextEnabled" @click="next") Next
        button.btn.btn-dark(v-else @click="preValidateStep() && submit()") Submit
</template>

<script>
import WizardProgress from '@/common/WizardProgress'

const REQUIRED = 'This field is required'
const STEPS = ['Project Details', 'Expertise', 'Budget']
const PRICING_TYPES = [{
  id: 'fixed',
  label: 'Fixed Price',
  text: 'Budget-friendly approach for scoped projects.'
}, {
  id: 'hourly',
  label: 'Hourly Price',
  text: 'Pay by the hour. Provides more flexibility.'
}]
const LOCATION_TYPES = [{
  value: 'remote',
  text: 'Remote'
}, {
  value: 'remote_and_travel',
  text: 'Remote + Travel'
}, {
  value: 'onsite',
  text: 'Onsite'
}]
const RFP_TIMING_OPTIONS = [{
  value: 'asap', text: 'As soon as possible',
  value: 'two_weeks', text: 'Within the next 2 weeks',
  value: 'month', text: 'Within a month',
  value: 'not_sure', text: 'Not sure'
}]

const toOption = ({ id, name: label }) => ({ id, label })

const initialProject = () => ({
  // 1
  title: null,
  starts_on: null,
  ends_on: null,
  // details: null, @todo nonexistent field
  description: null,
  rfp_timing: null,
  industry_ids: [],
  jurisdiction_ids: [],
  location_type: null,
  location: null,
  // 2
  minimum_experience: null,
  only_regulators: null,
  skill_selector: [],
  // 3
  pricing_type: PRICING_TYPES[0].id,
  est_budget: null,
  hourly_rate: null,
  fixed_payment_schedule: null,
  hourly_payment_schedule: null,
})

export default {
  props: {
    industryIds: {
      type: Array,
      required: true
    },
    jurisdictionIds: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      step: STEPS[0],
      project: initialProject(),
      errors: {}
    }
  },
  methods: {
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
        ['title', 'description', 'starts_on', 'location_type'].map(f => {
          if (!this.project[f]) {
            this.errors[f] = [REQUIRED]
          }
        })
        if (this.project.location_type !== this.locationTypes[0].value && !this.project.location) {
          this.errors.location_type = [REQUIRED]
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
      } else {
        if (this.project.pricing_type === this.pricingTypes[0].id && !this.project.est_budget) {
          this.errors.est_budget = [REQUIRED]
        // } else if (!this.project.hou) {

        }
      }
      return !Object.keys(this.errors).length
    },
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    },
    submit() {
      this.errors = {}
      fetch('/api/business/projects', {
        method: 'POST',
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: JSON.stringify(this.project)
      }).then(response => {
        if (response.status === 422) {
          response.json().then(errors => {
            this.errors = errors
            Object.keys(this.errors)
              .map(prop => this.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
          })
        } else if (response.status === 201 || response.status === 200) {
          this.$emit('saved')
          this.makeToast('Success', 'The project has been saved')
          // this.resetProject()
        } else {
          this.makeToast('Error', 'Couldn\'t submit form')
        }
      })
    }
  },
  computed: {
    steps: () => STEPS,
    pricingTypes: () => PRICING_TYPES,
    locationTypes: () => LOCATION_TYPES,
    rfpTimingOptions: () => RFP_TIMING_OPTIONS,
    skillsOptions: () => ['SEC', 'Policy Writing', 'FINRA'].map(id => ({ id, label: id })),
    industryIdsOptions() {
      return this.industryIds.map(toOption)
    },
    jurisdictionIdsOptions() {
      return this.jurisdictionIds.map(toOption)
    },
    currentStep() {
      return this.steps.indexOf(this.step)
    },
    nextEnabled() {
      return this.currentStep < this.steps.length - 1
    },
    prevEnabled() {
      return this.currentStep > 0
    }
  },
  components: {
    WizardProgress
  }
}
</script>

<style scoped>
.cursor-pointer {
  cursor: pointer;
}
</style>