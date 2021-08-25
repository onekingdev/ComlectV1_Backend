<template lang="pug">
  b-modal.fade(:id="modalId" title="View Proposal" size="xl" no-stacking)
    .container: .row
      .col
        .card
          .card-header
            SpecialistDetails(:specialist="application.specialist")
          .card-body
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
              dt.col-sm-3 Attachment
              dd.col-sm-9(v-if="application.document")
                a(:href="attachmentUrl(application.document)" target="_blank") {{ application.document.metadata.filename }}
              dd.col-sm-9(v-else) -
      .col.ml-auto
        .card
          .card-header: h3 Messages
          .card-body: p
          .card-body
            b-form-textarea(placeholder="Make a comment or leave a note...")
    template(#modal-footer="{ ok, cancel, hide }")
      button.btn.btn-light(@click="hide") Close
      button.btn.btn-outline-dark(v-if="!hasSpecialist(application.project)" v-b-modal="'DenyProposalConfirm'") Deny Proposal
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
  computed: {
    hasSpecialist: () => project => !!project.specialist_id,
    paymentScheduleReadable: () => application => FIXED_PAYMENT_SCHEDULE_OPTIONS[application.payment_schedule],
    attachmentUrl: () => document => `/uploads/${document.storage}/${document.id}`
  },
  components: {
    SpecialistDetails
  }
}
</script>