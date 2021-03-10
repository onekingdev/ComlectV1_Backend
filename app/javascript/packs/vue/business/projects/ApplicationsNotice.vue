<template lang="pug">
  Get(v-if="show" :applications='apiUrl'): template(v-slot="{applications}")
    .alert.alert-warning(v-if="applications.length")
      h4.alert-heading {{ 'application' | plural(applications) }} received.
      p There {{ applications | isAre }} currently {{ 'applicant' | plural(applications) }} for your project.
      a.btn.btn-light(:href="viewPostUrl") View
    .alert.alert-info(v-else)
      h4.alert-heading Your project is currently posted on the job board as of {{ project.created_at | asDate }}.
      p Keep an eye out! Specialists may reach out to you soon.
      a.btn.btn-light(:href="viewPostUrl") View
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
    viewPostUrl() {
      return this.$store.getters.url('URL_PROJECT_POST', this.project.id)
    }
  }
}
</script>