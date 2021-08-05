<template lang="pug">
  div(:class="{'d-inline-block':inline}")
    div(v-b-modal="modalId" :class="{'d-inline-block':inline}")
      slot

    b-modal.fade(:id="modalId" :title="projectId ? 'Edit project' : 'New project'" @show="newEtag")
      ModelLoader(:url="projectId ? submitUrl : undefined" :default="initialProject" :etag="etag" @loaded="loadProject")
        label.form-label Title
        input.form-control(v-model="project.title" type=text placeholder="Enter the name of your project")
        Errors(:errors="errors.title")

        b-row.m-t-1(no-gutters)
          .col-sm.m-r-1
            label.form-label Start Date
            DatePicker(v-model="project.starts_on")
            Errors(:errors="errors.starts_on")
          .col-sm
            label.form-label Due Date
            DatePicker(v-model="project.ends_on")
            Errors(:errors="errors.ends_on")

        label.m-t-1.form-label Description
        textarea.form-control(v-model="project.description" rows=3)
        Errors(:errors="errors.description")
        .form-text.text-muted Optional

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        //- Post(v-if="canBeDraft" :action="`${submitUrl}?draft=1`" :model="project" :method="httpMethod" @errors="errors = $event" @saved="saved")
        //-   button.btn.btn-default Save as Draft
        Post(:action="submitUrl" :model="project" :method="httpMethod" @errors="errors = $event" @saved="saved")
          button.btn.btn-dark {{ projectId ? 'Save' : 'Create' }}
</template>

<script>
import { DateTime } from 'luxon'
import EtaggerMixin from '@/mixins/EtaggerMixin'

const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
const dateFormat = 'MM/DD/YYYY'
const index = (text, i) => ({ text, value: 1 + i })

const initialProject = () => ({
  title: "",
  starts_on: null,
  ends_on: null,
  description: ""
})

export default {
  mixins: [EtaggerMixin()],
  props: {
    projectId: Number,
    remindAt: String,
    inline: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      modalId: `modal_${rnd()}`,
      project: initialProject(),
      errors: []
    }
  },
  methods: {
    loadProject(project) {
      this.project = Object.assign({}, this.project, project)
    },
    saved() {
      this.$emit('saved')
      this.toast('Success', 'The project has been saved')
      this.$bvModal.hide(this.modalId)
      this.newEtag()
    }
  },
  computed: {
    initialProject: () => initialProject,
    canBeDraft() {
      return !this.projectId || ('draft' === this.project.status)
    },
    submitUrl() {
      const toId = this.projectId ? `/${this.projectId}` : ''
      return '/api/business/local_projects' + toId
    },
    httpMethod() {
      return this.projectId ? 'PUT' : 'POST'
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
    'project.starts_on': {
      handler: function(value, oldVal) {
        const start = DateTime.fromSQL(value), end = DateTime.fromSQL(this.project.ends_on)
        if (!start.invalid && (end.invalid || (end.startOf('day') < start.startOf('day')))) {
          this.project.ends_on = value
        }
      }
    }
  }
}
</script>