<template lang="pug">
  div
    .container
      .row.p-x-1
        .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
          div
            h2 <b>Projects</b>
            p Plan projects with employees or hire specialists for additional help
          div
            a.btn.btn-default(href='/business/projects/new') Post Project
            LocalProjectModal(@saved="$emit('saved')")
              a.btn.m-l-1.btn-dark New Project

    b-tabs(content-class="mt-0")
      b-tab(title="My Projects" active="")
        .card-body.white-card-body
          div
            b-dropdown.m-r-1(text='Filter by: All')
              b-dropdown-item All
              b-dropdown-item In Progress
              b-dropdown-item Pending
              b-dropdown-item Overdue
              b-dropdown-item Complete
            b-dropdown.m-r-1(text='Year: All')
              b-dropdown-item 2021
              b-dropdown-item 2020
          ProjectTable(:projects="projects")
      b-tab(title="Contacts")
        .card-body.white-card-body
          p Contacts
      b-tab(title="Ratings and Reviews")
        .card-body.white-card-body
          p Ratings and Reviews

</template>

<script>
const endpointUrl = '/api/business/projects/'
import { DateTime } from 'luxon'
import ProjectTable from '../dashboard/ProjectTable'
import LocalProjectModal from './LocalProjectModal'

export default {
  data() {
    return {
      projects: []
    }
  },
  created() {
    this.refetch()
  },
  methods: {
    refetch() {      
      fetch(endpointUrl, { headers: {'Accept': 'application/json'} })
        .then(response => response.json())
        .then(result => {
          this.projects = result.projects
        })
    }
  },
  components: {
    ProjectTable,
    LocalProjectModal
  }
}
</script>