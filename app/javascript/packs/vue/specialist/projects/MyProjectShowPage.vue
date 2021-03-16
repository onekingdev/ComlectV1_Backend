<template lang="pug">
  Get(:project="projectUrl"): template(v-slot="{project}")
    Breadcrumbs(:items="['Projects', project.title]")
    h1 {{ project.title }}
    a.btn.btn-outline-dark.float-right(v-if="showTimesheetBtn(project)" :href="timesheetUrl") My Timesheet
    h3 {{ project.business.business_name }}
    b-tabs(v-if="isApproved(project)")
      b-tab(title="Overview" active)
        .row
          .col-sm
            .card
              .card-header Project Details
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
          .col-sm
            .card
              .card-header Collaborators
              .card-body
                table.table
                  thead
                    tr
                      th Name
                      th
                  tbody
                    tr
                      td
                      td
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
</template>

<script>
import {
  FIXED_PAYMENT_SCHEDULE_OPTIONS,
  HOURLY_PAYMENT_SCHEDULE_OPTIONS
} from '@/common/ProjectInputOptions'

const readablePaymentSchedule = value => ({
  ...FIXED_PAYMENT_SCHEDULE_OPTIONS,
  ...HOURLY_PAYMENT_SCHEDULE_OPTIONS
}[value])

const overviewProps = project => {
  return [{ name: 'Owner', value: project.business && project.business.business_name },
    { name: 'Title', value: project.title },
    { name: 'Start Date', value: project.starts_on, filter: 'asDate' },
    { name: 'Due Date', value: project.ends_on, filter: 'asDate' },
    { name: 'Description', value: project.description },
    { name: 'Role Details', value: project.role_details },
    { name: 'Industry', value: project.industries, filter: 'names' },
    { name: 'Jurisdiction', value: project.jurisdictions, filter: 'names' },
    { name: 'Minimum Experience', value: project.minimum_experience },
    { name: 'Former Regulator?', value: project.only_regulators, filter: 'yesNo' },
    { name: 'Skills', value: project.skills, filter: 'names' },
    {
      name: project.pricing_type === 'fixed' ? 'Estimated Budget' : 'Hourly Rate',
      value: project.pricing_type === 'fixed' ? project.est_budget : project.hourly_rate,
      filter: 'usdWhole'
    },
    { name: 'Payment Schedule', value: readablePaymentSchedule(project.payment_schedule) }]
}

const proposalProps = proposal => [
  { name: 'Start Date', value: proposal.starts_on, filter: 'asDate' },
  { name: 'Due Date', value: proposal.ends_on, filter: 'asDate' },
  {
    name: proposal.pricing_type === 'fixed' ? 'Bid Price' : 'Hourly Rate',
    value: proposal.pricing_type === 'fixed' ? proposal.fixed_budget : proposal.hourly_rate,
    filter: 'usdWhole'
  },
  { name: 'Payment Schedule', value: readablePaymentSchedule(proposal.payment_schedule) },
  { name: 'Role Details', value: proposal.role_details },
  { name: 'Key Deliverables', value: proposal.key_deliverables },
  { name: 'Attachments', value: '' },
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
  methods: {
    isApproved(project) {
      return this.specialistId === project.specialist_id
    },
    overviewProps,
    proposalProps,
    applicationUrl(projectId, applicationId) {
      return '/api/specialist/projects/' + projectId + '/applications/' + applicationId
    }
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