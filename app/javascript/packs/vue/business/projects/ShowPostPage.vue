<template lang="pug">
  .page
    Get(:project="url"): template(v-slot="{project}")
      .page-header
        .d-flex.flex-column
          Breadcrumbs.m-b-20(:items="['Project', project.title, 'Job Post']")
          h2.page-header__title.m-b-20
            //span.badge.badge-default.m-r-1(v-if="'draft' === project.status") Draft
            | {{ project.title }}
        .page-header__actions
          PostProjectModalDelete.m-t-auto.mb-0
            button.btn.btn-default Delete Post
      .card-body.white-card-body.card-body_full-height
        .row
          .col-lg-7.pr-lg-1
            .card
              .card-header
                h3.mb-0 Post Details
                router-link.btn.btn-default.float-right(:to='`/business/project_posts/${project.id}/edit`') Edit
              .card-body
                dl.row
                  dt.col-sm-4 Title
                  dd.col-sm-8 {{ project.title }}
                  dt.col-sm-4 Start Date
                  dd.col-sm-8 {{ project.starts_on | asDate }}
                  dt.col-sm-4 Due Date
                  dd.col-sm-8 {{ project.ends_on | asDate }}
                  dt.col-sm-4 Description
                  dd.col-sm-8 {{ project.description }}
                  dt.col-sm-4 Role Details
                  dd.col-sm-8 {{ project.role_details }}
                  dt.col-sm-4 Industry
                  dd.col-sm-8 {{ project.industries | names }}
                  dt.col-sm-4 Jurisdiction
                  dd.col-sm-8 {{ project.jurisdictions | names }}
                  dt.col-sm-4 Key Deliverables
                  dd.col-sm-8 {{ project.key_deliverables }}
                  dt.col-sm-4 Minimum Experience
                  dd.col-sm-8 {{ project.experience | capital }}
                  dt.col-sm-4 Former Regulator?
                  dd.col-sm-8 {{ project.regulators_only | yesNo }}
                  dt.col-sm-4 Skills
                  dd.col-sm-8 {{ project.skills | names }}
                  dt.col-sm-4 Estimated Budget
                  dd.col-sm-8 {{ (project.est_budget || project.fixed_budget) | usdWhole }}
                  dt.col-sm-4 Payment Schedule
                  dd.col-sm-8 {{ paymentScheduleReadable(project) }}
          .col-lg-5.pl-lg-1
            .card.applications
              .card-header: h3.mb-0 Applicants
              .card-body.applications__body.h-100: Get(:applications="applicationsUrl"): template(v-slot="{applications}")
                .d-flex.flex-column.justify-content-center.align-items-center.m-t-60(v-if="!applications.length")
                  ion-icon.applications__icon.m-b-10(name="person-circle-outline")
                  p.applications__text No Applicants
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
                        ProposalModal(v-bind="{ application, modalId, confirmModalId, projectId }")
                        DenyProposalConfirmModal(:application="application" :project-id="projectId" @back="goBack" @denied="denied")
                        AcceptDenyProposalModal(:id="confirmModalId" :application="application" @back="goBack" @saved="accepted")
</template>

<script>
import AcceptDenyProposalModal from './AcceptDenyProposalModal'
import DenyProposalConfirmModal from './DenyProposalConfirmModal'
import ProposalModal from './ProposalModal'
import { FIXED_PAYMENT_SCHEDULE_OPTIONS } from '@/common/ProjectInputOptions'
import { redirectWithToast } from '@/common/Toast'
import PostProjectModalDelete from "./modals/PostProjectModalDelete";

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
    deleted() {
      redirectWithToast('/business/projects', 'Project post deleted')
      this.$bvModal.hide('DeletePostModal')
    },
    denied(id) {
      redirectWithToast(this.$store.getters.url('URL_PROJECT_SHOW', id), 'Proposal denied.')
      this.$bvModal.hide(this.confirmModalId)
    },
    goBack() {
      this.$bvModal.hide(this.confirmModalId)
      this.$bvModal.hide('DenyProposalConfirm')
      this.$bvModal.show(this.modalId)
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
    confirmModalId() {
      return (this.modalId || '') + '_confirm'
    }
  },
  components: {
    PostProjectModalDelete,
    AcceptDenyProposalModal,
    DenyProposalConfirmModal,
    ProposalModal
  }
}
</script>

<style scoped>
.img-icon {
  max-height: 1.5em;
  max-width: 1.5em;
}
</style>
