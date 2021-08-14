<template lang="pug">
  .policy-details.position-relative
    h3.policy-details__title Risks
    .policy-actions
      //button.btn.btn.btn-default.mr-3 Download
      PolicyRisksModal(:risks="risksComputed" :policyId="policyId" @saved="savedConfirmed")
        button.btn.btn-dark Add Risk
    .policy-details__body
      table.table
        thead
          tr
            th(width="45%") Risk Name
              b-icon.ml-2(icon='chevron-expand')
            th Impact
              b-icon.ml-2(icon='chevron-expand')
            th Likelihood
              b-icon.ml-2(icon='chevron-expand')
            th Risk Level
              b-icon.ml-2(icon='chevron-expand')
            th.text-right Date Created
              b-icon.ml-2(icon='chevron-expand')
            th(width="35px")
        tbody.text-dark(v-if="!loading && policyById.risks && policyById.risks.length")
          tr(v-for="risk in policyById.risks" :key="risk.id")
            td {{ risk.name }}
            td {{ showLevel(risk.impact) }}
            td {{ showLevel(risk.likelihood) }}
            td
              b-badge.badge-risk(:variant="badgeVariant(risk.risk_level)")
                b-icon-exclamation-triangle-fill.mr-2
                | {{ showLevel(risk.risk_level)  }}
            td.text-right {{ dateToHuman(risk.created_at) }}
            td
              .actions
                b-dropdown(size="sm" variant="light" class="m-0 p-0" right)
                  template(#button-content)
                    b-icon(icon="three-dots")
                  PolicyRisksModal(:risks="risksComputed" :policyId="policyId" :riskId="risk.id" :inline="false")
                    b-dropdown-item-button Edit
                  b-dropdown-item-button.delete(@click="deleteRisk(risk.id)") Delete
      Loading
      EmptyState(v-if="!loading && policyById.risks && !policyById.risks.length")
</template>

<script>
  // @TODO REVIEW STRUCTURE AND REBUILD

  import Loading from '@/common/Loading/Loading'
  import PolicyRisksModal from '../Modals/Risks/PolicyRisksModal'
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  import { DateTime } from 'luxon'

  export default {
    mixins: [EtaggerMixin()],
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
        levelOptions: ['Low', 'Medium', 'High'],
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
          return date.toFormat('MM/dd/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
      deleteRisk(riskId) {
        const riskById = this.$store.getters.riskById(riskId)
        const index = riskById.compliance_policies.findIndex(risk => risk.id === riskId)
        riskById.compliance_policies.splice(index, 1)
        this.policyById.risks.splice(index, 1)

        const dataToSend = {
          id: riskId,
          compliance_policy_ids: riskById.compliance_policies.map(pol => pol.id)
        };

        this.$store
          .dispatch('updateRisk', {...dataToSend})
          .then(response => {
            // console.log('response', response)
            this.toast('Success', 'Changes saved')
          })
          .catch(error => {
            console.error(error)
            this.toast('Error', `Couldn't submit form! ${error}`, true)
          })
      },
      savedConfirmed(value){
        this.toast('Success', 'The risk has been saved')
        console.log('savedConfirmed value', value)
        //HOOK
        // const index = this.policyById.risks.findIndex(record => record.id === value.id);
        // console.log('index', index)
        // if (index) this.policyById.risks.splice(index, 1, value)
        this.policyById.risks.push(value)
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      risksComputed() {
        return this.$store.getters.risksList
      },
      policyById(){
        const id = this.policyId
        return this.$store.getters.policyById(id)
      }
    },
    mounted() {
      this.$store
        .dispatch('getRisks')
        .then(response => {
          // console.log('response', response)
          // this.toast('Success', `Policy successfully deleted!`)
        })
        .catch(error => {
          console.error(error)
          // this.toast('Error', `Couldn't submit form! ${error}`)
        })
    }
  }
</script>
