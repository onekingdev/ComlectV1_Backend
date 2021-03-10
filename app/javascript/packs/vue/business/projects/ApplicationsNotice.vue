<template lang="pug">
  Get(v-if="show" :applications='apiUrl'): template(v-slot="{applications}")
    .alert.alert-warning(v-if="applications.length")
      h4.alert-heading {{ 'application' | plural(applications) }} received.
      p There {{ applications | isAre }} currently {{ 'applicant' | plural(applications) }} for your project.
      a.btn.btn-light(:href="viewApplicantsUrl") View
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
    show() {
      return !this.project.specialist_id
    },
    apiUrl() {
      return this.$store.getters.url('URL_API_PROJECT_APPLICATIONS', this.project.id)
    },
    viewApplicantsUrl() {
      return this.$store.getters.url('URL_PROJECT_POST', this.project.id)
    }
  }
}
</script>