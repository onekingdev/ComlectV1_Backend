<template lang="pug">
  .alert.alert-warning(v-if="isVisible")
    h4.alert-heading The project's due date is tomorrow.
    p
      button.btn.btn-default.float-right(v-b-modal="'ExtendDeadlineModal'") Extend
      | Do you want to extend the deadline?
      b-modal(id="ExtendDeadlineModal" title="Extend Deadline")
        InputDate(v-model="form.ends_on" :options="datepickerOptions") New Due Date
        template(#modal-footer="{ hide }")
          button.btn.btn-default.float-right(@click="hide") Cancel
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
      form: { ends_on: null }
    }
  },
  computed: {
    isVisible() {
      return DateTime.local().plus({ days: 1 }).toSQLDate() === this.project.ends_on
    },
    datepickerOptions() {
      return {
        min: DateTime.local().plus({ days: 1 }).toJSDate()
      }
    }
  }
}
</script>