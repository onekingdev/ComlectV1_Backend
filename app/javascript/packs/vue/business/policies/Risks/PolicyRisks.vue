<template lang="pug">
  .policy-details.position-relative
    h3.policy-details__title Risks
    .policy-actions
      button.btn.btn.btn-default.mr-3 Download
      PolicyRisksModal(:risks="risksComputed" :policyId="policyId")
        button.btn.btn-dark Add Risk
    .policy-details__body
      Loading
      table.table(v-if="!loading")
        thead
          tr
            th(width="55%") Risk
            th Impact
            th Likelihood
            th Risk level
            th.text-right Date created
            th(width="10%")
        tbody
          tr(v-for="risk in risksComputed" :key="risk.id")
            td ({{ risk.id }}) {{ risk.name }}
            td {{ showLevel(risk.impact) }}
            td {{ showLevel(risk.likelihood) }}
            td
              b-badge(:variant="badgeVariant(risk.risk_level)")
                b-icon-exclamation-triangle-fill.mr-2
                | {{ showLevel(risk.risk_level)  }}
            td.text-right {{ dateToHuman(risk.created_at) }}
            td
              .actions
                b-dropdown(size="sm" text="***" class="m-0 p-0" variant="light" right)
                  PolicyRisksModal(:risks="risksComputed" :policyId="policyId" :riskId="risk.id" :inline="false")
                    b-dropdown-item-button Edit
                  b-dropdown-item-button.delete(@click="deleteRisk(risk.id)") Delete
          tr(v-if="!risksComputed.length")
            td.text-center(colspan=5)
              h4.py-2 No risks
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import PolicyRisksModal from '../Modals/Risks/PolicyRisksModal'
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  import { DateTime } from 'luxon'

  export default {
    mixins: [EtaggerMixin],
    props: {
      policyId: {
        type: Number,
        required: true
      },
    },
    components: {
      Loading,
      PolicyRisksModal
    },
    data() {
      return {
        levelOptions: ['low', 'medium', 'high'],
      }
    },
    methods: {
      getRisks(risks) {
        console.log('risks', risks)
        return risks
      },
      badgeVariant(num) {
        if (num === 0) return 'success'
        if (num === 1) return 'warning'
        if (num === 2) return 'danger'
      },
      showLevel(num) {
        // this.riskLevelColor(num)
        return this.levelOptions[num]
      },
      dateToHuman(value) {
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          return date.toFormat('dd/MM/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
      deleteRisk(riskId) {
        this.$store
          .dispatch('deleteRisk', { id: riskId })
          .then(response => {
            this.makeToast('Success', `Risk successfully deleted!`)
          })
          .catch(error => {
            this.makeToast('Error', `Couldn't delete risk! ${error}`)
          })
      },
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      risksComputed() {
        return this.$store.getters.risksList
      }
    },
    mounted() {
      this.$store
        .dispatch('getRisks')
        .then(response => {
          console.log('response', response)
          // this.makeToast('Success', `Policy successfully deleted!`)
        })
        .catch(error => {
          console.error(error)
          // this.makeToast('Error', `Couldn't submit form! ${error}`)
        })
    }
  }
</script>

<style scoped>
  .policy-details .policy-actions {
    top: 1.5rem;
  }
</style>
