<template lang="pug">
  div
    button.btn.btn-outline-dark(v-b-modal="'EditProposalModal'") Edit
    b-modal(id="EditProposalModal" title="Edit Proposal")
      ModelLoader(:url='`/api/specialist/projects/${projectId}/applications/${applicationId}`' :default="initialForm" @loaded="loaded"): div.row
        .col-md-12
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
              p
                | Drop files here or
                a.btn.btn-light Upload Files
      template(#modal-footer="{ hide }")
        a.m-r-1.btn(@click="hide") Cancel
        Post(method="PUT" :action="`/api/specialist/projects/${projectId}/applications/${applicationId}`" :model="form" @errors="errors = $event" @saved="saved")
          button.btn.btn-dark Resubmit
</template>

<script>
import ProjectDetails from './ProjectDetails'
import { redirectWithToast } from '@/common/Toast'
import {
  PRICING_TYPES_OPTIONS,
  FIXED_PAYMENT_SCHEDULE_OPTIONS,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS
} from '@/common/ProjectInputOptions'

const FIXED_BUDGET = Object.keys(PRICING_TYPES_OPTIONS)[0]
const HOURLY_RATE = Object.keys(PRICING_TYPES_OPTIONS)[1]

const initialForm = (project) => ({
  starts_on: (project && project.starts_on) || null,
  ends_on: (project && project.ends_on ) || null,
  pricing_type: (project && calcPricingType(project)) || null,
  fixed_budget: (project && project.est_budget) || null,
  fixed_payment_schedule: (project && project.pricing_type == "fixed" && FIXED_PAYMENT_SCHEDULE_OPTIONS[project.payment_schedule]) || null,
  hourly_rate: (project && project.hourly_rate) || null,
  hourly_payment_schedule: (project && project.pricing_type == "hourly" && HOURLY_PAYMENT_SCHEDULE_OPTIONS[project.payment_schedule]) || null,
  estimated_hours: null,
  key_deliverables: null,
  role_details: null,
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
    },
    project: {
      type: Object
    },
    applicationId: {
      type: Number,
      required: true
    },
    proposal: {
      type: Object
    }
  },
  data() {
    return {
      form: initialForm(this.proposal),
      errors: {}
    }
  },
  methods: {
    saved() {
      redirectWithToast(this.$store.getters.url('URL_MY_PROJECT_SHOW', ''), 'Proposal sent')
    },
    loaded(result) {
      this.form = result
    },
    initialForm,
    calcPricingType
  },
  computed: {
    pricingTypesOptions: () => PRICING_TYPES_OPTIONS,
    fixedPaymentScheduleOptions: () => FIXED_PAYMENT_SCHEDULE_OPTIONS,
    hourlyPaymentScheduleOptions: () => HOURLY_PAYMENT_SCHEDULE_OPTIONS,
    isFixedBudget() {
      return FIXED_BUDGET === this.form.pricing_type
    },
    //this.data.form = initialForm(this.proposal)
  },
  components: {
    ProjectDetails
  }
}
</script>