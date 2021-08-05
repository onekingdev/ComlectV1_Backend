<template lang="pug">
  div
    .card-header.d-flex.justify-content-between.p-t-0
      div(style="vertical-align: middle")
        h3.calendar__title.m-y-0
          TaskFormModal(id="CalendarTaskFormModal" v-bind="nowEditingTask" @saved="$emit('saved')")
          | {{currentMonth}}
          small.float-right(style="vertical-align: middle")
            ion-icon.m-x-1(name='chevron-back-outline' @click.prevent="prev")
            ion-icon(name='chevron-forward-outline' @click.prevent="next")
      div
        b-dropdown#dropdown-form.m-2(ref='dropdown' variant="none")
          template(#button-content)
            | Download
            b-icon.ml-2(icon="chevron-down")
          b-dropdown-form(style="width: 374px;")
            b-row.m-t-1(no-gutters)
              .col-sm.m-r-1
                label.form-label Start Date
                DatePicker(v-model="download.start_date")
                Errors(:errors="errors.start_date")
              .col-sm
                label.form-label Due Date
                DatePicker(v-model="download.end_date")
                Errors(:errors="errors.end_date")
            .d-flex.justify-content-between
              b-button.link(variant='none' size='sm' @click='onClick') Download All
              b-button(variant='secondary' size='sm' @click='onClick') Download
        //a.btn.btn-secondary(:href="pdfUrl" target="_blank") Download
        //b-dropdown(size="sm" variant="none" class="m-0 p-0" right)
        //  template(#button-content)
        //    b-icon(icon="three-dots")
        //  b-dropdown-item-button Some Action
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

const endpointUrl = '/api/specialist/reminders/'
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
      },
      download: {
        start_date: '',
        end_date: '',
      },
      errors: {}
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
    },
    onClick() {
      // Close the menu and (by passing true) return focus to the toggle button
      this.$refs.dropdown.hide(true)
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
