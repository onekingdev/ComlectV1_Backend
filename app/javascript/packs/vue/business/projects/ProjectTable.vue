<template lang="pug">
  table.table.task_table
    thead
      tr
        th Title
        th Collaborators
        th.text-right Tasks Left
        th.text-right Cost
        th Status
        th Start Date
        th.text-right End Date
    tbody
      tr(v-for="project in projectsHrefs" :key="key(project)")
        // td: a.text-dark(:href="project.href") {{project.title}}
        td: router-link.link(:to='`${project.href}`') {{ project.title }}
        td {{ project.assignee }}
        td.text-right {{ project.tasksLeft }}
        td.text-right {{ project.cost }}
        td
          span.badge(:class="badgeClass(project)") {{ project.status | statusCorrector }}
        td {{ project.starts_on | asDate }}
        td.text-right(class="due-date" :class="{ overdue: isOverdue(project) }")
          b-icon.mr-2(v-if="isOverdue(project)" icon="exclamation-triangle-fill" variant="warning")
          | {{ project.ends_on | asDate }}
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
  },
  filters: {
    statusCorrector: function (value) {
      if (value === 'inprogress') value = 'In Progress'
      return value.replace(/[A-Z]/g, ' $&')
    }
  },
}
</script>
