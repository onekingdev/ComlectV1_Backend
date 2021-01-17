<template lang="pug">
  .card
    .card-header.d-flex.justify-content-between
      h3 Projects
      div
        button.btn.btn-dark.float-end New Project
        button.btn.float-end View all
    .card-body
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

const endpointUrl = '/api/business/tasks/'

export default {
  data() {
    return {
      projects: []
    }
  },
  created() {
    const fromTo = DateTime.local().startOf('month').toSQLDate() + '/' + DateTime.local().endOf('month').toSQLDate()
    fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
      .then(response => response.json())
      .then(result => this.projects = result.projects)
  }
}
</script>