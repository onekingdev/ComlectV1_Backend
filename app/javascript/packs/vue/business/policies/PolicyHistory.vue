<template lang="pug">
  div.policy-history
    h3.policy-history__title Version History
    .policy-history__body(v-if="policy.versions", v-for="data in policy.versions", :class="[policy.versions.length > 1 ? 'mb-2' : '' ]")
      .policy-history__version v{{ data.id }}
      .policy-history__version-info {{ policy.id === data.src_id ? 'Current Version' : 'Previous Version' }}
      .policy-history__author Published by ***
      .policy-history__date Last updated {{ dateToHuman(data.updated_at) }}
    .policy-history__body(v-else)
      h3 Version History is empty
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
          return date.toFormat('dd/MM/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
    }
  };
</script>
