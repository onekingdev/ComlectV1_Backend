<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      h3.m-y-0 Regulatory Exams
      ExamModalCreate(@saved="$emit('saved')" :exams-id="exams.id")
        button.btn.btn-dark New Exam
    .card-body
      table.table.task_table
        thead
          tr
            th(width="40%")
              | Name
              b-icon.ml-2(icon='chevron-expand')
            th
              | Status
              b-icon.ml-2(icon='chevron-expand')
            th.text-right
              | Date created
              b-icon.ml-2(icon='chevron-expand')
            th.text-right
              | Last Modified
              b-icon.ml-2(icon='chevron-expand')
        tbody
          tr
            td Name 1
            td Status
            td.text-right 12/31/2020
            td.text-right 12/31/2020
          tr
            td Name 2
            td Status
            td.text-right 12/31/2020
            td.text-right 12/31/2020

</template>

<script>
  import ExamModalCreate from '../modals/ExamModalCreate'

export default {
  props: {
    exams: {
      type: Array,
      required: false
    }
  },
  components: {
    ExamModalCreate
  }
}
</script>
