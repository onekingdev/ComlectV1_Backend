<template lang="pug">
  Get(v-if="show" :applications='apiUrl'): template(v-slot="{applications}")
    .alert.alert-warning(v-if="applications.length")
      .d-flex.justify-content-between
        div.d-flex.align-items-center
          b-icon.mr-4(icon="exclamation-triangle-fill" scale="2" variant="warning")
          div
            h4.alert-heading {{ 'application' | plural(applications) }} received.
            p.mb-0 There {{ applications | isAre }} currently {{ 'applicant' | plural(applications) }} for your project.
        div
          router-link.btn.btn-light.mt-2(:to="viewPostUrl") View
    .alert.alert-info(v-else)
      div(v-if="project.status == 'published'")
        h4.alert-heading Your project is currently posted on the job board as of {{ project.created_at | asDate }}.
        p Keep an eye out! Specialists may reach out to you soon.
      div(v-else)
        h4.alert-heading Yout project is currently draft
      router-link.btn.btn-light(:to="viewPostUrl") View
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
