<template lang="pug">
  .page
    div(v-if="loading")
      Loading
    .page-header(v-if="!loading")
      .page-header__title
        h2: b {{ pageTitle }} / {{ riskComputed.name }}
        h2
          b-badge.mr-2(:variant="badgeVariant(riskComputed.risk_level)") {{ showLevel(riskComputed.risk_level) }}
          b {{ riskComputed.name }}
      .page-header__actions
        b-dropdown.bg-white(text='Actions', variant="secondary", right)
          RiskModalDelete(@deleteConfirmed="deleteRisk", :riskId="riskComputed.id", :inline="false")
            b-dropdown-item.delete Delete risk
    .card-body.white-card-body.card-body_full-height(v-if="!loading")
      div.mb-3
        b-card-group(deck)
          b-card(header-tag='header' header-class='d-flex')
            template(#header)
              h3.mb-0.font-weight-bold Risk Details
              RisksAddEditModal.ml-auto(:riskId="riskComputed.id" :inline="false")
                button.btn.btn-light Edit
            b-card-text
              .row
                .col-lg-2.col-md-3.col-4.pr-0
                  b-list-group.text-secondary
                    b-list-group-item.border.border-white.pb-0.pt-0 Title
                    b-list-group-item.border.border-white.pb-0 Impact
                    b-list-group-item.border.border-white.pb-0 Likelihood
                .col.pl-0
                  b-list-group
                    b-list-group-item.border.border-white.pb-0.pt-0 {{ riskComputed.name }}
                    b-list-group-item.border.border-white.pb-0 {{ showLevel(riskComputed.impact) }}
                    b-list-group-item.border.border-white.pb-0 {{ showLevel(riskComputed.likelihood) }}
      div
        b-card-group(deck)
          b-card(header-tag='header' header-class='d-flex')
            template(#header)
              h3.mb-0.font-weight-bold Controls
              RiskContols.ml-auto(:riskId="riskComputed.id" :inline="false")
                button.btn.btn-light {{ !riskComputed.compliance_policies && !riskComputed.compliance_policies.length ? 'Add' : 'Edit' }} Control
            b-card-text
              PoliciesTable(:riskPolicies="riskComputed.compliance_policies", @deleteControl="updateRisk")
            b-card-text(v-if="!riskComputed.compliance_policies && !riskComputed.compliance_policies.length")
              div.no-results.text-center
                b-icon(icon="files" scale="5" variant="dark")
                p.no-results__title: b No results found
                p Add a policy as a control to get started
                RiskContols(:riskId="riskComputed.id" :inline="false")
                  button.btn.btn-dark Add Control
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import RiskModalDelete from "./Modals/RiskModalDelete";
  import RisksAddEditModal from './Modals/RisksAddEditModal'
  import RiskContols from './Modals/RiskContols'
  import PoliciesTable from './PoliciesTable'

  export default {
    props: ['riskId'],
    components: {
      Loading,
      RiskModalDelete,
      RisksAddEditModal,
      RiskContols,
      PoliciesTable
    },
    data() {
      return {
        pageTitle: 'Risk Register',
        levelOptions: ['Low', 'Medium', 'High'],
        risk: {
          compliance_policies: [],
          created_at: "",
          id: null,
          impact: null,
          likelihood: null,
          name: "",
          risk_level: null,
          updated_at: "",
        },
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      deleteRisk() {
        console.log('delete risk', this.riskId)
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
      updateRisk(policyId) {
        const index = this.risk.compliance_policies.findIndex(record => record.id === policyId);
        this.riskComputed.compliance_policies.splice(index, 1)

        this.riskComputed.compliance_policy_ids = this.riskComputed.compliance_policies.map(policy => policy.id)

        this.$store
          .dispatch('updateRisk', {...this.riskComputed})
          .then(response => {
            console.log('response', response)
            this.makeToast('Success', 'The risk has been updated!')
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Couldn't submit form! ${error}`)
          })
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      riskComputed() {
        return this.$store.getters.getCurrentRisk;
        // const id = this.riskId;
        // return this.$store.getters.riskById(id);
      },
    },
    watch: {

    },
    mounted() {
      // console.log(this.riskId)
      this.$store
        .dispatch("getRiskById", { riskId: this.riskId })
        .then((response) => {
          // this.risk = response;
          console.log('response mounted getRiskById', response);
        })
        .catch((err) => {
          console.error(err);
          this.makeToast('Error', err.message)
        })
        .finally(() => {
          // AFTER PREV REQUEST SEND NEW
          this.$store
            .dispatch("getPolicies")
            .then((response) => {
              console.log('response mounted getPolicies', response);
            })
            .catch((err) => {
              console.error(err);
              this.makeToast('Error', err.message)
            });
        })
    },

  };
</script>

<style scoped>
  .no-results {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 20rem;
  }
  .no-results__title {
    font-size: 1.3rem;
  }
  .no-results svg {
    margin-bottom: 4rem;
  }
</style>
