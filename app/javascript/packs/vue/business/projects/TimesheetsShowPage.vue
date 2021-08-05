<template lang="pug">
  Get(:project="`/api/business/projects/${projectId}`"): template(v-slot="{project}")
    Breadcrumbs(:items="['Projects', project.title, 'My Timesheet']")
    Get(:timesheets="url('URL_API_PROJECT_TIMESHEETS', project.id)" :etag="etag" :callback="enrichTimesheets"): template(v-slot="{timesheets}"): table.table
      thead
        tr
          th Date of Entry
          th Status
          th Total Time
          th Total Due
          th Payment to Date
          th
      tbody
        tr(v-for="timesheet in timesheets" :key="timesheet.id")
          td
            a(v-b-modal="`TimesheetModal${timesheet.id}`" href="#") {{ timesheet.created_at | asDate }}
            b-modal(:id="`TimesheetModal${timesheet.id}`" title="Entry Details")
              label.form-label Date of Entry
              p {{ today | asDate }}
              .row(v-for="(row, i) in timesheet.time_logs" :key="i")
                .col-sm-12
                  hr
                  label.form-label Description
                  p {{ row.description }}
                .col-md-4
                  label.form-label Date
                  p {{ row.date | asDate }}
                .col-md-4
                  label.form-label Hours
                  p {{ row.hours }}
                .col-md-4
                  label.form-label Minutes
                  p {{ row.minutes || 0 }}
              hr
              p.text-right Total Due: {{ totalDue | usdWhole }}
              template(slot="modal-footer")
                button.btn.btn-link(@click="$bvModal.hide(`TimesheetModal${timesheet.id}`)") Cancel
                Post(:model="{dispute:1}" v-bind="buttonConfig(timesheet.id)" @saved="saved(timesheet, 'Disputed')")
                  button.btn.btn-outline-dark Reject
                Post(:model="{approve:1}" v-bind="buttonConfig(timesheet.id)" @saved="saved(timesheet, 'Approved')")
                  button.btn.btn-dark Approve
          td {{ timesheet.status }}
          td {{ timesheet.total_time | minToHour }}
          td {{ timesheet.total_due | usdWhole }}
          td {{ timesheet.payment_to_date | usdWhole }}
          td &hellip;
</template>

<script>
import { DateTime } from 'luxon'
import { mapGetters } from 'vuex'
import EtaggerMixin from '@/mixins/EtaggerMixin'

const today = () => DateTime.local().toISODate()

export default {
  mixins: [EtaggerMixin()],
  props: {
    projectId: {
      type: Number,
      required: true
    }
  },
  methods: {
    saved(timesheet, message) {
      this.toast(message, message)
      this.$bvModal.hide(`TimesheetModal${timesheet.id}`)
      this.newEtag()
    }
  },
  computed: {
    ...mapGetters(['url', 'accessToken']),
    enrichTimesheets() {
      return timesheets => timesheets.map(t => ({
        ...t,
        total_time: 0,
        total_due: 0,
        payment_to_date: 0
      }))
    },
    buttonConfig() {
      return timesheetId => ({
        action: this.url('URL_API_PROJECT_TIMESHEETS', this.project.id) + '/' + timesheetId,
        method: 'PUT',
        headers: { Authorization: this.accessToken }
      })
    },
    totalDue() {
      return 0
    },
    today
  }
}
</script>
