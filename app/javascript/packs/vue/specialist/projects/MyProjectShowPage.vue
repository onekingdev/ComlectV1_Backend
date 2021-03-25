<template lang="pug">
  Get(:project="projectUrl"): template(v-slot="{project}")
    CommonHeader(:title="project.title" :sub="project.business.business_name" :breadcrumbs="['Projects', project.title]")
      a.btn.btn-outline-dark.float-right(v-if="showTimesheetBtn(project)" :href="timesheetUrl") My Timesheet
    b-tabs(v-if="isApproved(project)" v-model="tab" content-class="mt-0")
      b-tab(title="Overview")
        .white-card-body.p-y-1
          .container
            .row.p-x-1
              .col-md-7.col-sm-12
                PropertiesTable(title="Project Details" :properties="acceptedOverviewProps(project)")
              .col-md-5.col-sm-12.pl-0
                .card
                  .card-header.d-flex.justify-content-between
                    h3.m-y-0 Collaborators
                    button.btn.btn-default(@click="viewContract()") View All
                  .card-body
                    table.rating_table
                      tbody
                        tr(v-for="contract in getContracts(project)" :key="contract.specialist.id")
                          td
                            img.m-r-1.userpic_small(v-if="contract.specialist.photo" :src="contract.specialist.photo")
                            b {{ contract.specialist.first_name }} {{ contract.specialist.last_name }},
                            |  Specialist
                          td
                            b-dropdown.float-right(text="..." variant="default")
                              b-dropdown-item(@click="viewContract(contract)") View Contract
      b-tab(title="Tasks")
      b-tab(title="Documents")
      b-tab(title="Collaborators")
        .white-card-body.p-y-1
          .container
            .row.p-x-1
              .col-sm-12
                .card(v-if="!showingContract")
                  .card-header.d-flex.justify-content-between
                    h3.m-y-0 Collaborators
                  .card-body
                    table.rating_table
                      tbody
                        tr(v-for="contract in getContracts(project)" :key="contract.specialist.id")
                          td
                            button.btn.btn-default.float-right(@click="showingContract = contract") View Contract
                            img.m-r-1.userpic_small(v-if="contract.specialist.photo" :src="contract.specialist.photo")
                            b {{ contract.specialist.first_name }} {{contract.specialist.last_name }},
                            |  Specialist
                          td
                div(v-else)
                  .row: .col-sm-12
                    button.btn.btn-dark.float-right(v-b-modal.EndContractModal) End Contract
                      b-modal.fade(id="EndContractModal" title="End Contract")
                        p ℹ️ Ending this contract will remove you as a collaborator to the project, revoke any permissions granted due to the project, and payout the full contract price.
                        p: b Do you want to continue?
                        .card
                          .card-header
                            .row
                              .col-sm
                                img.m-r-1.userpic_small(v-if="showingContract.specialist.photo" :src="showingContract.specialist.photo")
                                h3 {{ showingContract.specialist.first_name }} {{showingContract.specialist.last_name }}
                                p Specialist
                              .col-sm
                                span.float-right Outstanding Due <br> {{ 500 | usdWhole }}
                          .card-header
                            p
                              b Project name
                              span.float-right {{ showingContract.title }}
                            p
                              b Payment method
                              span.float-right {{ readablePaymentSchedule(showingContract.payment_schedule) }}
                            p
                              b Date Issued
                              span.float-right
                            p
                              b Payment Method
                              span.float-right Transfer to Visa
                          .card-header
                            p.text-right.text-muted *Transactional fees lorem ipsum dolor.
                        template(slot="modal-footer")
                          button.btn(@click="$bvModal.hide('EndContractModal')") Cancel
                          Post(:action="completeUrl(showingContract)" :model="{}" @saved="completeSuccess" @errors="completeErrors")
                            button.btn.btn-dark.m-r-1 Confirm
                    Breadcrumbs.m-y-1(:items="['Collaborators', `${showingContract.specialist.first_name} ${showingContract.specialist.last_name}`]")
                  .row
                    .col-sm-12
                      PropertiesTable(title="Contract Details" :properties="proposalProps(showingContract)")
      b-tab(title="Activity")
    b-tabs(v-else)
      b-tab(title="Overview")
        .white-card-body.p-y-1
          .container
            .row.p-x-1
              .col-md-12
                PropertiesTable(title="Post Details" :properties="overviewProps(project)")
      b-tab(title="Proposal")
        .white-card-body.p-y-1
          .container
            .row.p-x-1
              .col-md-12
                Get(:application="applicationUrl(project.id, applicationId)"): template(v-slot="{application}")
                  PropertiesTable(title="Proposal" :properties="proposalProps(application)")
                    EditProposalModal(:project-id="project.id" :application-id="applicationId")
                      button.btn.btn-outline-dark.float-right Edit
