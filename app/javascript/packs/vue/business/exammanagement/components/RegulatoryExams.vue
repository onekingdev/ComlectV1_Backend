<template lang="pug">
  div
    .card-header.d-flex.justify-content-between
      h3.m-y-0 Regulatory Exams
      ExamModalCreate(@saved="$emit('saved')" :exams-id="exams.id")
        button.btn.btn-dark New Exam
    .card-body
      table.table.task_table
        thead(v-if="exams")
          tr
            th(width="40%")
              .d-inline
                | Name
                b-icon.ml-2(icon='chevron-expand')
            th
              .d-inline-flex
                | Status
                b-icon.ml-2(icon='chevron-expand')
            th.text-right
              .d-inline
                | Date created
                b-icon.ml-2(icon='chevron-expand')
            th.text-right
              .d-inline
                | Last Modified
                b-icon.ml-2(icon='chevron-expand')
        tbody
          tr(v-for="exam in exams" :key="exam.id")
            td
              a.link(:href="`/business/exam_management/${exam.id}`") {{ exam.name }}
            td
              b-badge(:variant="exam.complete ? 'success' : 'light'") {{ exam.complete ? 'Completed' : 'Incomplete' }}
            td.text-right {{ dateToHuman(exam.created_at) }}
            td.text-right {{ dateToHuman(exam.updated_at) }}
            td.text-right
              b-dropdown.actions(size="sm" variant="light" class="m-0 p-0" right)
                template(#button-content)
                  b-icon(icon="three-dots")
                ExamsModalEdit(:exam="exam" :inline="false")
                  b-dropdown-item Edit
                ExamsModalDelete(@deleteConfirmed="deleteRecord(exam.id)" :inline="false")
                  b-dropdown-item.delete Delete
          tr(v-if="!exams && !exams.length")
            td.text-center
              h3 Exam Management not exist

</template>

<script>
  import { mapActions, mapGetters } from "vuex"
  import { DateTime } from 'luxon'
  import ExamModalCreate from '../modals/ExamModalCreate'
  import ExamsModalEdit from '../modals/ExamModalEdit'
  import ExamsModalDelete from '../modals/ExamModalDelete'

  export default {
    props: {
      exams: {
        type: Array,
        required: false
      }
    },
    methods: {
      ...mapActions({
        updateExam: 'exams/updateExam',
        deleteExam: 'exams/deleteExam',
      }),
      dateToHuman(value) {
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) return date.toFormat('MM/dd/yyyy')
        if (date.invalid) return value
      },
      deleteRecord(id){
        this.deleteExam({ id: id})
          .then(response => this.toast('Success', `The exam has been deleted!`))
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
      },
    },
    components: {
      ExamModalCreate,
      ExamsModalEdit,
      ExamsModalDelete,
    }
  }
</script>
