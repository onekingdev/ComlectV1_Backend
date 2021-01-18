<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      h3.m-y-0 Upcoming
      CreateTaskModal
        button.btn.btn-dark.float-end New Task
    .card-body
      b Tasks
      TaskTable(:tasks="tasks")
      b Projects
      TaskTable(:tasks="projects")
</template>

<script>
const endpointUrl = '/api/business/tasks/'

import TaskTable from './TaskTable'
import CreateTaskModal from '@/common/CreateTaskModal'
import { DateTime } from 'luxon'
import { isProject, isTask, isOverdue, isComplete, toEvent, cssClass } from '@/common/TaskHelper'

export default {
  data() {
    return {
      tasks: [],
      projects: []
    }
  },
  created() {
    const fromTo = DateTime.local().toSQLDate() + '/' + DateTime.local().plus({days: 7}).toSQLDate()
    fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
      .then(response => response.json())
      .then(result => {
        this.tasks = result.tasks
        this.projects = result.projects
      })
      // .catch(errorCallback)
  },
  components: {
    CreateTaskModal,
    TaskTable
  }
}
</script>