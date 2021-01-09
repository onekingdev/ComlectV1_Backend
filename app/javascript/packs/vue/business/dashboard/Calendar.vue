<template>
  <FullCalendar :options="calendarOptions"/>
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
  computed: {
    calendarOptions() {
      return {
        plugins: [dayGridPlugin],
        events: (info, successCallback, errorCallback) => {
          const fromTo = jsToSql(info.start) + '/' + jsToSql(info.end)
          fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
            .then(response => response.json())
            .then(result => successCallback(result.map(task => ({
              ...toEvent(task),
              classNames: [
                isComplete(task) ? 'task-is-complete'
                : isOverdue(task) ? 'task-is-overdue'
                : isProject(task) ? 'task-is-project'
                : isTask(task) ? 'task-is-task' : ''
              ]}))))
            .catch(errorCallback)
        },
        customButtons: {
          pdfButton: {
            text: 'Export',
            click: () => window.location = this.pdfUrl
          }
        },
        headerToolbar: {
          right: 'prev,next today pdfButton',
          left: 'title'
        }
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