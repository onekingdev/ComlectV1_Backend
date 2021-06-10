<template lang="pug">
  tr
    td
      a.link(:href="`/business/exam_management/${item.id}`") {{ item.name }}
    td
      b-badge(:variant="item.complete ? 'success' : 'light'") {{ item.complete ? 'Completed' : 'Incomplete' }}
    td.text-right {{ dateToHuman(item.created_at) }}
    td.text-right {{ dateToHuman(item.updated_at) }}
    td.text-right
      b-dropdown.actions(size="sm" variant="light" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        ExamsModalEdit(v-if="!item.complete" :exam="item" :inline="false")
          b-dropdown-item Edit
        ExamsModalDelete(@deleteConfirmed="deleteRecord(item.id)" :inline="false")
          b-dropdown-item.delete Delete
</template>

<script>
  import { mapActions } from "vuex"
  import { DateTime } from 'luxon'
  import ExamsModalEdit from '../modals/ExamModalEdit'
  import ExamsModalDelete from '../modals/ExamModalDelete'

  export default {
    name: "ReviewItem",
    props: ['item'],
    components: {
      ExamsModalEdit,
      ExamsModalDelete
    },
    computed: {
      progressWidth() {
        const part = 100 / +this.item.review_categories.length
        return +part * +this.item.progress
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
    }
  }
</script>

<style scoped>

</style>
