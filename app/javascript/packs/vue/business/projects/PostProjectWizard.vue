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

        label.form-label Industry
        Dropdown(v-model="project.industry_ids" :options="industryIdsOptions")
        Errors(:errors="errors.industry_ids")

        label.form-label Jurisdiction
        Dropdown(v-model="project.jurisdiction_ids" :options="jurisdictionIdsOptions")
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
          .card.col-sm.cursor-pointer(v-for="(type, i) in pricingTypes" :class="cardClass(type, i)" :key="i" @click="project.pricing_type = type.label")
            .card-body
              h5.card-title {{type.label}}
              p.card-text {{type.text}}

        .m-t-1(v-if="project.pricing_type === pricingTypes[0].label")
          label.form-label Estimated Budget
          input.form-control(v-model="project.fixed_budget" type=text)
          Errors(:errors="errors.fixed_budget")
          //- @todo $ prefixes in input

          label.form-label Method of Payment
          Dropdown(v-model="project.fixed_payment_schedule" :options="[]")
          Errors(:errors="errors.fixed_payment_schedule")

        div(v-else)
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
        button.btn.btn-dark(v-else @click="submit") Submit
</template>

<script>
import WizardProgress from '@/common/WizardProgress'

const REQUIRED = 'This field is required'
const STEPS = ['Project Details', 'Expertise', 'Budget']
const PRICING_TYPES = [{
  label: 'Fixed Price',
  text: 'Budget-friendly approach for scoped projects.'
}, {
  label: 'Hourly Price',
  text: 'Pay by the hour. Provides more flexibility.'
}]

const toOption = () => ({ id: value, name: text }) => ({ value, text })

const initialProject = () => ({
  // 1
  title: null,
  starts_on: null,
  ends_on: null,
  // details: null, @todo nonexistent field
  description: null,
  industry_ids: [],
  jurisdiction_ids: [],
  // 2
  minimum_experience: null,
  only_regulators: null,
  skill_selector: [],
  // 3
  pricing_type: PRICING_TYPES[0].label,
  fixed_budget: null,
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
      return { 'border-dark': this.project.pricing_type === type.label, 'm-r-1': i === 0 }
    },
    preValidateStep() {
      this.errors = {}
      if (this.currentStep === 0) {
        ['title', 'starts_on'].map(f => {
          if (!this.project[f]) {
            this.errors[f] = [REQUIRED]
          }
        });
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
    skillsOptions: () => ['SEC', 'Policy Writing', 'FINRA'].map(id => ({ id, label: id })),
    industryIdsOptions() {
      return this.industryIds.map(toOption())
    },
    jurisdictionIdsOptions() {
      return this.jurisdictionIds.map(toOption())
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