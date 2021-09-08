<template lang="pug">
  .policy-details.position-relative
    h3.policy-details__title Version History
    .p-x-20
      .policy-history__body(v-if="policy.versions && policy.versions.length !== 0", v-for="(data,i) in policy.versions", :class="[policy.versions.length > 1 ? 'mb-2' : '' ]")
        //.policy-history__version v{{ data.id }}
        //.policy-history__version v
        .policy-history__version-info {{ `Version ${policy.versions.length-i}` }}
        .policy-history__author Published by {{ data.published_by }}
        .policy-history__date Last updated {{ dateToHuman(data.updated_at) }}
        b-button.btn.policy-history__btn-download(@click="download(policy.id)") Download
      .policy-details__body(v-if="policy.versions && policy.versions.length === 0")
        EmptyState
</template>

<script>
  import { DateTime } from 'luxon'
  export default {
    props: ['policy'],
    data() {
      return {

      }
    },
    computed: {
      userName() {
        const accountInfo = localStorage.getItem('app.currentUser')
        const accountInfoParsed = JSON.parse(accountInfo)
        if (accountInfoParsed) {
          const fullName = accountInfoParsed.contact_first_name
            ? `${accountInfoParsed.contact_first_name} ${accountInfoParsed.contact_last_name}`
            : `${accountInfoParsed.first_name} ${accountInfoParsed.last_name}`
          return (fullName !== 'undefined undefined') ? fullName : ''
        }

        return ''
      },
    },
    methods: {
      dateToHuman (value) {
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          return date.toFormat('MM/dd/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
      download (policyId) {
        this.$store
          .dispatch("downloadPolicy", { policyId })
          .then((myBlob) => {
            this.toast('Success', 'Policy has been queued for download.')
          })
          .catch((err) => {
            this.toast('Error', "Policy has not been queued for download. Please try again. "+err.message, true)
          });
      },
    }
  };
</script>
