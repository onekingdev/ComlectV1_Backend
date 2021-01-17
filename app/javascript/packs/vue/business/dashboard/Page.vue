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
          Calendar(v-bind="{pdfUrl}")
      .col-md-5.col-sm-12.pl-0
        .card
          UpcomingTasks
    .row.p-x-1
      .col-sm-12
        ProjectTable
</template>

<script>
import Calendar from './Calendar'
import ProjectTable from './ProjectTable'
import UpcomingTasks from '@/business/dashboard/UpcomingTasks'

export default {
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
    UpcomingTasks
  }
}
</script>