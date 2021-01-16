<template lang="pug">
  .container
    .row
      .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
        h2 <b>Welcome</b>, {{currentBusiness}}
        div
          b-dropdown.m-r-1(text='Admin View')
            b-dropdown-item Action
            b-dropdown-item Another action
            b-dropdown-item Something else here
          a.btn.btn-primary Customize
      .col-md-7.col-sm-12
        .card
          .card-body
            Calendar(v-bind="{pdfUrl}")
      .col-md-5.col-sm-12
        .card
          UpcomingTasks
</template>

<script>
import Calendar from './Calendar'
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
    UpcomingTasks
  }
}
</script>