<template lang="pug">
  div.d-inline-block
    div.d-inline-block(v-b-modal="modalId")
      slot

    b-modal.fade(:id="modalId" :title="projectId ? 'Updating project' : 'New project'" @show="resetProject")
      label.form-label Title
      input.form-control(v-model="project.title" type=text placeholder="Enter the name of your project")
      Errors(:errors="errors.title")

      b-row(no-gutters)
        .col-sm
          label.form-label Start Date
          DatePicker(v-model="project.starts_on" :placeholder="dateFormat")
          Errors(:errors="errors.starts_on")
        .col-sm
          label.form-label Due Date
          DatePicker(v-model="project.ends_on" :placeholder="dateFormat")
          Errors(:errors="errors.ends_on")

      label.form-label Description
      textarea.form-control(v-model="project.description" rows=3)
      Errors(:errors="errors.description")
      .form-text.text-muted Optional

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(modalId)") Cancel
        button.btn.btn-primary(@click="submit") {{ projectId ? 'Save' : 'Create' }}
</template>

<script>
import { DateTime } from 'luxon'

const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
const dateFormat = 'MM/DD/YYYY'
const index = (text, i) => ({ text, value: 1 + i })
const flattenErrors = errorsResponse => Object.keys(errorsResponse)
  .reduce((result, property) => [...result, ...errorsResponse[property].map(error => ({ property, error }))], [])

const initialProject = defaults => ({
  title: "",
  starts_on: null,
  ends_on: null,
  description: "",
  ...(defaults || {})
})

export default {
  props: {
    projectId: Number,
    remindAt: String
  },
  data() {
    return {
      modalId: `modal_${rnd()}`,
      project: initialProject(),
      errors: []
    }
  },
  methods: {
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    },
    submit() {
      this.errors = []
      const toId = this.projectId ? `/${this.projectId}` : ''
      fetch('/api/business/local_projects' + toId, {
        method: 'POST',
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: JSON.stringify(this.project)
      }).then(response => {
        if (response.status === 422) {
          response.json().then(errors => {
            this.errors = errors
            Object.keys(this.errors)
              .map(prop => this.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
          })
        } else if (response.status === 201 || response.status === 200) {
          this.$emit('saved')
          this.makeToast('Success', 'The project has been saved')
          this.$bvModal.hide(this.modalId)
          this.resetProject()
        } else {
          this.makeToast('Error', 'Couldn\'t submit form')
        }
      })
    },
    resetProject() {
      if (this.projectId) {
        fetch(`/api/business/local_projects/${this.projectId}`, {
          method: 'GET',
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
        }).then(response => response.json())
          .then(result => Object.assign(this.project, result))
      } else {
        this.project = initialProject()
      }
    }
  },
  computed: {
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
  },
  components: {
    Errors: {
      template: `<div v-if="errors && errors[0]" v-text="errors[0]" class="d-block invalid-feedback" role="alert" aria-live="assertive" aria-atomic="true"/>`,
      props: {
        errors: Array
      }
    }
  }
}
</script>