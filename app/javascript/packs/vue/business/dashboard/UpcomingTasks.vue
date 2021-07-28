<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      h3.upcoming__header.m-y-0 Upcoming
      TaskFormModal(@saved="$emit('saved')")
        button.btn.btn-dark.float-end New Task
    .card-body.p-x-20.p-y-30
      b.upcoming__title.d-flex.justify-content-between.m-b-10(role="button" v-b-toggle.upcoming_tasks_collapse="")
        | Tasks
        ion-icon(name="chevron-down-outline")
      b-collapse#upcoming_tasks_collapse(:visible="true")
        TaskTable(:tasks="tasks" :shortTable="true" @saved="$emit('saved')")
        .d-flex.justify-content-end.mb-2(v-if="tasks.length")
          router-link.link.upcoming__more(:to='`/business/reminders`') More
      b.upcoming__title.d-flex.justify-content-between.m-b-10(role="button" v-b-toggle.upcoming_projects_collapse="")
        | Projects
        ion-icon(name="chevron-down-outline")
      b-collapse#upcoming_projects_collapse(:visible="true")
        ProjectTable(:projects="projects")
        .d-flex.justify-content-end(v-if="projects.length")
          router-link.link.upcoming__more(:to='`/business/projects`') More
</template>

<script>
const LIMIT_OF_ARRAY_TASKS = 10
const LIMIT_OF_ARRAY_PROJECTS = 5

const endpointUrl = '/api/business/reminders/'
const overdueEndpointUrl = '/api/business/overdue_reminders'

import TaskTable from '@/common/TaskTable'
import ProjectTable from './ProjectTable'
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

      let tasks = []
      let projects = []

      fetch(overdueEndpointUrl, { headers: {'Accept': 'application/json'} })
        .then(response => response.json())
        .then(result => {
          tasks = result.tasks
        }).then(fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
          .then(response => response.json())
          .then(result => {
            tasks = tasks.concat(result.tasks)
            projects = result.projects

            // this.tasks = tasks.slice(0, LIMIT_OF_ARRAY_TASKS).filter(task => !task.done_at)
            this.tasks = tasks.filter(task => !task.done_at)
            this.projects = projects.slice(0, LIMIT_OF_ARRAY_PROJECTS)
          })
        )
        // .catch(errorCallback)
    }
  },
  components: {
    TaskFormModal,
    TaskTable,
    ProjectTable
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
