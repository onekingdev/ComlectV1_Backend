<template lang="pug">
  div
    div(data-bs-toggle="modal" :data-bs-target="`#${id}`")
      slot

    .modal.fade(:id="id")
      .modal-dialog
        .modal-content
          .modal-header
            h5.modal-title New task
            button.btn-close(data-bs-dismiss="modal")
          .modal-body
            .mb-3
                label.form-label Task name
                input.form-control(type=text placeholder="Enter the name of your task")

                label.form-label Link to
                Treeselect(v-model="linkTo" :multiple="false" :options="linkToOptions" placeholder="Select projects, annual reviews, or policies to link the task to")
                .form-text Optional

                label.form-label Assignee
                Treeselect(v-model="assignee" :multiple="false" :options="assigneeOptions" placeholder="Select an assignee")

                .container.g-0
                  .row
                    .col-sm
                      label.form-label Start Date
                      input.form-control(type=text :placeholder="dateFormat")
                      .form-text Optional
                    .col-sm
                      label.form-label Due Date
                      input.form-control(type=text :placeholder="dateFormat")

                label.form-label Repeats
                select.form-select
                  option(value=1 selected) Does not repeat
                  option(value=2 selected) Weekly
                  option(value=3 selected) Monthly

                label.form-label Description
                textarea.form-control(rows=3)
                .form-text Optional
          .modal-footer
            button.btn(data-bs-dismiss="modal") Cancel
            button.btn.btn-primary Create
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
      assignee: null
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