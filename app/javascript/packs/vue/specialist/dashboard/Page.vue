<template lang="pug">
  div
    .page
      h2.page__title Welcome, {{currentSpecialist}}
      .page__actions
        b-dropdown.m-r-1(text='Admin View')
          b-dropdown-item Action
          b-dropdown-item Another action
          b-dropdown-item Something else here
        a.btn.btn-default Customize
    div.px-4
      .row
        .col.mb-2
          EmptyPlan
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
import EmptyPlan from '@/specialist/settings/components/subscriptions/components/EmptyPlan'

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

    const firstView = JSON.parse(localStorage.getItem('app.currentUser.firstEnter'))
    if (firstView) {
      this.toast('Success', 'Account has been created.')
      localStorage.removeItem('app.currentUser.firstEnter')
    }
  },
  components: {
    Calendar,
    UpcomingTasks,
    EmptyPlan,
  },
  computed: {
    pdfUrl() {
      return '/specialist/reminders.pdf'
    },
    currentSpecialist() {
      // @TODO Must be fetched from API
      return ''
    }
  }
}
</script>
