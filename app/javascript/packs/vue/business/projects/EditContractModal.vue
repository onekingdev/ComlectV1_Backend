<template lang="pug">
  div
    div(v-b-modal="'EditContractModal'"): slot
    b-modal(id="EditContractModal" title="Edit Contract")
      ModelLoader(:url="modalUrl" :default="initialForm" @loaded="loaded"): div.row
        .col-md-12
          h3 Terms
          .row
            .col-sm: InputDate(v-model="form.starts_on" :errors="errors.starts_on") Start Date
            .col-sm: InputDate(v-model="form.ends_on" :errors="errors.ends_on") Due Date
          div(v-if="isFixedBudget")
            InputText.m-t-1(v-model="form.fixed_budget" :errors="errors.fixed_budget" :disabled="disableFields(form)") Fixed Budget
          div(v-else)
            InputText.m-t-1(v-model="form.hourly_rate" :errors="errors.hourly_rate") Hourly Rate
            InputText.m-t-1(v-model="form.estimated_hours" :errors="errors.estimated_hours") Estimated Hours
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
        Post(v-if='isSpecialist' method="PUT" :action="`/api/projects/${projectId}/extension/12`" :model="form" @errors="errors = $event" @saved="saved")
          button.btn.btn-dark Accept
        Post(v-else method="POST" :action="`/api/projects/${projectId}/extension`" :model="form" @errors="errors = $event" @saved="saved")
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
  extension: null
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
    proposal: {
      type: Object
    },
    isSpecialist: {
      type: Boolean,
      required: false
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
      console.log(result)
      this.form = this.isSpecialist ? result.extension : result
    },
    disableFields(extension) {
      console.log(extension)
      return extension.requester.indexOf("Business") === 0
      /*if (this.isSpecialist) {
        this.form.map(disable_all)
        $("input textarea").attr("disabled", true)
      }*/
    },
    initialForm,
    calcPricingType
  },
  computed: {
    pricingTypesOptions: () => PRICING_TYPES_OPTIONS,
    fixedPaymentScheduleOptions: () => FIXED_PAYMENT_SCHEDULE_OPTIONS,
    hourlyPaymentScheduleOptions: () => HOURLY_PAYMENT_SCHEDULE_OPTIONS,
    isFixedBudget() {
      return this.form.hourly_rate == null
    },
    modalUrl() {
      return this.isSpecialist ? `/api/specialist/projects/${this.projectId}` : `/api/business/projects/${this.projectId}`
    }
    //this.data.form = initialForm(this.proposal)
  },
  components: {
    ProjectDetails
  }
}
</script>