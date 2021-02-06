<template lang="pug">
  div
    TaskFormModal(id="CalendarTaskFormModal" v-bind="nowEditingTask" @saved="$emit('saved')")
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
        template(v-slot:dayCellContent="arg")
          TaskFormModal(:remind-at="jsToSql(arg.date)" @saved="$emit('saved')")
            a.fc-daygrid-day-number(v-html="dayContent(arg.date)" href @click.prevent)
        template(v-slot:eventContent="arg")
          .fc-event-main-frame
            //- .fc-event-time
            .fc-event-title-container
              .fc-event-title.fc-sticky
                span.pointer(@click="openModal(arg.event.extendedProps.taskId, arg.event.extendedProps.oid)" v-if="arg.event.extendedProps.remind_at") {{arg.event.title}}
                span(v-else) {{arg.event.title}}
</template>

<script>
import FullCalendar from '@fullcalendar/vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import { DateTime } from 'luxon'
import { toEvent, cssClass } from '@/common/TaskHelper'
import TaskFormModal from '@/common/TaskFormModal'

const endpointUrl = '/api/business/reminders/'
const jsToSql = date => DateTime.fromJSDate(date).toSQLDate()

export default {
  props: {
    pdfUrl: {
      type: String,
      required: true
    },
    etag: Number
  },
  data() {
    return {
      currentMonth: '',
      nowEditingTask: {
        taskId: null,
        occurenceId: null
      }
    }
  },
  methods: {
    openModal(taskId, occurenceId) {
      Object.assign(this.nowEditingTask, { taskId, occurenceId })
      this.$nextTick(() => this.$bvModal.show('CalendarTaskFormModal'))
    },
    dayContent(arg) {
      return DateTime.fromJSDate(arg).toFormat('d')
    },
    jsToSql(arg) {
      return jsToSql(arg)
    },
    prev() {
      this.calendarObject.prev(), this.updateCurrentMonth()
    },
    next() {
      this.calendarObject.next(), this.updateCurrentMonth()
    },
    updateCurrentMonth() {
      this.currentMonth = DateTime.fromJSDate(this.calendarObject.getDate()).toFormat('MMMM yyyy')
    },
    refetchEvents() {
      this.calendarObject.refetchEvents()
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
        firstDay: 1,
        dayMaxEvents: 2,
        aspectRatio: 1.09,
        plugins: [dayGridPlugin, interactionPlugin],
        events: (info, successCallback, errorCallback) => {
          const fromTo = jsToSql(info.start) + '/' + jsToSql(info.end)
          fetch(`${endpointUrl}${fromTo}`, { headers: {'Accept': 'application/json'}})
            .then(response => response.json())
            .then(result => successCallback(result.tasks.concat(result.projects).map(task => ({
              ...toEvent(task),
              classNames: [cssClass(task)]
            }))))
            .catch(errorCallback)
        },
        headerToolbar: false
      }
    }
  },
  watch: {
    etag: {
      handler: function(newVal, oldVal) {
        this.refetchEvents()
      }
    }
  },
  components: {
    FullCalendar,
    TaskFormModal
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
/* .task-is-complete,
.task-is-complete .fc-event-title {
  background-color: #1ab27f !important;
  color: #e6f5ef;
} */
.task-is-complete .fc-event-title:before {
  content: ' ✅ ';
}
.fc-day-today { background-color: #f3f6f9 !important; }
.fc-daygrid-day-number { color: #666667 !important; font-size: 11px; }
.fc-day-other .fc-daygrid-day-number { color: #cecfd2 !important }
.fc-daygrid-day-top { display: block !important; }
.fc-col-header-cell-cushion  { font-weight: 400 !important; color: #666667 !important; }
.fc-col-header-cell .fc-scrollgrid-sync-inner { text-align: left !important; }
.fc-event-time, .fc-daygrid-event-dot { display: none; }
.fc-daygrid-day-frame { min-height: 74px !important; }
</style>