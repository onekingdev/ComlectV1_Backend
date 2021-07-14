<template lang="pug">
  div
    .card-header.d-flex.justify-content-between.p-t-0
      div(style="vertical-align: middle")
        h3.m-y-0
          TaskFormModal(id="CalendarTaskFormModal" v-bind="nowEditingTask" @saved="$emit('saved')")
          | {{currentMonth}}
          small(style="vertical-align: middle")
            ion-icon.m-x-1(name='chevron-back-outline' @click.prevent="prev")
            ion-icon(name='chevron-forward-outline' @click.prevent="next")
      div
        b-dropdown.mr-2(variant="default" text='Admin View')
          template(#button-content)
            | Monhly
            b-icon.ml-2(icon="chevron-down")
          b-dropdown-item Annually
          b-dropdown-item Monhly
          b-dropdown-item Weekly
          b-dropdown-item Daily
        a.btn.btn-default.mr-2.font-weight-bold(:href="pdfUrl" target="_blank") Export
        b-dropdown(size="sm" variant="none" class="m-0 p-0" right)
          template(#button-content)
            b-icon(icon="three-dots")
          b-dropdown-item-button Some Action
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
  },
  components: {
    FullCalendar,
    TaskFormModal
  }
}
</script>
