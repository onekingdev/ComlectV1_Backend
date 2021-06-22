<template lang="pug">
  div
    .page
      h2.page__title Welcome, {{currentBusiness}}
      .page__actions
        b-dropdown.m-r-1(text='Admin View')
          b-dropdown-item Action
          b-dropdown-item Another action
          b-dropdown-item Something else here
        a.btn.btn-default Customize
    div.px-4
      .row
        .col-md-7.col-sm-12
          .card
            Calendar(v-bind="{pdfUrl}" @saved="newEtag" :etag="etag")
        .col-md-5.col-sm-12.pl-0
          .card
            UpcomingTasks(@saved="newEtag" :etag="etag")
</template>

<script>
import Calendar from './Calendar'
import UpcomingTasks from '@/specialist/dashboard/UpcomingTasks'

const endpointProjectsUrl = '/api/specialist/local_projects/'

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
    UpcomingTasks,
  }
}
</script>
