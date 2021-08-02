<template lang="pug">
  .container
    .card.m-t-2
      .card-header
        .col-md-12
          h3 Create Proposal
      .card-header
        Get(:project='`/api/specialist/projects/${projectId}`' :callback="projectLoaded"): template(v-slot="{project}"): div.row.pl-3
          .col-md-6
            h3 Terms
            .row
              .col-sm: InputDate(v-model="form.starts_on" :errors="errors.starts_on") Start Date
              .col-sm: InputDate(v-model="form.ends_on" :errors="errors.ends_on") Due Date
            InputSelect.m-t-1(v-model="form.pricing_type" :errors="errors.pricing_type" :options="pricingTypesOptions") Pricing Type
            div(v-if="isFixedBudget")
              InputText.m-t-1(v-model="form.fixed_budget" :errors="errors.fixed_budget") Fixed Budget
              InputSelect.m-t-1(v-model="form.fixed_payment_schedule" :errors="errors.fixed_payment_schedule" :options="fixedPaymentScheduleOptions") Payment Schedule
            div(v-else)
              InputText.m-t-1(v-model="form.hourly_rate" :errors="errors.hourly_rate") Hourly Rate
              InputText.m-t-1(v-model="form.estimated_hours" :errors="errors.estimated_hours") Estimated Hours
              InputSelect.m-t-1(v-model="form.hourly_payment_schedule" :errors="errors.hourly_payment_schedule" :options="hourlyPaymentScheduleOptions") Payment Schedule
            hr
            h3 Role
            InputTextarea.m-t-1(v-model="form.role_details" :errors="errors.role_details" :rows="4") Role Details
            InputTextarea.m-t-1(v-model="form.key_deliverables" :errors="errors.key_deliverables" :rows="4") Key Deliverables
            h3.m-t-1 Attachments
            .card.m-b-1
              .card-body
                p Attach a cover letter, resume, or other document here. Limited to only one file.
                label
                  a.btn.btn-light Upload File
                  input.d-none(type="file" accept="application/pdf" @change="pickFile")
            .text-right
              a.m-r-1.btn(@click="back") Cancel
              a.m-r-1.btn.btn-default Save Draft
              // PostMultipart(:action="`/api/specialist/projects/${projectId}/applications`" :model="form" @errors="errors = $event" @saved="saved")
              Post(:action="`/api/specialist/projects/${projectId}/applications`" :model="form" @errors="errors = $event" @saved="saved")
                button.btn.btn-dark Submit Proposal
          .col-md-6
            .card
              ProjectDetails(:project="project")
</template>

<script>
import ProjectDetails from './ProjectDetails'
import { redirectWithToast } from '@/common/Toast'
import {
  PRICING_TYPES_OPTIONS,
  FIXED_PAYMENT_SCHEDULE_OPTIONS,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS,
  FIXED_PAYMENT_SCHEDULE_OPTIONS_FILTERED,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS_FILTERED,
} from '@/common/ProjectInputOptions'

const FIXED_BUDGET = Object.keys(PRICING_TYPES_OPTIONS)[0]
const HOURLY_RATE = Object.keys(PRICING_TYPES_OPTIONS)[1]

const initialForm = (project) => ({
  hourly_rate: null,
  starts_on: (project && project.starts_on) || null,
  ends_on: (project && project.ends_on ) || null,
  pricing_type: (project && calcPricingType(project)) || null,
  fixed_budget: (project && project.est_budget) || null,
  fixed_payment_schedule: (project && project.pricing_type == "fixed" && FIXED_PAYMENT_SCHEDULE_OPTIONS[project.payment_schedule]) || null,
  hourly_rate: (project && project.hourly_rate) || null,
  hourly_payment_schedule: (project && project.pricing_type == "hourly" && HOURLY_PAYMENT_SCHEDULE_OPTIONS[project.payment_schedule]) || null,
  estimated_hours: null,
  message: null,
  key_deliverables: null,
  role_details: null,
  document: null,
})
const calcPricingType = function(project) {
  if (project.pricing_type == "fixed") {
    return FIXED_BUDGET
  } else if (project.pricing_type == "hourly") {
    return HOURLY_RATE
  }
}

export default {
  props: {
    projectId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      form: initialForm(),
      errors: {}
    }
  },
  methods: {
    saved() {
      redirectWithToast('/specialist/my-projects/', 'Proposal sent')
    },
    pickFile(event) {
      this.form.document = event.target.files[0]
    },
    projectLoaded(payload) {
      Object.assign(this.form, initialForm(payload))
      return payload
    },
    calcPricingType
  },
  computed: {
    pricingTypesOptions: () => PRICING_TYPES_OPTIONS,
    fixedPaymentScheduleOptions() {
      return FIXED_PAYMENT_SCHEDULE_OPTIONS_FILTERED(this.form.starts_on, this.form.ends_on)
    },
    hourlyPaymentScheduleOptions() {
      return HOURLY_PAYMENT_SCHEDULE_OPTIONS_FILTERED(this.form.starts_on, this.form.ends_on)
    },
    isFixedBudget() {
      return FIXED_BUDGET === this.form.pricing_type
    },
  },
  components: {
    ProjectDetails
  }
}
</script>