<template lang="pug">
  .alert(v-if="isSuggestionVisible || hasUpdate" :class="alertClass")
    div(v-if="hasUpdate")
      h4.alert-heading Project update requested.
      p Waiting for specialist to accept or decline.
    div(v-else-if="isSuggestionVisible")
      h4.alert-heading The project's due date is tomorrow.
      p
        button.btn.btn-default.float-right(v-b-modal="'ExtendDeadlineModal'") Extend
        | Do you want to extend the deadline?
        b-modal(id="ExtendDeadlineModal" title="Extend Deadline")
          InputDate(v-model="form.ends_on" :errors="errors.ends_on" :options="datepickerOptions") New Due Date
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
      form: {
        ends_on_only: true,
        ends_on: null
      },
      errors: {}
    }
  },
  methods: {
    saved() {
      this.toast('Success', 'A project extension has been requested')
      this.$emit('saved')
    }
  },
  computed: {
    alertClass() {
      return this.hasUpdate ? 'alert-info' : this.isSuggestionVisible ? 'alert-warning' : ''
    },
    hasUpdate() {
      return this.project.extension && this.project.extension.requester
          && this.project.extension.requester.startsWith('Business')
    },
    isSuggestionVisible() {
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