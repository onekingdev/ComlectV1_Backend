<template lang="pug">
  table.table.task_table.project-table
    thead
      tr
        th.project-table__name.project-table__name_head Name
          b-icon.ml-2(icon='chevron-expand')
        th.project-table__assignee.project-table__assignee_head Collaborators
          b-icon.ml-2(icon='chevron-expand')
        th.project-table__left.project-table__left_head.text-right Tasks Left
          b-icon.ml-2(icon='chevron-expand')
        th.project-table__coast.project-table__coast_head.text-right Cost
          b-icon.ml-2(icon='chevron-expand')
        th.project-table__status.project-table__status_head Status
          b-icon.ml-2(icon='chevron-expand')
        th.project-table__start-date.project-table__start-date_head Start Date
          b-icon.ml-2(icon='chevron-expand')
        th.project-table__end-date.project-table__end-date_head.text-right End Date
          b-icon.ml-2(icon='chevron-expand')
    tbody
      tr(v-for="project in projectsHrefs" :key="key(project)")
        // td: a.text-dark(:href="project.href") {{project.title}}
        td.project-table__name: router-link.link(:to='`${project.href}`') {{ project.title }}
        td.project-table__assignee {{ project.assignee }}
        td.project-table__left.text-right {{ project.tasksLeft }}
        td.project-table__coast.text-right {{ project.cost | usdWhole }}
        td.project-table__status
          span.badge(:class="badgeClass(project)") {{ project.status | statusCorrector }}
        td.project-table__start-date {{ project.starts_on | asDate }}
        td.project-table__end-date.text-right(class="due-date" :class="{ overdue: isOverdue(project) }")
          b-icon.mr-2(v-if="isOverdue(project)" icon="exclamation-triangle-fill" variant="warning")
          span.end-date {{ project.ends_on | asDate }}
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
