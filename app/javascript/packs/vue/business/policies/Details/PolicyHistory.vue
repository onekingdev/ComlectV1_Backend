<template lang="pug">
  div.policy-history
    h3.policy-history__title Version History
    .policy-history__body(v-if="policy.versions.length !== 0", v-for="data in policy.versions", :class="[policy.versions.length > 1 ? 'mb-2' : '' ]")
      .policy-history__version v{{ data.id }}
      .policy-history__version-info {{ policy.id - 1 === data.id ? 'Current Version' : 'Previous Version' }}
      .policy-history__author Published by ***
      .policy-history__date Last updated {{ dateToHuman(data.updated_at) }}
      b-button.btn.policy-history__btn-download(@click="download(policy.id)") Download
    .policy-history__body.text-center.pl-0(v-if="policy.versions.length === 0")
      h4 Version History is empty
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
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      dateToHuman (value) {
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          return date.toFormat('dd/MM/yyyy')
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
            this.makeToast('Success', 'Policy succesfully downloaded.')
          })
          .catch((err) => {
            // console.log(err)
            this.makeToast('Error', err.message)
          });
      },
    }
  };
</script>
