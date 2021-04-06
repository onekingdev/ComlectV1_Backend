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
            th(width="40%") Risk
            th Impact
            th Likelihood
            th Risk level
            th Date created
            th
        tbody
          tr(v-for="risk in risks" :key="risk.id")
            td ({{ risk.id }}) {{ risk.name }}
            td {{ showLevel(risk.impact) }}
            td {{ showLevel(risk.likelihood) }}
            td rl
            td {{ risk.created_at }}
            td &hellip;
          tr(v-if="!risks.length")
            td.text-center(colspan=5)
              h4.py-2 No risks
</template>

<script>
  import PolicyRisksModal from '../Modals/Risks/PolicyRisksModal'
  import EtaggerMixin from '@/mixins/EtaggerMixin'

  export default {
    mixins: [EtaggerMixin],
    props: {
      policyId: {
        type: Number,
        required: true
      },
    },
    data() {
      return {
        levelOptions: ['low', 'medium', 'high']
      }
    },
    methods: {
      getRisks(risks) {
        console.log('risks', risks)
        return risks
      },
      showLevel(num) {
        return this.levelOptions[num]
      },
    },
    components: {
      PolicyRisksModal
    }
  }
</script>

<style scoped>
  .policy-details .policy-actions {
    top: 1.5rem;
  }
</style>
