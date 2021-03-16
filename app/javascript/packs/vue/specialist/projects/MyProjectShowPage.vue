<template lang="pug">
  Get(:project="projectUrl"): template(v-slot="{project}")
    Breadcrumbs(:items="['Projects', project.title]")
    h1 {{ project.title }}
    a.btn.btn-outline-dark.float-right(v-if="showTimesheetBtn(project)" :href="timesheetUrl") My Timesheet
    h3 {{ project.business.business_name }}
    b-tabs
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
</template>

<script>
export default {
  props: {
    id: {
      type: Number,
      required: true
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