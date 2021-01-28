<template lang="pug">
  table.table
    thead
      tr
        th Assignee(s)
        th Title
        th Cost
        th Status
        th Start Date
        th End Date
    tbody
      tr(v-for="project in projects" :key="project.id")
        td {{ project.assignee }}
        td {{ project.title }}
        td {{ project.fixed_budget || project.hourly_rate }}
        td
          span.badge.badge-primary {{ project.status }}
        td {{ project.starts_on }}
        td {{ project.ends_on }}
</template>

<script>
import { DateTime } from 'luxon'

const endpointUrl = '/api/business/reminders/'

export default {
  props: {
    projects: {
      type: Array,
      required: true
    }
  }
}
</script>