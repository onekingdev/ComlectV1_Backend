<template lang="pug">
  .alert.alert-warning(v-if="isVisible")
    h4.alert-heading The project's due date is tomorrow.
    p
      button.btn.btn-default.float-right(@click="extend") Extend
      | Do you want to extend the deadline?
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
  methods: {
    extend() {
    }
  },
  computed: {
    isVisible() {
      return DateTime.local().plus({ days: 1 }).toSQLDate() === this.project.ends_on
    }
  }
}
</script>