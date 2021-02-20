<template lang="pug">
  .row
    .col-sm
      .card
        .card-header
          | Post Details
          a.btn.btn-outline-dark(href="#") Edit
        .card-body
          dl.row
            dt.col-sm-3 Title
            dd.col-sm-9 {{ project.title }}
            dt.col-sm-3 Start Date
            dd.col-sm-9 {{ project.starts_on | asDate }}
            dt.col-sm-3 Due Date
            dd.col-sm-9 {{ project.ends_on | asDate }}
            dt.col-sm-3 Description
            dd.col-sm-9 {{ project.description }}
            dt.col-sm-3 Role Details
            dd.col-sm-9 {{ project.role_details }}
            dt.col-sm-3 Industry
            dd.col-sm-9 {{ project.industries | names }}
            dt.col-sm-3 Jurisdiction
            dd.col-sm-9 {{ project.jurisdictions | names }}
            dt.col-sm-3 Key Deliverables
            dd.col-sm-9 {{ project.key_deliverables }}
            dt.col-sm-3 Minimum Experience
            dd.col-sm-9 {{ 'Year' | plural(project.minimum_experience) }}
            dt.col-sm-3 Former Regulator?
            dd.col-sm-9 {{ project.only_regulators | yesNo }}
            dt.col-sm-3 Skills
            dd.col-sm-9 {{ project.skills | names }}
            dt.col-sm-3 Estimated Budget
            dd.col-sm-9 {{ (project.est_budget || project.fixed_budget) | usdWhole }}
            dt.col-sm-3 Payment Schedule
            dd.col-sm-9 {{ paymentScheduleReadable(project) }}
    .col-sm
      .card
        .card-header Applicants
        .card-body
          p(v-if="!applications.length") No applicants
          table.table(v-else)
            thead
              tr
                th
                  | Name
                  img.img-icon(src='@/assets/svg_example.svg')
                th
            tbody
              tr(v-for="application in applications" :key="application.id")
                td
                  UserAvatar(:user="application.specialist")
                  | {{ application.specialist.first_name }} {{ application.specialist.last_name }}
                td
                  a(href="#" @click.prevent v-b-modal="modalId")
                    img.img-icon(src='@/assets/magnifier.svg')
                    | View
                  b-modal.fade(:id="modalId" title="View Proposal" no-stacking)
                    .card
                      .card-header
                        SpecialistDetails(:specialist="application.specialist")
                      .card-body
                        ul.list-group.list-group-horizontal
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
                      button.btn.btn-outline-dark(@click="denyProposal") Deny Proposal
                      button.btn.btn-dark(v-if="!hasSpecialist(application.project)" v-b-modal="confirmModalId") Accept Proposal
                  b-modal.fade(:id="confirmModalId" title="Accept Proposal")
                    p Please confirm the applicant you wish to hire.
                    .card
                      .card-body
                        SpecialistDetails(:specialist="application.specialist")
                    template(#modal-footer="{ ok, cancel, hide }")
                      button.btn.btn-light(@click="hide") Cancel
                      button.btn.btn-outline-dark(@click="goBack") Go Back
                      Post(:action="hireUrl + '?job_application_id=' + application.id" :model="{}" @saved="saved")
                        button.btn.btn-dark Confirm
</template>

<script>
import { FIXED_PAYMENT_SCHEDULE_OPTIONS } from '@/common/ProjectInputOptions'
import SpecialistDetails from './SpecialistDetails'

export default {
  props: {
    applications: {
      type: Array,
      required: true
    },
    project: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      modalId: null
    }
  },
  created() {
    this.modalId = 'modal_' + Math.random().toFixed(9) + Math.random().toFixed(7)
  },
  methods: {
    saved() {
      this.$bvToast.toast('Specialist added to project.', { title: 'Success', autoHideDelay: 5000 })
      this.$bvModal.hide(this.confirmModalId)
    },
    goBack() {
      this.$bvModal.hide(this.confirmModalId)
      this.$bvModal.show(this.modalId)
    },
    denyProposal() {
    }
  },
  computed: {
    paymentScheduleReadable: () => application => FIXED_PAYMENT_SCHEDULE_OPTIONS[application.payment_schedule],
    hasSpecialist: () => project => !!project.specialist_id,
    confirmModalId() {
      return (this.modalId || '') + '_confirm'
    },
    hireUrl() {
      return this.$store.getters.url('URL_API_PROJECT_HIRES', this.project.id)
    }
  },
  components: {
    SpecialistDetails
  }
}
</script>

<style scoped>
.img-icon {
  max-height: 1.5em;
  max-width: 1.5em;
}
</style>