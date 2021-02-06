<template lang="pug">
  table.table.task_table
    thead
      tr
        th Name
        th Due date
    tbody
      tr(v-for="(project, i) in projectList" :key="i")
        td {{ project.title }}
        td(:class="{ overdue: isOverdue(project) }") {{ project.ends_on | asDate }}
</template>

<script>
import { toEvent, isOverdue } from '@/common/TaskHelper'

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
    }
  }
}
</script>