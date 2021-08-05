<template lang="pug">
  table.table.task_table.short-table
    thead
      tr
        th Name
        th.text-right Due date
    tbody
      tr(v-for="(project, i) in projectList" :key="i")
        td
          router-link.link(:to='project.href') {{project.title}}
          // a.text-dark(:href="project.href" target="_blank") {{project.title}}
        td.text-right(class="due-date" :class="{ overdue: isOverdue(project) }")
          b-icon.mr-2(v-if="isOverdue(project)" icon="exclamation-triangle-fill" variant="warning")
          | {{ project.ends_on | asDate }}
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
      return this.projects.map(project => ({
        ...toEvent(project),
        href: this.$store.getters.url('URL_PROJECT_SHOW', project.id)
      }))
    }
  }
}
</script>
