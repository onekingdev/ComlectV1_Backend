<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="riskId ? 'Edit risk' : 'New risk'" @show="newEtag")
      ModelLoader(:url="riskId ? submitUrl : undefined" :default="initialrisk" :etag="etag" @loaded="loadrisk")
        <!--label.form-label Risk-->
        b-form-group#input-group-1(label='Risk' label-for='select-1')
          b-form-select#select-1(v-model='risk.risks' :options='options' @change="onChange" required)
          Errors(:errors="errors.risk")

        b-row.m-t-1(no-gutters, v-if="isActive || risk.name")
          .col
            label.form-label Risk Name
            input.form-control(v-model="risk.name" type=text placeholder="Enter the name of your risk")
            Errors(:errors="errors.name")

        b-row.m-t-1(no-gutters)
          .col-sm.m-r-1
            b-form-group#input-group-2(label='Impact' label-for='select-2')
              b-form-select#select-2(v-model="risk.impact" :errors="errors.impact" :options="levelOptions" @change="onRiskChange")
              Errors(:errors="errors.impact")
          .col-sm
            b-form-group#input-group-3(label='Likelihood' label-for='select-3')
              b-form-select#select-3(v-model="risk.likelihood" :errors="errors.likelihood" :options="levelOptions" @change="onRiskChange")
              Errors(:errors="errors.likelihood")

        b-row.m-t-1(no-gutters)
          .col
            label.m-t-1.form-label Risk Level
            p
              b-icon.mr-3(icon="exclamation-triangle-fill" scale="1" :variant="badgeVariant")
              | {{ riskLevelName }}

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-dark(@click="submit") {{ riskId ? 'Save' : 'Add' }}
</template>

<script>
import { DateTime } from 'luxon'
import EtaggerMixin from '@/mixins/EtaggerMixin'

const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
const dateFormat = 'MM/DD/YYYY'
const index = (text, i) => ({ text, value: 1 + i })

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
      riskLevelName: '---'
    }
  },
  methods: {
    loadrisk(risk) {
      this.risk = Object.assign({}, this.risk, risk)
      this.onRiskChange()
    },
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    },
    submit(e) {
      e.preventDefault()
      this.errors = [];
      if (!this.risk.name) {
        this.errors.push([
          'Field is required.'
        ]);
        this.makeToast('Error', 'Field is required.')
        return;
      }

      this.risk.compliance_policy_ids = this.risk.compliance_policies.map(policy => policy.id)
      if (!this.risk.compliance_policy_ids.includes(this.policyId)) this.risk.compliance_policy_ids.push(this.policyId)

      let method;
      if(!this.riskId) {
        method = 'createRisk'
      } else {
        method = 'updateRisk'
      }

      this.$store
        .dispatch(method, {...this.risk})
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

      // this.$emit('saved', this.risk)
    },
    onChange(event){
      if (event === null) this.isActive = true
      else this.isActive = false
    },
    onRiskChange(e){
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
    daysOfWeek() {
      return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map(index)
    },
    months() {
      return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'].map(index)
    },
    dateFormat: () => dateFormat
  },
  watch: {}
}
</script>
