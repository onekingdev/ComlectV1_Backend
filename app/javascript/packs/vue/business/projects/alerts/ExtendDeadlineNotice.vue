<template lang="pug">
  .alert.alert-warning(v-if="isVisible")
    h4.alert-heading The project's due date is tomorrow.
    p
      button.btn.btn-default.float-right(v-b-modal="'ExtendDeadlineModal'") Extend
      | Do you want to extend the deadline?
      b-modal(id="ExtendDeadlineModal" title="Extend Deadline")
        InputDate(v-model="form.new_end_date" :errors="errors.new_end_date" :options="datepickerOptions") New Due Date
        template(#modal-footer="{ hide }")
          button.btn.btn-default.float-right(@click="hide") Cancel
          Post(:action="submitUrl" :model="form" @errors="errors = $event" @saved="saved")
            button.btn.btn-dark.float-right Confirm
</template>

<script>
import { DateTime } from 'luxon'

export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      form: { new_end_date: null },
      errors: {}
    }
  },
  methods: {
    saved() {
      this.$bvToast.toast('Success', { title: 'A project extension has been requested', autoHideDelay: 5000 })
    }
  },
  computed: {
    isVisible() {
      return this.project.specialist_id && DateTime.local().plus({ days: 1 }).toSQLDate() === this.project.ends_on
    },
    datepickerOptions() {
      return {
        min: DateTime.local().plus({ days: 1 }).toJSDate()
      }
    },
    submitUrl() {
      return '/api/projects/' + this.project.id + '/extension'
    }
  }
}
</script>