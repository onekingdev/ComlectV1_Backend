<template lang="pug">
  Get(v-if="show" :applications='apiUrl' :callback="getApplications"): template(v-slot="{applications}")
    .alert.alert-warning(v-if="applications.length")
      .d-flex.justify-content-between
        div.d-flex.align-items-center
          b-icon.mr-4(icon="exclamation-triangle-fill" scale="2" variant="warning")
          div
            h4.alert-heading {{ 'application' | plural(applications) }} received.
            p.mb-0 There {{ applications | isAre }} currently {{ 'applicant' | plural(applications) }} for your project.
        div
          router-link.btn.btn-light.mt-2(:to="viewPostUrl") View
    div(v-else)
      Notifications.m-b-20(:notify="applications")
        router-link.btn.btn-light.m-r-1(:to="viewPostUrl") View

</template>

<script>
import Notifications from "@/common/Notifications/Notifications";
export default {
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  components: {
    Notifications,
  },
  data() {
    return {
      // notify: {
      //   show: 'show',
      //   mainText: `Your project is currently posted on the job board as of ${ project.created_at | asDate }.`,
      //   subText: 'Keep an eye out! Specialists may reach out to you soon.',
      //   variant: 'primary',
      //   dismissible: true,
      //   icon: null,
      //   scale: 2,
      // },
    }
  },
  methods: {
    getApplications(applications) {
      console.log('aap-s', applications)

      let notify = {}

      //if (applications.length) {
      //  notify = {
      //    show: 'show',
      //    mainText: `'application' ${ this.$options.filters.plural(applications) } received.`,
      //    subText: `There ${ this.$options.filters.isAre(applications) } currently ${ this.$options.filters.plural(applications) } for your project.`,
      //    variant: 'primary',
      //    dismissible: true,
      //    icon: null,
      //    scale: 2,
      //  }
      //  return notify
      //}

      if (this.project.status === 'published') {
        notify = {
          show: 'show',
          mainText: `Your project is currently posted on the job board as of ${ this.$options.filters.asDate(this.project.created_at) }.`,
          subText: 'Keep an eye out! Specialists may reach out to you soon.',
          variant: 'primary',
          dismissible: true,
          icon: null,
          scale: 2,
        }
      } else {
        notify = {
          show: 'show',
          mainText: `Your posting is currently in draft`,
          subText: 'Finish the posting to send it to our job board',
          variant: 'primary',
          dismissible: true,
          icon: null,
          scale: 2,
        }
      }

      return notify
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
