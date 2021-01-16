<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      div(style="vertical-align: middle")
        h3.m-y-0 
          | {{currentMonth}}
          small(style="vertical-align: middle")
            ion-icon.m-x-1(name='chevron-back-outline' @click.prevent="prev")
            ion-icon(name='chevron-forward-outline' @click.prevent="next")
      div
        a.btn.btn-default.float-end(:href="pdfUrl" target="_blank") Export
    .card-body
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
  background-color: #047aff !important;
  color: #dae9fe;
}
.task-is-project .fc-event-title:before {
  content: '📄';
}
.task-is-task { border: 1px solid #bfe5d5; }
.task-is-task,
.task-is-task .fc-event-title {
  background-color: #1ab27f !important;
  color: #fff;
}
.task-is-task .fc-event-title:before {
  content: ' ✅ ';
}
.task-is-overdue { border: 1px solid #dedfe4; }
.task-is-overdue,
.task-is-overdue .fc-event-title {
  background-color: #fff7e4 !important;
  color: #5b5a56;
}
.task-is-overdue .fc-event-title:before {
  content: ' ⚠️ ';
}
.task-is-complete,
.task-is-complete .fc-event-title {
  //background-color: #1ab27f !important;
  //color: #e6f5ef;
}
.task-is-complete .fc-event-title:before {
  content: ' ✅ ';
}
.fc-day-today { background-color: #f3f6f9 !important; }
.fc-daygrid-day-number { color: #666667 !important; font-size: 11px; }
.fc-day-other .fc-daygrid-day-number { color: #cecfd2 !important }
.fc-daygrid-day-top { display: block !important; }
.fc-col-header-cell-cushion  { font-weight: 400 !important; color: #666667 !important; }
.fc-col-header-cell .fc-scrollgrid-sync-inner { text-align: left !important; }
</style>