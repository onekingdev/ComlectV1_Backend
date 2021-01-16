<template lang="pug">
  div
    div(v-b-modal="id")
      slot

    b-modal.fade(:id="id" title="New task")
      label.form-label Task name
      input.form-control(type=text placeholder="Enter the name of your task")

      label.form-label Link to
      Treeselect(v-model="linkTo" :multiple="false" :options="linkToOptions" placeholder="Select projects, annual reviews, or policies to link the task to")
      .form-text.text-muted Optional

      label.form-label Assignee
      Treeselect(v-model="assignee" :multiple="false" :options="assigneeOptions" placeholder="Select an assignee")

      b-row(no-gutters)
        .col-sm
          label.form-label Start Date
          b-form-datepicker(v-model="startDate" :placeholder="dateFormat")
          .form-text.text-muted Optional
        .col-sm
          label.form-label Due Date
          b-form-datepicker(v-model="dueDate" :placeholder="dateFormat")

      label.form-label Repeats
      b-form-select(v-model="repeats" :options="['Does not repeat', 'Weekly', 'Monthly']")

      label.form-label Description
      textarea.form-control(rows=3)
      .form-text.text-muted Optional

      //- cancel, create
</template>

<script>
const rnd = () => Math.random().toFixed(10).toString().replace('.', '')
const toOption = id => ({ id, label: id })
const dateFormat = 'MM/DD/YYYY'

export default {
  data() {
    return {
      id: `modal_${rnd()}`,
      linkTo: null,
      assignee: null,
      startDate: null,
      dueDate: null,
      repeats: null
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