</template>

<script>
import { readablePaymentSchedule, fields } from '@/common/ProposalFields'
import EditProposalModal from '@/specialist/projects/EditProposalModal'

const overviewProps = project => {
  return [{ name: 'Owner', value: project.business && project.business.business_name },
    { name: 'Title', value: project.title },
    { name: 'Start Date', value: project.starts_on, filter: 'asDate' },
    { name: 'Due Date', value: project.ends_on, filter: 'asDate' },
    { name: 'Description', value: project.description },
    { name: 'Role Details', value: project.role_details },
    { name: 'Industry', value: project.industries, filter: 'names' },
    { name: 'Jurisdiction', value: project.jurisdictions, filter: 'names' },
    { name: 'Minimum Experience', value: project.minimum_experience, filter: 'capital' },
    { name: 'Former Regulator?', value: project.only_regulators, filter: 'yesNo' },
    { name: 'Skills', value: project.skills, filter: 'names' },
    {
      name: project.pricing_type === 'fixed' ? 'Estimated Budget' : 'Hourly Rate',
      value: project.pricing_type === 'fixed' ? project.est_budget : project.hourly_rate,
      filter: 'usdWhole'
    },
    { name: 'Payment Schedule', value: readablePaymentSchedule(project.payment_schedule) }]
}

const acceptedOverviewProps = project => [
  { name: 'Title', value: project.title },
  { name: 'Start Date', value: project.starts_on, filter: 'asDate' },
  { name: 'Due Date', value: project.ends_on, filter: 'asDate' },
  { name: 'Description', value: project.description },
  { name: 'Role Details', value: project.role_details },
]

export default {
  props: {
    id: {
      type: Number,
      required: true
    },
    specialistId: {
      type: Number,
      required: true
    },
    applicationId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      tab: 0,
      showingContract: null
    }
  },
  methods: {
    isApproved(project) {
      return this.specialistId === project.specialist_id
    },
    overviewProps,
    acceptedOverviewProps,
    readablePaymentSchedule,
    proposalProps: fields,
    applicationUrl(projectId, applicationId) {
      return '/api/specialist/projects/' + projectId + '/applications/' + applicationId
    },
    completeUrl(project) {
      return '/api/projects/' + project.id + '/end'
    },
    getContracts(project) {
      return [project]
    },
    completeSuccess() {
      this.$bvModal.hide('EndContractModal')
      this.$bvToast.toast('Project End has been requested', { title: 'Success', autoHideDelay: 5000 })
    },
    completeErrors(errors) {
      errors.length && this.$bvToast.toast('Cannot request End project', { title: 'Error', autoHideDelay: 5000 })
    },
    viewContract(collaborator) {
      this.tab = 3
      this.showingContract = collaborator || null
    },
  },
  computed: {
    projectUrl() {
      return this.$store.getters.url('URL_API_MY_PROJECT', this.id)
    },
    timesheetUrl() {
      return this.$store.getters.url('URL_PROJECT_TIMESHEET', this.id)
    },
    showTimesheetBtn() {
      return project => 'hourly' === project.pricing_type
    }
  },
  components: {
    EditProposalModal
  }
}
</script>