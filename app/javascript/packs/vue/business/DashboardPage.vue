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
const toEvent = task => ({ ...task, start: task.starts_on, end: task.ends_on })

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