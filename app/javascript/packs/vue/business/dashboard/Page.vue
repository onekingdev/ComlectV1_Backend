<template lang="pug">
  .container
    .row
      .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
        h2 <b>Welcome kek</b>, {{currentBusiness}}
        div
          .dropdown.m-r-1(style="display: inline-block;")
            button#dropdownMenuButton.btn.btn-secondary.dropdown-toggle(type="button" data-bs-toggle="dropdown" aria-expanded="false")
              | Admin View
            ul.dropdown-menu(aria-labelledby="dropdownMenuButton")
              li
                a.dropdown-item(href="#") Action
              li
                a.dropdown-item(href="#") Another action
              li
                a.dropdown-item(href="#") Something else here
          a.btn.btn-primary Customize
      .col-md-7.col-sm-12
        .card
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