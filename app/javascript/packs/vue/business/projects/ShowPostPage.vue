<template lang="pug">
  Get(:project="url"): template(v-slot="{project}")
    .container
      .row.p-x-1
        .col-md-12.p-t-3
          Breadcrumbs(:items="['Project', project.title, 'Job Post']")
        .col-md-12.d-flex.justify-content-between.p-b-1.m-t-2
          div
            h2
              span.badge.badge-default.m-r-1(v-if="'draft' === project.status") Draft
              | {{ project.title }}
          div
            button.btn.btn-outline-dark.float-right(v-b-modal="'DeletePostModal'") Delete Post
            b-modal#DeletePostModal.fade(title="Delete Post")
              | Do you want to delete project post?
              template(#modal-footer="{hide}")
                button.btn.btn-default(@click="hide") Cancel
                Delete(:url="url" @deleted="deleted")
                  button.btn.btn-dark Delete
    .white-card-body.p-y-1
      .container
        .row.p-x-1
          .col-sm-6
            .card
              .card-header
                a.btn.btn-outline-dark.float-right(:href="`/business/project_posts/${project.id}/edit`") Edit
                h3 Post Details
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
                  dd.col-sm-9 {{ project.experience | capital }}
                  dt.col-sm-3 Former Regulator?
                  dd.col-sm-9 {{ project.regulators_only | yesNo }}
                  dt.col-sm-3 Skills
                  dd.col-sm-9 {{ project.skills | names }}
                  dt.col-sm-3 Estimated Budget
                  dd.col-sm-9 {{ (project.est_budget || project.fixed_budget) | usdWhole }}
                  dt.col-sm-3 Payment Schedule
                  dd.col-sm-9 {{ paymentScheduleReadable(project) }}
          .col-sm-6
            .card
              .card-header: h3 Applicants
              .card-body: Get(:applications="applicationsUrl"): template(v-slot="{applications}")
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
                            button.btn.btn-outline-dark(v-if="!hasSpecialist(application.project)" @click="denyProposal") Deny Proposal
                            button.btn.btn-dark(v-if="!hasSpecialist(application.project)" v-b-modal="confirmModalId") Accept Proposal
                        b-modal.fade(:id="confirmModalId" title="Accept Proposal")
                          p Please confirm the applicant you wish to hire.
                          .card
                            .card-body
                              SpecialistDetails(:specialist="application.specialist")
                              InputSelect(v-model="specialist_role" :options="specialistRoleOptions") Select Role
                              .form-text.text-muted Determines the permissions the specialist will have access to
                          template(#modal-footer="{ ok, cancel, hide }")
                            button.btn.btn-light(@click="hide") Cancel
                            button.btn.btn-outline-dark(@click="goBack") Go Back
                            Post(:action="hireUrl + '?job_application_id=' + application.id" :model="{specialist_role}" @saved="saved(project.local_project_id)")
                              button.btn.btn-dark Confirm
</template>

<script>
import SpecialistDetails from './SpecialistDetails'
import {
  FIXED_PAYMENT_SCHEDULE_OPTIONS,
  SPECIALIST_ROLE_OPTIONS,
} from '@/common/ProjectInputOptions'
import { redirectWithToast } from '@/common/Toast'

export default {
  props: {
    projectId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      modalId: null,
      specialist_role: Object.keys(SPECIALIST_ROLE_OPTIONS)[0]
    }
  },
  created() {
    this.modalId = 'modal_' + Math.random().toFixed(9) + Math.random().toFixed(7)
  },
  methods: {
    saved(id) {
      redirectWithToast(this.$store.getters.url('URL_PROJECT_SHOW', id), 'Specialist added to project.')
      this.$bvModal.hide(this.confirmModalId)
    },
    deleted() {
      redirectWithToast('/business/projects', 'Project post deleted')
      this.$bvModal.hide('DeletePostModal')
    },
    goBack() {
      this.$bvModal.hide(this.confirmModalId)
      this.$bvModal.show(this.modalId)
    },
    denyProposal() {
    }
  },
  computed: {
    url() {
      return this.$store.getters.url('URL_API_PROJECT', this.projectId)
    },
    applicationsUrl() {
      return this.$store.getters.url('URL_API_PROJECT_APPLICATIONS', this.projectId)
    },
    hireUrl() {
      return this.$store.getters.url('URL_API_PROJECT_HIRES', this.projectId)
    },
    paymentScheduleReadable: () => application => FIXED_PAYMENT_SCHEDULE_OPTIONS[application.payment_schedule],
    specialistRoleOptions: () => SPECIALIST_ROLE_OPTIONS,
    hasSpecialist: () => project => !!project.specialist_id,
    confirmModalId() {
      return (this.modalId || '') + '_confirm'
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