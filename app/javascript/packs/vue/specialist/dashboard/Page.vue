<template lang="pug">
  .page
    .page-header.p-x-40.p-t-30
      EmptyPlan
    .page-header
      h2.page-header__title
        b Welcome,&nbsp;
        | {{currentSpecialist}}
    div.p-x-40.p-b-40
      .row
        .col
          .dashboard
            .card.calendar
              Calendar(v-bind="{pdfUrl}" @saved="newEtag" :etag="etag")
            .card.upcoming.h-100
              UpcomingTasks(@saved="newEtag" :etag="etag")
</template>

<script>
import Calendar from './Calendar'
import UpcomingTasks from '@/specialist/dashboard/UpcomingTasks'
import EmptyPlan from '@/specialist/settings/components/subscriptions/components/EmptyPlan'

const endpointProjectsUrl = '/api/specialist/local_projects/'
const pdfUrl = '/specialist/reminders.pdf'

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
    pdfUrl: () => pdfUrl,
    currentSpecialist() {
      // @TODO Must be fetched from API
      const accountInfo = this.$store.getters.getUser
      return accountInfo ? `${accountInfo.first_name} ${accountInfo.last_name}` : ''
    }
  }
}
</script>
