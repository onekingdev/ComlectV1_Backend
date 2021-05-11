<template lang="pug">
  table.table.task_table
    thead
      tr
        th Title
        th Collaborators
        th Tasks Left
        th Cost
        th Status
        th Start Date
        th End Date
    tbody
      tr(v-for="project in projectsHrefs" :key="key(project)")
        td: a.text-dark(:href="project.href") {{project.title}}
        td {{ project.assignee }}
        td {{ project.tasksLeft }}
        td {{ project.cost }}
        td
          span.badge(:class="badgeClass(project)") {{ project.status }}
        td {{ project.starts_on | asDate }}
        td(:class="{ overdue: isOverdue(project) }") {{ project.ends_on | asDate }}
</template>

<script>
import { isOverdue, badgeClass } from '@/common/TaskHelper'

const key = project => `${project.id}${project.type ? '-p' : '-l'}`
const tasksLeft = project => (project.reminders && project.reminders.length)
  ? project.reminders.filter(r => !r.done_at).length
  : '----'

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
      return this.projects.map(p => ({
        ...p,
        href: this.$store.getters.url('URL_PROJECT_SHOW', p.id),
        tasksLeft: tasksLeft(p)
      }))
    }
  }
}
</script>