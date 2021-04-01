<template lang="pug">
  div(v-if="incomingChanges || myChanges || isSuggestionVisible")
    .alert.alert-info(v-if="myChanges")
      h4.alert-heading Project update requested.
      p Waiting for {{ counterparty.toLowerCase() }} to accept or decline.
    .alert.alert-warning(v-else-if="incomingChanges && project.extension.ends_on_only")
      h4.alert-heading {{ counterpartyName }} has requested to extend the deadline to {{ project.extension.ends_on | asDate }}
      p
        Post(:action="apiUrl" method="PUT" :model="{confirm:true}" @saved="saved(true)")
          button.btn.btn-default.float-right Accept
        Post(:action="apiUrl" method="PUT" :model="{deny:true}" @saved="saved(false)")
          button.btn.btn-default.float-right.m-r-1 Deny
        | Would you like to proceed?
    .alert.alert-warning(v-else-if="incomingChanges")
      h4.alert-heading Contract change requested
      p
        | Would you like to proceed?
        ApproveContractChangesModal(:project="project" @saved="$emit('saved')")
    .alert.alert-warning(v-else-if="isSuggestionVisible")
      h4.alert-heading The project's due date is tomorrow.
      p
        button.btn.btn-default.float-right(v-b-modal="'ExtendDeadlineModal'") Extend
        | Do you want to extend the deadline?
        b-modal(id="ExtendDeadlineModal" title="Extend Deadline")
          InputDate(v-model="form.ends_on" :errors="errors.ends_on" :options="datepickerOptions") New Due Date
          template(#modal-footer="{ hide }")
            button.btn.btn-default.float-right(@click="hide") Cancel
            Post(:action="submitUrl" :model="form" @errors="errors = $event" @saved="savedTwo")
              button.btn.btn-dark.float-right Confirm
</template>

<script>
import ApproveContractChangesModal from '@/common/projects/ApproveContractChangesModal'
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
    saved(isAccepted) {
      this.toast('Success', isAccepted ? 'Deadline extended' : 'Deadline extension denied')
      this.$emit('saved')
    },
    savedTwo() {
      this.toast('Success', 'A project extension has been requested')
      this.$emit('saved')
    }
  },
  computed: {
    counterparty() {
      return TYPES.find(type => type !== this.for)
    },
    counterpartyName() {
      return this.for === 'Business'
        ? this.project.business.business_name
        : `${this.project.specialist.first_name} ${this.project.specialist.last_name}`
    },
    myChanges() {
      return this.project.extension && this.project.extension.requester
          && this.project.extension.requester.startsWith(this.for)
    },
    incomingChanges() {
      return this.project.extension && this.project.extension.requester
          && this.project.extension.requester.startsWith(this.counterparty)
    },
    apiUrl() {
      return '/api/projects/' + this.project.id + '/extension/' + 1
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
  },
  components: {
    ApproveContractChangesModal
  }
}
</script>