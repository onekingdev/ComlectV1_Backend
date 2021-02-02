<template lang="pug">
  table.table.task_table
    thead
      tr
        th Name
        th Due date
    tbody
      tr(v-for="(project, i) in projectList" :key="i")
        td {{ project.title }}
        td(:class="{ overdue: isOverdue(project) }") {{ project.end }}
</template>

<script>
import { toEvent, isOverdue } from '@/common/TaskHelper'
import { DateTime } from 'luxon'

export default {
  props: {
    projects: {
      type: Array,
      required: true
    }
  },
  methods: {
    isOverdue
  },
  computed: {
    projectList() {
      return this.projects.map(toEvent)
        .map(e => ({
          ...e,
          start: DateTime.fromSQL(e.start).toLocaleString(),
          end: DateTime.fromSQL(e.end).toLocaleString()
        }))
    }
  }
}
</script>