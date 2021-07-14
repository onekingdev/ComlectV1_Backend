<template lang="pug">
  .page
    .page-header
      h2.page-header__title Welcome, {{currentBusiness}}
      .page-header__actions
        b-dropdown.mr-2(variant="default" right)
          template(#button-content)
            | Admin view
            b-icon.ml-2(icon="chevron-down")
          b-dropdown-item Other view
        a.btn.btn-default.font-weight-bold Customize
    div.p-x-40
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
  props: {
    pdfUrl: {
      type: String,
      required: false
    },
    currentBusiness: {
      type: String,
      required: false
    }
  },
  components: {
    Calendar,
    UpcomingTasks,
    EmptyPlan,
  }
}
</script>
