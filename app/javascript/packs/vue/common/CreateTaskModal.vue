<template lang="pug">
  div
    div(v-b-modal="id")
      slot

    b-modal.fade(:id="id" title="New task")
      label.form-label Task name
      input.form-control(v-model="task.body" type=text placeholder="Enter the name of your task")

      label.form-label Link to
      Treeselect(v-model="task.link_to" :multiple="false" :options="linkToOptions" placeholder="Select projects, annual reviews, or policies to link the task to")
      .form-text.text-muted Optional

      label.form-label Assignee
      Treeselect(v-model="task.assignee" :multiple="false" :options="assigneeOptions" placeholder="Select an assignee")

      b-row(no-gutters)
        .col-sm
          label.form-label Start Date
          b-form-datepicker(v-model="task.remind_at" :placeholder="dateFormat")
          .form-text.text-muted Optional
        .col-sm
          label.form-label Due Date
          b-form-datepicker(v-model="task.end_date" :placeholder="dateFormat")

      label.form-label Repeats
      b-form-select(v-model="task.repeats" :options="['Does not repeat', 'Weekly', 'Monthly']")

      label.form-label Description
      textarea.form-control(rows=3)
      .form-text.text-muted Optional

      template(slot="modal-footer")
        button.btn.btn-primary(@click="submit") Create
        button.btn.btn-secondary(@click="$bvModal.hide(id)") Cancel
</template>

<script>
const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
const toOption = id => ({ id, label: id })
const dateFormat = 'MM/DD/YYYY'

const initialTask = () => ({
  body: null,
  link_to: null,
  assignee: null,
  remind_at: null,
  end_date: null,
  repeats: null,
})

export default {
  data() {
    return {
      id: `modal_${rnd()}`,
      task: initialTask()
    }
  },
  methods: {
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    },
    submit() {
      fetch('/api/business/tasks', {
        method: 'POST',
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: JSON.stringify(this.task)
      }).then(response => {
        if (response.status === 422) {
          response.json().then(errors => Object.keys(errors)
            .map(prop => errors[prop].map(error => this.makeToast('Error', `${prop}: ${error}`))))
        } else {
          this.makeToast('Success', 'The task has been created')
          this.$bvModal.hide(this.id)
          this.task = initialTask()
        }
      })
    }
  },
  computed: {
    linkToOptions() {
      return [{...toOption('Projects'), children: ['Some project', 'Another', 'One'].map(toOption)},
        {...toOption('Annual Reviews'), children: ['Annual Review 2018', 'Annual Review 1337', 'Some Review'].map(toOption)},
        {...toOption('Policies'), children: ['Pol', 'Icy', 'Policy 3'].map(toOption)}]
    },
    assigneeOptions() {
      return ['John', 'Doe', 'Another specialist'].map(toOption)
    },
    dateFormat: () => dateFormat
  }
}
</script>