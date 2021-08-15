<template lang="pug">
  .policy-details.position-relative
    h3.policy-details__title Version History
    .p-x-20
      .policy-history__body(v-if="policy.versions && policy.versions.length !== 0", v-for="data in policy.versions", :class="[policy.versions.length > 1 ? 'mb-2' : '' ]")
        //.policy-history__version v{{ data.id }}
        //.policy-history__version v
        .policy-history__version-info {{ policy.id - 1 === data.id ? 'Current Version' : `Version ${data.id}` }}
        .policy-history__author Published by ***
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
            // console.log('response', myBlob)
            this.toast('Success', 'Policy succesfully downloaded.')
          })
          .catch((err) => {
            // console.log(err)
            this.toast('Error', err.message, true)
          });
      },
    }
  };
</script>
