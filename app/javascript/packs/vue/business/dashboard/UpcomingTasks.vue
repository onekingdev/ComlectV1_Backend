<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      h3.m-y-0 Upcoming
      CreateTaskModal
        button.btn.btn-dark.float-end New Task
    .card-body
      h4 Tasks
      TaskTable(:tasks="tasks")
      h4 Projects
      TaskTable(:tasks="projects")
</template>

<script>
import TaskTable from './TaskTable'
import CreateTaskModal from '@/common/CreateTaskModal'

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
    CreateTaskModal,
    TaskTable
  }
}
</script>