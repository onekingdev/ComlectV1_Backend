<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="riskId ? 'Edit risk' : 'New risk'" @show="newEtag")
      ModelLoader(:url="riskId ? submitUrl : undefined" :default="initialrisk" :etag="etag" @loaded="loadrisk")
        label.form-label Title
        input.form-control(v-model="risk.title" type=text placeholder="Enter the name of your risk")
        Errors(:errors="errors.title")

        b-row.m-t-1(no-gutters)
          .col-sm.m-r-1
            label.form-label Start Date
            DatePicker(v-model="risk.starts_on")
            Errors(:errors="errors.starts_on")
          .col-sm
            label.form-label Due Date
            DatePicker(v-model="risk.ends_on")
            Errors(:errors="errors.ends_on")

        label.m-t-1.form-label Description
        textarea.form-control(v-model="risk.description" rows=3)
        Errors(:errors="errors.description")
        .form-text.text-muted Optional

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
  title: "",
  starts_on: null,
  ends_on: null,
  description: ""
})

export default {
  mixins: [EtaggerMixin],
  props: {
    riskId: Number,
    remindAt: String,
    inline: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      modalId: `modal_${rnd()}`,
      risk: initialrisk(),
      errors: []
    }
  },
  methods: {
    loadrisk(risk) {
      this.risk = Object.assign({}, this.risk, risk)
    },
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    },
    saved() {
      this.$emit('saved')
      this.makeToast('Success', 'The risk has been saved')
      this.$bvModal.hide(this.modalId)
      this.newEtag()
    }
  },
  computed: {
    initialrisk: () => initialrisk,
    canBeDraft() {
      return !this.riskId || ('draft' === this.risk.status)
    },
    submitUrl() {
      const toId = this.riskId ? `/${this.riskId}` : ''
      return '/api/business/local_risks' + toId
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
  watch: {
    'risk.starts_on': {
      handler: function(value, oldVal) {
        const start = DateTime.fromSQL(value), end = DateTime.fromSQL(this.risk.ends_on)
        if (!start.invalid && (end.invalid || (end.startOf('day') < start.startOf('day')))) {
          this.risk.ends_on = value
        }
      }
    }
  }
}
</script>
