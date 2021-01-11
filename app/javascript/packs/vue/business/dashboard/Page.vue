<template lang="pug">
  .row
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