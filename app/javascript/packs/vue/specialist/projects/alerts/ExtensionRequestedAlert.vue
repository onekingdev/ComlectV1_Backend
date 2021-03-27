<template lang="pug">
  .alert.alert-warning(v-if="isVisible")
    h4.alert-heading {{ project.business.business_name }} has requested to extend the deadline to {{ project.extension.new_end_date | asDate }}
    p
      button.btn.btn-default.float-right Accept
      button.btn.btn-default.float-right.m-r-1 Deny
      | Would you like to proceed?
</template>

<script>
export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  computed: {
    isVisible() {
      return this.project.extension
    }
  }
}
</script>