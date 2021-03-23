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
      b-tab(title="Activity")
    b-tabs(v-else)
      b-tab(title="Overview")
        PropertiesTable(title="Post Details" :properties="overviewProps(project)")
      b-tab(title="Proposal")
        Get(:application="applicationUrl(project.id, applicationId)"): template(v-slot="{application}")
          PropertiesTable(title="Proposal" :properties="proposalProps(application)")
            button.btn.btn-outline-dark.float-right Edit
</template>

<script>
import { readablePaymentSchedule, fields } from '@/common/ProposalFields'

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
    proposalProps: fields,
    applicationUrl(projectId, applicationId) {
      return '/api/specialist/projects/' + projectId + '/applications/' + applicationId
    },
    getContracts() {
      return []
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
  }
}
</script>