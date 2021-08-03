<template lang="pug">
  div
    Get(:project="projectUrl"): template(v-slot="{project}")
      Breadcrumbs(:items="['Projects', project.title, 'My Timesheet']")
    button.btn.btn-dark(v-b-modal.timesheets-modal) Log Time
    Get(v-if="isTableVisible" :timesheets="timesheetsUrl" :callback="enrich"): template(v-slot="{timesheets}")
      table.table
        thead
          tr
            th Date of Entry
            th Status
            th Total Time
            th Total Due
            th Payment to Date
            th
        tbody
          tr(v-for="row in timesheets" :key="row.id")
            td {{ row.created_at | asDate }}
            td {{ row.status }}
            td {{ row.total_duration | minToHour }}
            td {{ row.total_due | usdWhole }}
            td {{ row.payment_to_date | usdWhole }}
            td ...
    b-modal.fade(id="timesheets-modal" title="Log Time")
      label.form-label Date of Entry
      p {{ today | asDate }}
      .row(v-for="(row, i) in entry.time_logs_attributes" :key="i")
        .col-sm-12
          hr
          span.float-right.btn.btn-danger.btn-sm(v-if="i" @click="removeRow(i)") &times;
          InputText(v-model="row.description" :errors="errors['time_logs.description']" placeholder="Describe the task") Description
        .col-md-4
          InputDate(v-model="row.date" :errors="errors['time_logs.date']") Date
        .col-md-4
          InputNumber(v-model.number="row.hours" :errors="errors['time_logs.hours']") Hours
        .col-md-4
          InputNumber(v-model.number="row.minutes" :errors="errors['time_logs.minutes']") Minutes
      hr
      button.btn.btn-outline-dark(@click="addRow") + Add Entry
      hr
      p.text-right Total Due: {{ totalDue | usdWhole }}
      template(slot="modal-footer")
        button.btn.btn-light(@click="$bvModal.hide('timesheets-modal')") Cancel
        Post(:action="timesheetsUrl" :model="{...entry,status:'pending'}" :headers="headers" @errors="errors = $event" @saved="saved")
          button.btn.btn-outline-dark Save Draft
        Post(:action="timesheetsUrl" :model="{...entry,status:'submitted'}" :headers="headers" @errors="errors = $event" @saved="saved")
          button.btn.btn-dark Send
</template>

<script>
import { DateTime } from 'luxon'
import { mapGetters } from 'vuex'

const initialEntry = () => ({ time_logs_attributes: [newEntryRow()] })
const newEntryRow = () => ({
  description: null,
  date: today(),
  hours: 0,
  minutes: 0
})
const today = () => DateTime.local().toISODate()
const totalDuration = rows => rows.reduce((result, row) => result + 60 * (row.hours || 0) + (row.minutes || 0), 0)
const totalDue = (minutes, pricePerHour) => Math.ceil(minutes * (pricePerHour || 0))

export default {
  props: {
    id: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      entry: initialEntry(),
      errors: {},
      isTableVisible: true
    }
  },
  methods: {
    enrich(timesheets) {
      return timesheets.map(row => ({
        ...row,
        total_duration: totalDuration(row.time_logs),
        total_due: totalDue(totalDuration(row.time_logs), row.hourly_rate),
        payment_to_date: 0 // @todo payment_to_date calculation
      }))
    },
    addRow() {
      this.entry.time_logs_attributes.push(newEntryRow())
    },
    removeRow(i) {
      this.entry.time_logs_attributes.splice(i, 1)
    },
    saved() {
      this.reloadTable()
      this.$bvModal.hide('timesheets-modal')
      Object.assign(this.entry, initialEntry())
      this.toast('Success', 'Time logged and awaiting approval')
    },
    reloadTable() {
      this.isTableVisible = false, setTimeout(() => this.isTableVisible = true, 0)
    }
  },
  computed: {
    ...mapGetters(['accessToken']),
    submitData() {
      return {
        timesheet: this.entry
      }
    },
    projectUrl() {
      return this.$store.getters.url('URL_API_MY_PROJECT', this.id)
    },
    timesheetsUrl() {
      return this.$store.getters.url('URL_API_PROJECT_TIMESHEET', this.id)
    },
    today,
    totalDue() {
      return totalDue(totalDuration(this.entry.time_logs_attributes), this.entry.hourly_rate)
    },
    headers() {
      return {
        Authorization: this.accessToken
      }
    }
  }
}
</script>