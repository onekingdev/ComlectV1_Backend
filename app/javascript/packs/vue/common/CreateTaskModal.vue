<template lang="pug">
  div
    div(v-b-modal="id")
      slot

    b-modal.fade(:id="id" title="New task")
      label.form-label Task name
      input.form-control(v-model="task.body" type=text placeholder="Enter the name of your task")
      Errors(:errors="errors.body")

      label.form-label Link to
      ComboBox(V-model="task.link_to" :options="linkToOptions" placeholder="Select projects, annual reviews, or policies to link the task to")
      .form-text.text-muted Optional
      Errors(:errors="errors.link_to")

      label.form-label Assignee
      ComboBox(V-model="task.assignee" :options="assigneeOptions" placeholder="Select an assignee")
      Errors(:errors="errors.assignee")

      b-row(no-gutters)
        .col-sm
          label.form-label Start Date
          DatePicker(v-model="task.remind_at" :placeholder="dateFormat")
          Errors(:errors="errors.remind_at")
          .form-text.text-muted Optional
        .col-sm
          label.form-label Due Date
          DatePicker(v-model="task.end_date" :placeholder="dateFormat")
          Errors(:errors="errors.end_date")

      b-row(no-gutters)
        .col-sm
          label.form-label Repeats
          Dropdown(v-model="task.repeats" :options="repeatsOptions")
        //- Daily
        .col-sm(v-if="task.repeats === repeatsValues.REPEAT_DAILY")
          label.form-label Every
          input.form-control(type="number" min="1" max="1000" step="1" v-model="task.repeat_every")
          .form-text Day(s)
        //- Weekly
        .col-sm(v-if="task.repeats === repeatsValues.REPEAT_WEEKLY")
          label.form-label Every
          input.form-control(type="number" min="1" max="1000" step="1" v-model="task.repeat_every")
          .form-text Week(s)
        .col-sm(v-if="task.repeats === repeatsValues.REPEAT_WEEKLY")
          label.form-label Day
          Dropdown(v-model="task.repeat_on" :options="daysOfWeek")
        //- Monthly
        .col-sm(v-if="task.repeats === repeatsValues.REPEAT_MONTHLY")
          label.form-label Every
          input.form-control(type="number" min="1" max="1000" step="1" v-model="task.repeat_every")
          .form-text Months(s)
        .col-sm(v-if="task.repeats === repeatsValues.REPEAT_MONTHLY")
          label.form-label On
          Dropdown(v-model="task.on_type" :options="['Day', 'First', 'Second', 'Third', 'Fourth']")
        .col-sm(v-if="task.repeats === repeatsValues.REPEAT_MONTHLY")
          label.form-label Day
          input.form-control(v-model="task.repeat_on" v-if="task.on_type === 'Day'" type="number" min="1" max="31" step="1")
          Dropdown(v-model="task.repeat_on" v-else :options="daysOfWeek")
        //- Yearly
        .col-sm(v-if="task.repeats === repeatsValues.REPEAT_YEARLY")
          label.form-label Every
          Dropdown(v-model="task.repeat_every" :options="months")
        .col-sm(v-if="task.repeats === repeatsValues.REPEAT_YEARLY")
          label.form-label On
          Dropdown(v-model="task.on_type" :options="['Day', 'First', 'Second', 'Third', 'Fourth']")
        .col-sm(v-if="task.repeats === repeatsValues.REPEAT_YEARLY")
          label.form-label Day
          input.form-control(v-model="task.repeat_on" v-if="task.on_type === 'Day'" type="number" min="1" max="31" step="1")
          Dropdown(v-model="task.repeat_on" v-else :options="daysOfWeek")
      Errors(:errors="errors.repeats || errors.repeat_every || errors.repeat_on || errors.on_type")

      label.form-label Description
      textarea.form-control(v-model="task.description" rows=3)
      Errors(:errors="errors.description")
      .form-text.text-muted Optional

      template(slot="modal-footer")
        button.btn(@click="$bvModal.hide(id)") Cancel
        button.btn.btn-primary(@click="submit") Create
</template>

<script>
const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
const toOption = id => ({ id, label: id })
const dateFormat = 'MM/DD/YYYY'
const index = (text, i) => ({ text, value: 1 + i })
const flattenErrors = errorsResponse => Object.keys(errorsResponse)
  .reduce((result, property) => [...result, ...errorsResponse[property].map(error => ({ property, error }))], [])

const initialTask = () => ({
  body: null,
  link_to: null,
  assignee: null,
  remind_at: null,
  end_date: null,
  repeats: REPEAT_NONE,
  repeat_every: null,
  repeat_on: null,
  on_type: null,
  description: ""
})

const REPEAT_NONE = '',
  REPEAT_DAILY = 'Daily',
  REPEAT_WEEKLY = 'Weekly',
  REPEAT_MONTHLY = 'Monthly',
  REPEAT_YEARLY = 'Yearly',
  REPEAT_LABELS = {
    [REPEAT_NONE]: 'Does not repeat',
    [REPEAT_DAILY]: 'Daily',
    [REPEAT_WEEKLY]: 'Weekly',
    [REPEAT_MONTHLY]: 'Monthly',
    [REPEAT_YEARLY]: 'Yearly',
  },
  REPEAT_OPTIONS = [REPEAT_NONE, REPEAT_DAILY, REPEAT_WEEKLY, REPEAT_MONTHLY, REPEAT_YEARLY]

export default {
  data() {
    return {
      id: `modal_${rnd()}`,
      task: initialTask(),
      errors: []
    }
  },
  methods: {
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    },
    submit() {
      this.errors = []
      fetch('/api/business/tasks', {
        method: 'POST',
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: JSON.stringify(this.task)
      }).then(response => {
        if (response.status === 422) {
          response.json().then(errors => {
            this.errors = errors
            Object.keys(this.errors)
              .map(prop => this.errors[prop].map(err => this.makeToast(`Error`, `${prop}: ${err}`)))
          })
        } else if (response.status === 201) {
          this.makeToast('Success', 'The task has been created')
          this.$bvModal.hide(this.id)
          this.task = initialTask()
        } else {
          this.makeToast('Error', 'Couldn\'t submit form')
        }
      })
    }
  },
  computed: {
    daysOfWeek() {
      return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map(index)
    },
    months() {
      return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'].map(index)
    },
    repeatsValues() {
      return {REPEAT_NONE, REPEAT_DAILY, REPEAT_WEEKLY, REPEAT_MONTHLY, REPEAT_YEARLY}
    },
    repeatsOptions: () => REPEAT_OPTIONS.map(value => ({ value, text: REPEAT_LABELS[value] })),
    linkToOptions() {
      return [{...toOption('Projects'), children: ['Some project', 'Another', 'One'].map(toOption)},
        {...toOption('Annual Reviews'), children: ['Annual Review 2018', 'Annual Review 1337', 'Some Review'].map(toOption)},
        {...toOption('Policies'), children: ['Pol', 'Icy', 'Policy 3'].map(toOption)}]
    },
    assigneeOptions() {
      return ['John', 'Doe', 'Another specialist'].map(toOption)
    },
    dateFormat: () => dateFormat
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