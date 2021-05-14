<template lang="pug">
  b-modal.fade(:id="id" title="Extend Deadline")
    p Please confirm the applicant you wish to hire.
    .card
      .card-body
        InputDate(v-model="project.ends_on" :errors="errors.ends_on" :options="datepickerOptions")
    template(#modal-footer="{ hide }")
      button.btn.btn-light(@click="hide") Cancel
      Post(:action="extendUrl" :model="{project}" @saved="$emit('saved', project.ends_on)")
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
    project: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      // project: {
      //   ends_on: '5/14/2021'
      // },
      errors: {}
    }
  },
  computed: {
    extendUrl() {
      return this.$store.getters.url('URL_API_PROJECT_HIRES', this.project.ends_on)
    },
    datepickerOptions() {
      return {
        min: new Date
      }
    },
  },
}
</script>
