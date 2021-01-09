<template>
  <div class="row">
    <div class="col-md-7 col-sm-12">
      <FullCalendar :options="calendarOptions"/>
    </div>
    <div class="col-md-5 col-sm-12">
      <h3>Bar colors</h3>
      <dl>
        <dt><span class="task-is-task">✅</span></dt>
        <dd>Tasks</dd>
        <dt><span class="task-is-project">📄</span></dt>
        <dd>Projects</dd>
        <dt><span class="task-is-overdue">📄</span></dt>
        <dd>Overdue</dd>
        <dt><span class="task-is-complete">📄</span></dt>
        <dd>Complete</dd>
      </dl>
    </div>
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
  classNames: [
    isComplete(task) ? 'task-is-complete'
    : isOverdue(task) ? 'task-is-overdue'
    : isProject(task) ? 'task-is-project'
    : isTask(task) ? 'task-is-task' : ''
  ]
})

const isProject = task => task.hasOwnProperty('only_regulators') && task.hasOwnProperty('key_deliverables')
const isTask = task => task.hasOwnProperty('remindable_type') && task.hasOwnProperty('skip_occurencies')
const isOverdue = task => DateTime.fromISO(task.starts_on || task.remind_at) <= DateTime.local()
const isComplete = task => task.completed_at || task.done_at

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