<template lang="pug">
  table.table.task_table
    thead
      tr
        th Assignee(s)
        th Title
        th Cost
        th Status
        th Start Date
        th End Date
    tbody
      tr(v-for="project in projectsHrefs" :key="key(project)")
        td {{ project.assignee }}
        td
          a.text-dark(:href="project.href") {{project.title}}
        td {{ project.cost }}
        td
          span.badge(v-bind:class="badgeClass(project)") {{ project.status }}
        td {{ project.starts_on | asDate }}
        td(:class="{ overdue: isOverdue(project) }") {{ project.ends_on | asDate }}
</template>

<script>
const key = project => `${project.id}${project.type ? '-p' : '-l'}`
import { isOverdue, badgeClass } from '@/common/TaskHelper'

export default {
  props: {
    projects: {
      type: Array,
      required: true
    }
  },
  methods: {
    key,
    isOverdue,
    badgeClass
  },
  computed: {
    projectsHrefs() {
      return this.projects.map(p => ({...p, href: this.$store.getters.url('URL_PROJECT_SHOW', p.id) }))
    }
  }
}
</script>