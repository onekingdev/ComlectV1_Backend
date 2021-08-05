<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" modal-class="modal-select-control" title="Select Control(s)" @show="newEtag")
      ModelLoader(:url="riskId ? submitUrl : undefined" :default="initialrisk" :etag="etag" @loaded="loadrisk")

        b-row.m-t-1(no-gutters)
          b-card(style="width: 100%")
            table.table
              thead
                tr
                  th(width="10")
                    <!--b-form-checkbox(v-model='form.checked[]')-->
                  th(width="55%") Policy
                  th Status
                    b-icon.ml-2(icon='chevron-expand')
                  th.text-right Last modified
                    b-icon.ml-2(icon='chevron-expand')
                  th.text-right Date created
                    b-icon.ml-2(icon='chevron-expand')
                  th(width="10%")
              tbody
                tr(v-for="(policy, index) in policiesComputed" :key="policy.id")
                  td
                    b-form-checkbox(v-model='form.checked[index]' @change="onChange")
                  td
                    a.link(:href="`/business/compliance_policies/${policy.id}`")
                      ion-icon.mr-2(name="document-text-outline")
                      | {{ policy.name }}
                  td
                    b-badge.status(:variant="statusVariant") {{ policy.status }}
                  td.text-right {{ dateToHuman(policy.updated_at) }}
                  td.text-right {{ dateToHuman(policy.created_at) }}
                  td
                    .actions
                      b-dropdown(size="sm" variant="light" class="m-0 p-0" right)
                        template(#button-content)
                          b-icon(icon="three-dots")
                        b-dropdown-item(:href="`/business/compliance_policies/${policy.id}`") Edit
                        <!--b-dropdown-item-button.delete Delete-->
                tr(v-if="!policiesComputed.length")
                  td.text-center(colspan=5)
                    h4.py-2 No policy

      template(slot="modal-footer")
        .col
          label.m-t-1.form-label.font-weight-bold {{ countSelected }} Items Selected
        .col-justify-content-end
          button.btn.btn-link(@click="$bvModal.hide(modalId)") Cancel
          button.btn.btn-dark(@click="submit") Add
</template>

<script>
  import { DateTime } from 'luxon'
  import EtaggerMixin from '@/mixins/EtaggerMixin'

  const rnd = () => Math.random().toFixed(10).toString().replace('.', '')

  const initialrisk = () => ({
    name: "",
    id: null,
    impact: 0,
    likelihood: 0,
    compliance_policies: [],
    compliance_policy_ids: []
  })

  export default {
    mixins: [EtaggerMixin()],
    props: {
      risks: Array,
      riskId: Number,
      remindAt: String,
      inline: {
        type: Boolean,
        default: true
      },
      risksList: Array,
      policyId: Number,
    },
    data() {
      return {
        modalId: `modal_${rnd()}`,
        risk: initialrisk(),
        errors: [],
        isActive: false,
        options: [
          { value: null, text: 'New Risk' },
        ],
        levelOptions: [
          { value: 0, text: 'Low' },
          { value: 1, text: 'Medium' },
          { value: 2, text: 'High' },
        ],
        badgeVariant: 'secondary',
        riskLevelName: '---',
        form: {
          checked: [],
        },
        statusVariant: 'light',
        countSelected: 0,
      }
    },
    methods: {
      loadrisk(risk) {
        // console.log('risk', risk)
        // console.log('this.risk', this.risk)
        this.risk = Object.assign({}, this.risk, risk)
        // this.onRiskChange()

        // this.options = [{ value: null, text: 'New Risk' }]
        // this.options = this.options.concat(this.risksComputedAsOptions)

        // console.log('this.form.checked', this.form.checked)
        // console.log('policiesComputed', this.policiesComputed)

        this.form.checked = this.policiesComputed.map((policy, index) => {
          // console.log(policy, index)

          let result;
          risk.compliance_policies.forEach((el) => {
            if (el.id === policy.id) result = true
            else result = false
          })
          return result
        })

        this.countingSelected()

        console.log('this.form.checked', this.form.checked)
      },
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      submit(e) {
        e.preventDefault()
        this.errors = [];

        // this.risk.compliance_policy_ids = this.risk.compliance_policies.map(policy => policy.id)

        this.$store
          .dispatch('updateRisk', {...this.risk})
          .then(response => {
            console.log('response', response)
            if (response.errors) {

            } else {
              this.makeToast('Success', 'The risk has been saved')
              this.$bvModal.hide(this.modalId)
              this.newEtag()
            }
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Couldn't submit form! ${error}`)
          })

      },
      countingSelected() {
        // this.countSelected = this.form.checked.reduce((acc, currentValue) => currentValue ? acc++ : acc--, 0)
        this.countSelected = 0
        this.form.checked.forEach((el) => {
          if (el === true) this.countSelected++
        })
        // console.log('this.countSelected', this.countSelected)
      },
      onChange(event){
        // console.log(event)
        // console.log('this.form.checked', this.form.checked)

        this.risk.compliance_policy_ids = []
        this.policiesComputed.forEach((policy, index) => {
          if (this.form.checked[index]) this.risk.compliance_policy_ids.push(policy.id)
        })

        // console.log(this.risk.compliance_policy_ids)
        this.countingSelected()
      },
      onRiskChange(){
        const riskLevelNum = this.riskLevel(this.risk.likelihood, this.risk.impact)
        this.riskLevelColor(riskLevelNum)
        this.getRiskLevelName(riskLevelNum)
      },
      getRiskLevelName(num) {
        this.riskLevelName = this.levelOptions[num].text
      },
      riskLevel(likelihood, impact) {
        if ((likelihood > 0) && (impact === 2)) {
          return 2;
        } else if ((likelihood < 2) && (impact === 0)) {
          return 0;
        } else {
          return 1;
        }
      },
      riskLevelColor(num) {
        if (num === 0) this.badgeVariant = 'success'
        if (num === 1) this.badgeVariant = 'warning'
        if (num === 2) this.badgeVariant = 'danger'
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
    },
    computed: {
      initialrisk: () => initialrisk,
      canBeDraft() {
        return !this.riskId || ('draft' === this.risk.status)
      },
      submitUrl() {
        const toId = this.riskId ? `/${this.riskId}` : ''
        return '/api/business/risks' + toId
      },
      httpMethod() {
        return this.riskId ? 'PUT' : 'POST'
      },
      risksComputedAsOptions() {
        return this.risks.map(risk => {
          return {
            value: risk.id, text: risk.name
          }
        })
      },
      policiesComputed() {
        return this.$store.getters.policiesList
      },
    },
    watch: {},
    mounted() {

    }
  }
</script>

<style>
  @media (min-width: 576px) {
    .modal-select-control .modal-dialog {
      max-width: 1200px;
    }
  }
</style>
