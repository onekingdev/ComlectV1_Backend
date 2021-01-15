<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      .col-sm
        span {{currentMonth}}
      .col-sm
        a.btn.btn-primary(@click.prevent="prev" href) <
        a.btn.btn-primary(@click.prevent="next" href) >
      .col-sm
        a.btn.btn-primary.float-end(:href="pdfUrl" target="_blank") Export
    .card-body
      .col-sm
        FullCalendar(:options="calendarOptions" ref="FullCalendar")
</template>

<script>
import FullCalendar from '@fullcalendar/vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import { DateTime } from 'luxon'
import { isProject, isTask, isOverdue, isComplete, toEvent } from '../../common/TaskHelper'

const endpointUrl = '/api/business/tasks/'
const jsToSql = date => DateTime.fromJSDate(date).toSQLDate()

export default {
  props: {
    pdfUrl: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      currentMonth: ''
    }
  },
  methods: {
    prev() {
      this.calendarObject.prev(), this.updateCurrentMonth()
    },
    next() {
      this.calendarObject.next(), this.updateCurrentMonth()
    },
    updateCurrentMonth() {
      this.currentMonth = DateTime.fromJSDate(this.calendarObject.getDate()).toFormat('MMMM yyyy')
    }
  },
  mounted() {
    this.updateCurrentMonth()
  },
  computed: {
    calendarObject() {
      return this.$refs.FullCalendar.getApi()
    },
    calendarOptions() {
      return {
        dayMaxEvents: true,
        plugins: [dayGridPlugin],
        events: (info, successCallback, errorCallback) => {
          const fromTo = jsToSql(info.start) + '/' + jsToSql(info.end)
          fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
            .then(response => response.json())
            .then(result => successCallback(result.tasks.concat(result.projects).map(task => ({
              ...toEvent(task),
              classNames: [
                isComplete(task) ? 'task-is-complete'
                : isOverdue(task) ? 'task-is-overdue'
                : isProject(task) ? 'task-is-project'
                : isTask(task) ? 'task-is-task' : ''
              ]}))))
            .catch(errorCallback)
        },
        headerToolbar: false
      }
    }
  },
  components: {
    FullCalendar
  }
}
</script>

<style>
.task-is-project,
.task-is-project .fc-event-title {
  background-color: var(--bs-blue) !important;
}
.task-is-project .fc-event-title:before {
  content: '📄';
}
.task-is-task,
.task-is-task .fc-event-title {
  background-color: var(--bs-green) !important;
}
.task-is-task .fc-event-title:before {
  content: '✅';
}
.task-is-overdue,
.task-is-overdue .fc-event-title {
  background-color: var(--bs-warning) !important;
}
.task-is-overdue .fc-event-title:before {
  content: '⚠️';
}
.task-is-complete,
.task-is-complete .fc-event-title {
  background-color: var(--bs-gray) !important;
}
.task-is-complete .fc-event-title:before {
  content: '✅';
}
</style>