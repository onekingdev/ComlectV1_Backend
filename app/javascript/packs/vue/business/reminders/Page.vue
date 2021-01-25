<template lang="pug">
  div
    .container
      .row.p-x-1
        .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
          h2 <b>Tasks</b>
          div
            a.btn.btn-default Download
            a.btn.m-l-1.btn-dark New Task
    .card-body.white-card-body
      div
        b-dropdown.m-r-1(text='Show: All Tasks')
          b-dropdown-item All Tasks
          b-dropdown-item My Tasks
          b-dropdown-item Completed Tasks
        b-dropdown.m-r-1(text='All Links')
          b-dropdown-item All Links
      TaskTable(:tasks="tasks" @saved="$emit('saved')")
</template>

<script>
const endpointUrl = '/api/business/reminders/'
const overdueEndpointUrl = '/api/business/overdue_reminders'
import { DateTime } from 'luxon'

import TaskTable from '../dashboard/TaskTable'

export default {
  data() {
    return {
      tasks: []
    }
  },
  created() {
    this.refetch()
  },
  methods: {
    refetch() {
      const fromTo = DateTime.local().minus({years: 10}).toSQLDate() + '/' + DateTime.local().plus({years: 10}).toSQLDate()
      
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
    TaskTable
  }
}
</script>