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
                p(v-if="!applications.length")
                  | No Applicants to Display
                  br
                  img(src='@/assets/no-applicants.svg' style="width: 100%; max-width: 300px")
                table.table(v-else)
                  thead
                    tr
                      th
                        | Name
                        b-icon.ml-2(icon='chevron-expand')
                      th
                  tbody
                    tr(v-for="application in applications" :key="application.id")
                      td
                        .d-flex.align-items-center
                        UserAvatar.mr-2(:user="application.specialist")
                        | {{ application.specialist.first_name }} {{ application.specialist.last_name }}
                      td.align-middle
                        .d-flex.align-items-center.justify-content-end
                          a.link(href="#" @click.prevent v-b-modal="modalId")
                            b-icon.mr-2(icon="search")
                            | View
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
                        AcceptDenyProposalModal(:id="confirmModalId" :application="application" @back="goBack" @saved="accepted")
</template>

<script>
import SpecialistDetails from './SpecialistDetails'
import AcceptDenyProposalModal from './AcceptDenyProposalModal'
import { FIXED_PAYMENT_SCHEDULE_OPTIONS } from '@/common/ProjectInputOptions'
import { redirectWithToast } from '@/common/Toast'

const TOKEN = localStorage.getItem('app.currentUser.token') ? JSON.parse(localStorage.getItem('app.currentUser.token')) : ''

export default {
  props: {
    projectId: {
      type: Number,
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
    accepted(id, role) {

      fetch(`/api/business/specialist_roles/${id}`, {
        method: 'PATCH',
        headers: { 'Authorization': `${TOKEN}`,  'Accept': 'application/json',  'Content-Type': 'application/json' },
        body: JSON.stringify({ "specialist": { "role": `${role}` } })
      })
        .then(response => response.json())
        .then(result => console.log(result))
        .catch(error => console.error(error))

      redirectWithToast(this.$store.getters.url('URL_PROJECT_SHOW', id), 'Specialist added to project.')
      this.$bvModal.hide(this.confirmModalId)
    },
    denied(id) {
      redirectWithToast(this.$store.getters.url('URL_PROJECT_SHOW', id), 'Proposal denied.')
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
    denyUrl(id) {
      return `/api/business/projects/${this.projectId}/applications/${id}/hide`
    }
  },
  computed: {
    url() {
      return this.$store.getters.url('URL_API_PROJECT', this.projectId)
    },
    applicationsUrl() {
      return this.$store.getters.url('URL_API_PROJECT_APPLICATIONS', this.projectId)
    },
    paymentScheduleReadable: () => application => FIXED_PAYMENT_SCHEDULE_OPTIONS[application.payment_schedule],
    hasSpecialist: () => project => !!project.specialist_id,
    confirmModalId() {
      return (this.modalId || '') + '_confirm'
    }
  },
  components: {
    AcceptDenyProposalModal,
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
