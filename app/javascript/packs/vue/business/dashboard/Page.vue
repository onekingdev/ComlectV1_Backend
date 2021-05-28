<template lang="pug">
  .container
    .row.p-x-1
      .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
        h2 <b>Welcome</b>, {{currentBusiness}}
        div
          b-dropdown.m-r-1(text='Admin View')
            b-dropdown-item Action
            b-dropdown-item Another action
            b-dropdown-item Something else here
          a.btn.btn-default Customize
      .col-md-7.col-sm-12
        .card
          Calendar(v-bind="{pdfUrl}" @saved="newEtag" :etag="etag")
      .col-md-5.col-sm-12.pl-0
        .card
          UpcomingTasks(@saved="newEtag" :etag="etag")
    .row.p-x-1.p-y-3
      .col-sm-12
        .card
          .card-header.d-flex.justify-content-between
            h3 Projects
            div
              LocalProjectModal(@saved="refetch")
                button.btn.btn-dark.float-end New Project
              a.btn.float-end(href="/business/projects") View all
          .card-body
            ProjectTable(:projects="projects")
    .row.p-x-1
      .col-md-6.col-sm-12
        RecentActivity
      .col-md-6.col-sm-12
        AddonNotifications
</template>

<script>
import Calendar from './Calendar'
import ProjectTable from '@/common/ProjectTable'
import RecentActivity from './RecentActivity'
import AddonNotifications from './AddonNotifications'
import UpcomingTasks from '@/business/dashboard/UpcomingTasks'
import LocalProjectModal from '../projects/LocalProjectModal'

const endpointProjectsUrl = '/api/business/local_projects/'

export default {
  data() {
    return {
      etag: Math.random(),
      projects: []
    }
  },
  methods: {
    newEtag() {
      this.etag = Math.random()
    },
    refetch() {
      fetch(endpointProjectsUrl, { headers: {'Accept': 'application/json'} })
        .then(response => response.json())
        .then(result => this.projects = result)
    }
  },
  created() {
    this.refetch()
  },
  props: {
    pdfUrl: {
      type: String,
      required: true
    },
    currentBusiness: {
      type: String,
      required: true
    }
  },
  components: {
    Calendar,
    ProjectTable,
    UpcomingTasks,
    RecentActivity,
    AddonNotifications,
    LocalProjectModal
  }
}
</script>