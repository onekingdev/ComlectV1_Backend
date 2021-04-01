<template lang="pug">
  div(v-if="isSuggestionVisible || hasUpdate || isVisible")
    .alert.alert-info(v-if="hasUpdate")
      h4.alert-heading Project update requested.
      p Waiting for specialist to accept or decline.
    .alert.alert-warning(v-else-if="isSuggestionVisible")
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
    .alert.alert-warning(v-else-if="isVisible")
      h4.alert-heading Contract change requested
      p.d-flex.justify-content-between
        | Would you like to proceed?
        ApproveContractChangesModal(:project="project" @saved="$emit('saved')")
</template>

<script>
import { DateTime } from 'luxon'
import ApproveContractChangesModal from '@/common/projects/ApproveContractChangesModal'

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
    },
    isVisible() {
      return this.project.extension && this.project.extension.requester
          && this.project.extension.requester.startsWith('Specialist')
    }
  },
  components: {
    ApproveContractChangesModal
  }
}
</script>