<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      h3 Upcoming
      a.btn.btn-primary.float-end(href) New Task
    .card-body
      h4 Tasks
      TaskTable(:tasks="tasks")
      h4 Projects
      TaskTable(:tasks="projects")
</template>

<script>
import TaskTable from './TaskTable'

export default {
  computed: {
    tasks() {
      return []
    },
    projects() {
      return []
    }
  },
  components: {
    TaskTable
  }
}
</script>