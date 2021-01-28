<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      h3.m-y-0 Upcoming
      TaskFormModal(@saved="$emit('saved')")
        button.btn.btn-dark.float-end New Task
    .card-body
      b.d-flex.justify-content-between(role="button" v-b-toggle.upcoming_tasks_collapse="")
        | Tasks
        ion-icon(name='chevron-down-outline')
      b-collapse#upcoming_tasks_collapse(:visible="true")
        TaskTable(:tasks="tasks" @saved="$emit('saved')")
      b.d-flex.justify-content-between(role="button" v-b-toggle.upcoming_projects_collapse="")
        | Projects
        ion-icon(name='chevron-down-outline')
      b-collapse#upcoming_projects_collapse(:visible="true")
        TaskTable(:tasks="projects")
</template>

<script>
const endpointUrl = '/api/business/reminders/'
const overdueEndpointUrl = '/api/business/overdue_reminders'

import TaskTable from '@/common/TaskTable'
import TaskFormModal from '@/common/TaskFormModal'
import { DateTime } from 'luxon'

export default {
  props: {
    etag: Number
  },
  data() {
    return {
      tasks: [],
      projects: []
    }
  },
  created() {
    this.refetch()
  },
  methods: {
    refetch() {
      const fromTo = DateTime.local().toSQLDate() + '/' + DateTime.local().plus({days: 7}).toSQLDate()

      fetch(overdueEndpointUrl, { headers: {'Accept': 'application/json'} })
        .then(response => response.json())
        .then(result => {
          this.tasks = result.tasks
        }).then(fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
          .then(response => response.json())
          .then(result => {
            this.tasks = this.tasks.concat(result.tasks)
            this.projects = result.projects
          })
        )
        // .catch(errorCallback)
    }
  },
  components: {
    TaskFormModal,
    TaskTable
  },
  watch: {
    etag: {
      handler: function(newVal, outline) {
        this.refetch()
      }
    }
  }
}
</script>