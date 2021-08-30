<template lang="pug">
  .page
    Get(currentBusiness="/api/businesses/current"): template(v-slot="{ currentBusiness }")
      .page-header
        h2.page-header__title
          b Welcome,&nbsp;
          | {{currentBusiness.contact_first_name}} {{currentBusiness.contact_last_name}}
        //.page-header__actions
        //  b-dropdown.mr-2(variant="default" right)
        //    template(#button-content)
        //      | Admin view
        //      b-icon.ml-2(icon="chevron-down")
        //    b-dropdown-item Other view
        //  a.btn.btn-default.font-weight-bold Customize
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
import UpcomingTasks from '@/business/dashboard/UpcomingTasks'

const endpointProjectsUrl = '/api/local_projects/'
const pdfUrl = '/reminders.csv'

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
      const headers = {
        'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': localStorage.getItem('app.currentUser.token') ? JSON.parse(localStorage.getItem('app.currentUser.token')) : '',
      }
      //const business_id = window.localStorage["app.business_id"]
      //if(business_id) headers.business_id = JSON.parse(business_id)

      fetch(endpointProjectsUrl, headers)
        .then(response => response.json())
        .then(result => this.projects = result)
    },
  },
  created() {
    this.refetch()

    // const firstView = JSON.parse(localStorage.getItem('app.currentUser.firstEnter'))
    // if (firstView) {
    //   this.toast('Success', 'Account has been created.')
    //   localStorage.removeItem('app.currentUser.firstEnter')
    // }
  },
  computed: {
    pdfUrl: () => pdfUrl,
    // currentBusiness() {
    //   // @TODO Must be fetched from API
    //   const accountInfo = this.$store.getters.getUser
    //   return accountInfo ? `${accountInfo.contact_first_name} ${accountInfo.contact_last_name}` : ''
    // },
  },
  components: {
    Calendar,
    UpcomingTasks,
  }
}
</script>
