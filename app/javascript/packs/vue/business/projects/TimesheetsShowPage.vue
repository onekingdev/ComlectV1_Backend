<template lang="pug">
  div
    Breadcrumbs(:items="['Projects', project.name, 'My Timesheet']")
    table.table
      thead
        tr
          th Date of Entry
          th Status
          th Total Time
          th Total Due
          th Payment to Date
          th
      tbody
        tr(v-for="timesheet in enrichedTimesheets" :key="timesheet.id")
          td {{ timesheet.created_at | asDate }}
          td {{ timesheet.status }}
          td {{ timesheet.total_time | minToHour }}
          td {{ timesheet.total_due | usdWhole }}
          td {{ timesheet.payment_to_date | usdWhole }}
          td &hellip;
</template>

<script>
export default {
  props: {
    project: {
      type: Object,
      required: true
    },
    timesheets: {
      type: Array,
      required: true
    }
  },
  computed: {
    enrichedTimesheets() {
      return this.timesheets.map(t => ({
        ...t,
        total_time: 0,
        total_due: 0,
        payment_to_date: 0
      }))
    }
  }
}
</script>