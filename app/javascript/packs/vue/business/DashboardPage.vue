<template>
  <div>
    <FullCalendar :options="calendarOptions"/>
  </div>
</template>

<script>
import FullCalendar from '@fullcalendar/vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import { DateTime } from 'luxon'

const endpointUrl = '/api/business/tasks/'
const jsToSql = date => DateTime.fromJSDate(date).toSQLDate()
const toEvent = task => ({
  ...task,
  start: task.starts_on || task.remind_at,
  end: task.ends_on,
  title: task.title || task.body,
  classNames: [isProject(task) ? 'task-is-project' : isTask(task) ? 'task-is-task' : '']
})

const isProject = task => task.hasOwnProperty('only_regulators') && task.hasOwnProperty('key_deliverables')
const isTask = task => task.hasOwnProperty('remindable_type') && task.hasOwnProperty('skip_occurencies')

export default {
  computed: {
    calendarOptions() {
      return {
        plugins: [dayGridPlugin],
        events: (info, successCallback, errorCallback) => {
          const fromTo = jsToSql(info.start) + '/' + jsToSql(info.end)
          fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
            .then(response => response.json())
            .then(result => successCallback(result.map(toEvent)))
            .catch(errorCallback)
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
</style>