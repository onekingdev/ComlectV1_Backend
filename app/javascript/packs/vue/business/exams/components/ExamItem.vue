<template lang="pug">
  tr
    td
      router-link.link(:to='`/business/exam_management/${item.id}`') {{ item.name }}
    td
      b-badge(:variant="item.complete ? 'success' : 'secondary'") {{ item.complete ? 'Completed' : 'In progress' }}
    td.text-right {{ item.created_at | asDate }}
    td.text-right {{ item.updated_at | asDate }}
    td.text-right
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
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
      deleteRecord(id){
        this.deleteExam({ id: id})
          .then(response => this.toast('Success', `The exam has been deleted!`))
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`, true))
      },
    }
  }
</script>

<style scoped>

</style>
