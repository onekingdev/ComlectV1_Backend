<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="riskId ? 'Edit risk' : 'New risk'" @show="newEtag")
      ModelLoader(:url="riskId ? submitUrl : undefined" :default="initialrisk" :etag="etag" @loaded="loadrisk")
        <!--label.form-label Risk-->
        b-form-group#input-group-1(label='Risk:' label-for='input-3')
          b-form-select#select-1(v-model='risk.risks' :options='risk.options' @change="onChange" required)
          <!--InputSelect.m-t-1(v-model="risk.risks" :errors="errors.risks" :options="risk.options" @change="onChange") Risk-->
          Errors(:errors="errors.risk")
          pre {{ risk.risks }}

        b-row.m-t-1(no-gutters, v-if="isActive")
          .col
            label.form-label Risk Name
            input.form-control(v-model="risk.name" type=text placeholder="Enter the name of your risk")
            Errors(:errors="errors.risk")

        b-row.m-t-1(no-gutters)
          .col-sm.m-r-1
            InputSelect(v-model="risk.impact" :errors="errors.impact" :options="risk.levelOptions") Impact
            Errors(:errors="errors.impact")
          .col-sm
            InputSelect(v-model="risk.likelihood" :errors="errors.likelihood" :options="risk.levelOptions") Likelihood
            Errors(:errors="errors.likelihood")

        b-row.m-t-1(no-gutters)
          .col
            label.m-t-1.form-label Risk Level
            p
              b-icon.mr-3(icon="exclamation-triangle-fill" scale="1" variant="danger")
              | High

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        //- Post(v-if="canBeDraft" :action="`${submitUrl}?draft=1`" :model="risk" :method="httpMethod" @errors="errors = $event" @saved="saved")
        //-   button.btn.btn-default Save as Draft
        Post(:action="submitUrl" :model="risk" :method="httpMethod" @errors="errors = $event" @saved="saved")
          button.btn.btn-dark {{ riskId ? 'Save' : 'Add' }}
</template>

<script>
import { DateTime } from 'luxon'
import EtaggerMixin from '@/mixins/EtaggerMixin'

const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
const dateFormat = 'MM/DD/YYYY'
const index = (text, i) => ({ text, value: 1 + i })

const initialrisk = () => ({
  name: "",
  impact: null,
  likelihood: null,
  compliance_policy_ids: [],
  options: {
    risk0: 'New Risk',
    risk1: 'risk1',
    risk2: 'risk2',
    risk3: 'risk3',
  },
  levelOptions: {
    0: 'Low',
    1: 'Medium',
    2: 'High',
  }
})

export default {
  mixins: [EtaggerMixin],
  props: {
    riskId: Number,
    remindAt: String,
    inline: {
      type: Boolean,
      default: true
    },
    risksList: Array
  },
  data() {
    return {
      modalId: `modal_${rnd()}`,
      risk: initialrisk(),
      errors: [],
      isActive: false
    }
  },
  methods: {
    loadrisk(risk) {
      this.risk = Object.assign({}, this.risk.risksList, risk)
    },
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    },
    saved() {
      console.log('this.riskId', this.riskId)
      console.log('risk', risk)
      this.$emit('saved')
      this.makeToast('Success', 'The risk has been saved')
      this.$bvModal.hide(this.modalId)
      this.newEtag()
    },
    onChange(e){
      if (e === 'risk0') this.isActive = true
      else this.isActive = false
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
