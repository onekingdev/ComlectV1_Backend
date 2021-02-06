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
      tr(v-for="project in projects" :key="key(project)")
        td {{ project.assignee }}
        td {{ project.title }}
        td {{ project.fixed_budget || project.hourly_rate }}
        td
          span.badge.badge-primary {{ project.status }}
        td {{ project.starts_on }}
        td {{ project.ends_on }}
</template>

<script>
const key = project => `${project.id}${project.type ? '-p' : '-l'}`

export default {
  props: {
    projects: {
      type: Array,
      required: true
    }
  },
  methods: {
    key
  }
}
</script>