<template lang="pug">
  .row
    .col-md-12
      h2 <b>Welcome</b>, {current_business}
      .dropdown
        button#dropdownMenuButton.btn.btn-secondary.dropdown-toggle(type="button" data-bs-toggle="dropdown" aria-expanded="false")
          | Dropdown button
        ul.dropdown-menu(aria-labelledby="dropdownMenuButton")
          li
            a.dropdown-item(href="#") Action
          li
            a.dropdown-item(href="#") Another action
          li
            a.dropdown-item(href="#") Something else here
      .btn.btn-default Customize
    .col-md-7.col-sm-12
      Calendar(v-bind="{pdfUrl}")
    .col-md-5.col-sm-12
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
    }
  },
  components: {
    Calendar,
    UpcomingTasks
  }
}
</script>