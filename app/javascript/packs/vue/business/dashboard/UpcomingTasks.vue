<template lang="pug">
  div
    h3 Upcoming
      a(href="#" class="btn btn-primary float-end") New Task
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