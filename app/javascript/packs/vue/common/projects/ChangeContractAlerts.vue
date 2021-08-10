<template lang="pug">
  div(v-if="hasChanges || isSuggestionVisible")
    .alert.alert-success.m-b-20(v-if="hasChanges && isMyChange")
      h4.alert-heading Project update requested.
      p.mb-0 Waiting for {{ counterpartyType }} to accept or decline.
    .alert.alert-warning.m-b-20(v-else-if="hasChanges && project.extension.ends_on_only")
      h4.alert-heading {{ counterpartyName }} has requested to extend the deadline to {{ project.extension.ends_on | asDate }}
      p.mb-0
        Post(:action="`${submitUrl}/1`" method="PUT" :model="{confirm:true}" @saved="saved('Deadline extended')")
          button.btn.btn-default.float-right Accept
        Post(:action="`${submitUrl}/1`" method="PUT" :model="{deny:true}" @saved="saved('Deadline extension denied')")
          button.btn.btn-default.float-right.m-r-1 Deny
        | Would you like to proceed?
    .alert.alert-warning.m-b-20(v-else-if="hasChanges")
      h4.alert-heading Contract change requested
      p.mb-0
        | Would you like to proceed?
        ApproveContractChangesModal(:project="project" @saved="$emit('saved')")
    .alert.alert-warning.m-b-20(v-else-if="isSuggestionVisible")
      h4.alert-heading The project's due date is tomorrow.
      p.mb-0
        button.btn.btn-default.float-right(v-b-modal="'ExtendDeadlineModal'") Extend
        | Do you want to extend the deadline?
        b-modal(id="ExtendDeadlineModal" title="Extend Deadline")
          InputDate(v-model="form.ends_on" :errors="errors.ends_on" :options="datepickerOptions") New Due Date
          template(#modal-footer="{ hide }")
            button.btn.btn-link.float-right(@click="hide") Cancel
            Post(:action="submitUrl" :model="form" @errors="errors = $event" @saved="saved('A project extension has been requested')")
              button.btn.btn-dark.float-right Confirm
</template>

<script>
import ApproveContractChangesModal from './ApproveContractChangesModal'
import { DateTime } from 'luxon'

const TYPES = ['Business', 'Specialist']

export default {
  props: {
    project: {
      type: Object,
      required: true
    },
    for: {
      type: String,
      validator: value => TYPES.includes(value),
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
    saved(message) {
      this.toast('Success', message)
      this.$emit('saved')
    }
  },
  computed: {
    counterpartyType() {
      return TYPES.find(type => type !== this.for).toLowerCase()
    },
    counterpartyName() {
      const i = TYPES.indexOf(this.for), { business, specialist } = this.project
      return [business.business_name, `${specialist.first_name} ${specialist.last_name}`][i]
    },
    hasChanges() {
      return this.project.extension && this.project.extension.requester
    },
    isMyChange() {
      return this.hasChanges && this.project.extension.requester.startsWith(this.for)
    },
    isSuggestionVisible() {
      return this.project.specialist_id && DateTime.local().plus({ days: 1 }).toSQLDate() === this.project.ends_on
    },
    datepickerOptions() {
      return { min: DateTime.local().plus({ days: 1 }).toJSDate() }
    },
    submitUrl() {
      return '/api/projects/' + this.project.id + '/extension'
    }
  },
  components: {
    ApproveContractChangesModal
  }
}
</script>
