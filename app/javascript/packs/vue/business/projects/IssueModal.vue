<template lang="pug">
  b-modal#IssueModal(title="Report Issue")
    InputSelect(v-model="form.type" :options="types" :errors="errors.type" placeholder="Select an option") I want to
    InputTextarea(v-model="form.issue" :errors="errors.issue" placeholder="Enter the details of the issue") Details
    .form-text.text-muted Include anything you'd like us to know so we can best help you
    template(#modal-footer="{ hide }")
      button.btn.btn-default(@click="hide") Cancel
      button.btn.btn-dark(v-if="submitDisabled" disabled) Submit
      Post(v-else :action="createUrl" :model="formModel" @errors="errors = $event" @saved="saved" :headers="headers")
        button.btn.btn-dark Submit
</template>

<script>
const TYPES = ['Halt a payment', 'Other']
const initialForm = () => ({ type: null, issue: null })

export default {
  props: {
    projectId: {
      type: Number,
      required: true
    },
    token: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      form: initialForm(),
      errors: {}
    }
  },
  methods: {
    saved() {
      this.toast('Success', 'Issue submitted')
      this.$bvModal.hide('IssueModal')
      Object.assign(this.form, initialForm())
    }
  },
  computed: {
    formModel() {
      return { issue: `I want to: ${TYPES[this.form.type]}\n\n ${this.form.issue}` }
    },
    createUrl() {
      return `/api/projects/${this.projectId}/issues`
    },
    submitDisabled() {
      return !this.form.type || !this.form.issue || !this.form.issue.length
    },
    types: () => TYPES,
    headers() {
      return { Authorization: this.token }
    }
  }
}
</script>