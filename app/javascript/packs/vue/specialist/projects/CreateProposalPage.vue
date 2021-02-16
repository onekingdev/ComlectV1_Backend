<template lang="pug">
  .container
    .card
      .card-body
        h2 Create Proposal
        Get(:project='`/api/specialist/projects/${projectId}`'): template(v-slot="{project}"): div.row
          .col-sm
            h3 Terms
            .row
              .col-sm: InputDate(v-model="form.starts_on" :errors="errors.starts_on") Start Date
              .col-sm: InputDate(v-model="form.ends_on" :errors="errors.ends_on") Due Date
            InputSelect(v-model="form.pricing_type" :errors="errors.pricing_type" :options="pricingTypesOptions") Pricing Type
            div(v-if="isFixedBudget")
              InputText(v-model="form.fixed_budget" :errors="errors.fixed_budget") Fixed Budget
              InputSelect(v-model="form.payment_schedule" :errors="errors.payment_schedule" :options="fixedPaymentScheduleOptions") Payment Schedule
            div(v-else)
              InputText(v-model="form.hourly_rate" :errors="errors.hourly_rate") Hourly Rate
              InputText(v-model="form.estimated_hours" :errors="errors.estimated_hours") Estimated Hours
              InputSelect(v-model="form.payment_schedule" :errors="errors.payment_schedule" :options="hourlyPaymentScheduleOptions") Payment Schedule
            hr
            h3 Role
            InputTextarea(v-model="form.role_details" :errors="errors.role_details" :rows="4") Role Details
            InputTextarea(v-model="form.key_deliverables" :errors="errors.key_deliverables" :rows="4") Key Deliverables
            h3 Attachments
            .card
              .card-body
                p
                  | Drop files here or
                  a.btn.btn-light Upload Files
            a.btn Cancel
            a.btn.btn-light Save Draft
            Post(:action="`/api/specialist/projects/${projectId}/applications`" :model="form" @errors="errors = $event" @saved="() => {}")
              button.btn.btn-dark Submit Proposal
          .col-sm
            ProjectDetails(:project="project")
</template>

<script>
import ProjectDetails from './ProjectDetails'
import {
  PRICING_TYPES_OPTIONS,
  FIXED_PAYMENT_SCHEDULE_OPTIONS,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS
} from '@/common/ProjectInputOptions'

const FIXED_BUDGET = Object.keys(PRICING_TYPES_OPTIONS)[0]

const initialForm = () => ({
  hourly_rate: null,
  starts_on: null,
  ends_on: null,
  pricing_type: FIXED_BUDGET,
  fixed_budget: null,
  payment_schedule: null,
  hourly_rate: null,
  estimated_hours: null,
  message: null,
  key_deliverables: null,
  role_details: null,
})

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
  computed: {
    pricingTypesOptions: () => PRICING_TYPES_OPTIONS,
    fixedPaymentScheduleOptions: () => FIXED_PAYMENT_SCHEDULE_OPTIONS,
    hourlyPaymentScheduleOptions: () => HOURLY_PAYMENT_SCHEDULE_OPTIONS,
    isFixedBudget() {
      return FIXED_BUDGET === this.form.pricing_type
    },
  },
  components: {
    ProjectDetails
  }
}
</script>