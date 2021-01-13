<template lang="pug">
  div
    h3 Upcoming
      a.btn.btn-primary.float-end(href) New Task
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