<template lang="pug">
  .policy-details.position-relative
    h3.policy-details__title Risks
    .policy-actions
      button.btn.btn.btn-default.mr-3 Download
      PolicyRisksModal
        button.btn.btn-dark Add Risk
    .policy-details__body
      Get(risks="/api/business/risks" :etag="etag" :callback="getRisks"): template(v-slot="{risks}"): table.table
        thead
          tr
            th Risk
            th Impact
            th Likelihood
            th Risk level
            th Date created
            th
        tbody
          tr(v-for="risk in risks" :key="risk.id")
            td {{ risk.risk }}
            td {{ risk.likelihood }}
            td Risk level
            td Date created
            td &hellip;
          tr(v-if="!risks.length")
            td(colspan=5) No risks
</template>

<script>
  import PolicyRisksModal from './Modals/PolicyRisksModal'
  import EtaggerMixin from '@/mixins/EtaggerMixin'

  export default {
    mixins: [EtaggerMixin],
    methods: {
      getRisks(risks) {
        console.log(risks)
      }
    },
    components: {
      PolicyRisksModal
    }
  }
</script>
