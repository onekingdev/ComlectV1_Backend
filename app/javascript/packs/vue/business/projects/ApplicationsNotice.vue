<template lang="pug">
  Get(:applications='apiUrl'): template(v-slot="{applications}")
    .alert.alert-warning(v-if="applications.length")
      h4.alert-heading {{ 'application' | plural(applications) }} received.
      p There are currently {{ 'applicant' | plural(applications) }} for your project.
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
    apiUrl() {
      return this.$store.getters.url('URL_API_PROJECT_APPLICATIONS', this.project.visible_project.id)
    },
    viewApplicantsUrl() {
      return this.$store.getters.url('URL_PROJECT_APPLICATIONS', this.project.visible_project.id)
    }
  }
}
</script>