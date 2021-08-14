<template lang="pug">
  div
    .card-header
      div(style="vertical-align: middle")
        h3.calendar__title.m-y-0
          TaskFormModal(id="CalendarTaskFormModal" v-bind="nowEditingTask" @saved="$emit('saved')")
          | {{currentMonth}}
          small.float-right(style="vertical-align: middle")
            ion-icon.m-x-1(name='chevron-back-outline' @click.prevent="prev")
            ion-icon(name='chevron-forward-outline' @click.prevent="next")
      Download(:pdfUrl="pdfUrl")
    .card-body.p-20
      FullCalendar(:options="calendarOptions" ref="FullCalendar")
        template(v-slot:dayCellContent="arg")
          TaskFormModal(:remind-at="jsToSql(arg.date)" @saved="$emit('saved')")
            a.fc-daygrid-day-number(v-html="dayContent(arg.date)" href @click.prevent)
        template(v-slot:eventContent="arg")
          .fc-event-main-frame
            //- .fc-event-time
            .fc-event-title-container
              .fc-event-title.fc-sticky
                span(v-for="icon in arg.event.extendedProps.icons")
                  ion-icon(:name="icon")
                  | &nbsp;
                span.pointer(@click="openModal(arg.event.extendedProps.taskId, arg.event.extendedProps.oid)" v-if="arg.event.extendedProps.remind_at") {{arg.event.title}}
                a(v-else :href="arg.event.extendedProps.href" target="_blank") {{arg.event.title}}
</template>

<script>
import FullCalendar from '@fullcalendar/vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import { DateTime } from 'luxon'
import { toEvent, cssClass } from '@/common/TaskHelper'
import TaskFormModal from '@/common/TaskFormModal'
import Download from '@/common/Dashboard/components/Download'

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
  components: {
    FullCalendar,
    TaskFormModal,
    Download
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
            .then(result => successCallback(result.tasks.concat(result.projects.map(project => ({
              ...project,
              href: this.$store.getters.url('URL_PROJECT_SHOW', project.id)
            }))).map(task => ({
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
  }
}
</script>
