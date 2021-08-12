<template lang="pug">
  div.h-100
    .row.m-b-20
      .col-lg-4.col-12
        .position-relative
          b-icon.icon-searh(icon='search')
          input.form-control.form-control_search(type="text" placeholder="Search" v-model="searchInput", @keyup="searching")
          button.btn-clear(v-if="isActive" @click="clearInput")
            b-icon.icon-clear(icon='x-circle')
      .col-4(v-if="filteredRisksComputed.length !== 0 && searchInput")
        p Found {{ filteredRisksComputed.length }} {{ filteredRisksComputed.length === 1 ? 'result' : 'results' }}
    .row.h-100(v-if="!filteredRisksComputed.length && !loading")
      .col.h-100.text-center
        EmptyState
    .row
      .col-12
        Loading
        table.table(v-if="!loading && filteredRisksComputed && filteredRisksComputed.length")
          thead
            tr
              th Name
                b-icon.ml-2(icon='chevron-expand')
              th Impact
                b-icon.ml-2(icon='chevron-expand')
              th Likelihood
                b-icon.ml-2(icon='chevron-expand')
              th Risk level
                b-icon.ml-2(icon='chevron-expand')
              th.text-right Date created
                b-icon.ml-2(icon='chevron-expand')
              th.text-right(width="35px")
          tbody
            tr(v-for="risk in filteredRisksComputed" :key="risk.id")
              td
                .d-flex.align-items-center.link.truncate
                  .dropdown-toggle(v-if="risk.compliance_policies.length !== 0" :id="`#sectionIcon-${risk.id}`", @click="toogleSections(risk.id)")
                    b-icon.m-r-1(icon="chevron-right")
                  a(:href="`/business/risks/${risk.id}`") {{ risk.name }}
                .dropdown-items.mb-2(v-if="risk.compliance_policies" :id="`#section-${risk.id}`")
                  ul.list-unstyled.ml-3
                    li.mb-2(v-for="policy in risk.compliance_policies" :key="policy.id")
                      a.link(:href="`/business/compliance_policies/${policy.id}`")
                        ion-icon.mr-2(name="document-text-outline")
                        | {{ policy.name }}
              td {{ showLevel(risk.impact) }}
              td {{ showLevel(risk.likelihood) }}
              td
                b-badge.badge-risk(:variant="badgeVariant(risk.risk_level)")
                  b-icon-exclamation-triangle-fill.mr-2
                  | {{ showLevel(risk.risk_level)  }}
              td.text-right {{ dateToHuman(risk.created_at) }}
              td.text-right
                .actions
                  b-dropdown(size="xs" variant="none" class="m-0 p-0" right)
                    template(#button-content)
                      b-icon(icon="three-dots")
                    RisksAddEditModal(:risks="risksComputed" :riskId="risk.id" :inline="false")
                      b-dropdown-item-button Edit
                    b-dropdown-item-button.delete(@click="deleteRisk(risk.id)") Delete

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import RisksAddEditModal from './Modals/RisksAddEditModal'
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  import { DateTime } from 'luxon'

  export default {
    mixins: [EtaggerMixin()],
    props: {

    },
    components: {
      Loading,
      RisksAddEditModal
    },
    data() {
      return {
        levelOptions: ['Low', 'Medium', 'High'],
        open: true,
        searchInput: '',
        isActive: false,
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
            this.toast('Success', `Risk successfully deleted!`)
          })
          .catch(error => {
            this.toast('Error', `Couldn't delete risk! ${error}`)
          })
      },
      searching () {
        if(this.searchInput.length) this.isActive = true
        this.$emit('searching', this.searchInput)
      },
      clearInput() {
        this.searchInput = ''
        this.isActive = false
        this.$emit('searching', this.searchInput)
      },
      toogleSections(value) {
        console.log(value)
        console.log(document.getElementById(`#section-${value}`))
        document.getElementById(`#section-${value}`).classList.toggle('active');
        document.getElementById(`#sectionIcon-${value}`).classList.toggle('active');
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      risksComputed() {
        return this.$store.getters.risksList
      },
      filteredRisksComputed () {
        return this.risksComputed.filter(risk => {
          return risk.name?.toLowerCase().includes(this.searchInput.toLowerCase())
        })
      },
    },
    mounted() {
      this.$store
        .dispatch('getRisks')
        .then(response => {
          console.log('response', response)
          // this.toast('Success', `Policy successfully deleted!`)
        })
        .catch(error => {
          console.error(error)
          // this.toast('Error', `Couldn't submit form! ${error}`)
        })
    }
  }
</script>

<style scoped>
  .policy-details .policy-actions {
    top: 1.5rem;
  }
</style>
