<template lang="pug">
  b-modal.fade(:id="id" title="Accept Proposal")
    p Please confirm the applicant you wish to hire.
    .card
      .card-body
        SpecialistDetails(:specialist="application.specialist")
        InputSelect(v-model="role" :options="specialistRoleOptions") Select Role
        .form-text.text-muted Determines the permissions the specialist will have access to
    template(#modal-footer="{ hide }")
      button.btn.btn-light(@click="hide") Cancel
      button.btn.btn-outline-dark(@click="$emit('back')") Go Back
      Post(:action="hireUrl + '?job_application_id=' + application.id" :model="{role}" @saved="$emit('saved', application.project.local_project_id, role)")
        button.btn.btn-dark Confirm
</template>

<script>
import SpecialistDetails from './SpecialistDetails'
import { SPECIALIST_ROLE_OPTIONS } from '@/common/ProjectInputOptions'

export default {
  props: {
    id: {
      type: String,
      required: true
    },
    application: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      role: Object.keys(SPECIALIST_ROLE_OPTIONS)[0]
    }
  },
  computed: {
    specialistRoleOptions: () => SPECIALIST_ROLE_OPTIONS,
    hireUrl() {
      return this.$store.getters.url('URL_API_PROJECT_HIRES', this.application.project.id)
    }
  },
  components: {
    SpecialistDetails
  }
}
</script>
