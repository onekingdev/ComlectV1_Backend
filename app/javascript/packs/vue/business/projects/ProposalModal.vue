<template lang="pug">
  b-modal.fade(:id="modalId" title="View Proposal" no-stacking)
    .card
      .card-header
        SpecialistDetails(:specialist="application.specialist")
      .card-body.w-100
        ul.list-group.list-group-horizontal.mb-3.w-100
          li.list-group-item(v-if="application.pricing_type === 'fixed'")
            | Bid Price
            br
            | {{ application.fixed_budget | usdWhole }}
          li.list-group-item(v-else)
            | Hourly
            br
            | {{ application.hourly_rate | usdWhole }}
          li.list-group-item
            | Payment Schedule
            br
            | {{ paymentScheduleReadable(application) }}
          li.list-group-item
            | Jurisdiction
            br
            //- |
        dl.row
          dt.col-sm-3 Start Date
          dd.col-sm-9 {{ application.starts_on | asDate }}
          dt.col-sm-3 Due Date
          dd.col-sm-9 {{ application.ends_on | asDate }}
          dt.col-sm-3 Role Details
          dd.col-sm-9 {{ application.role_details }}
          dt.col-sm-3 Key Deliverables
          dd.col-sm-9 {{ application.key_deliverables }}
          dt.col-sm-3 Attachments
          dd.col-sm-9
    template(#modal-footer="{ ok, cancel, hide }")
      button.btn.btn-light(@click="hide") Close
      Post(v-if="!hasSpecialist(application.project)" :action="denyUrl(application.id)" :model="{}" @saved="denied(application.project.local_project_id)")
        button.btn.btn-outline-dark Deny Proposal
      button.btn.btn-dark(v-if="!hasSpecialist(application.project)" v-b-modal="confirmModalId") Accept Proposal
</template>

<script>
import SpecialistDetails from './SpecialistDetails'
import { redirectWithToast } from '@/common/Toast'
import { FIXED_PAYMENT_SCHEDULE_OPTIONS } from '@/common/ProjectInputOptions'

export default {
  props: {
    modalId: {
      type: String,
      required: true
    },
    confirmModalId: {
      type: String,
      required: true
    },
    projectId: {
      type: Number,
      required: true
    },
    application: {
      type: Object,
      required: true
    }
  },
  methods: {
    denyUrl(id) {
      return `/api/business/projects/${this.projectId}/applications/${id}/hide`
    },
    denied(id) {
      redirectWithToast(this.$store.getters.url('URL_PROJECT_SHOW', id), 'Proposal denied.')
      this.$bvModal.hide(this.confirmModalId)
    }
  },
  computed: {
    hasSpecialist: () => project => !!project.specialist_id,
    paymentScheduleReadable: () => application => FIXED_PAYMENT_SCHEDULE_OPTIONS[application.payment_schedule]
  },
  components: {
    SpecialistDetails
  }
}
</script>