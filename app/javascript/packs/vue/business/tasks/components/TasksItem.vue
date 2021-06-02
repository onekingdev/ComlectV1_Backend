<template lang="pug">
  tr
    td
      ion-icon.m-r-1.pointer(@click="toggleDone(task)" v-bind:class="{ done_task: task.done_at }" name='checkmark-circle-outline')
      TaskFormModal(:task-id="task.taskId" :occurence-id="task.oid" @saved="$emit('saved')") {{ task.body }} {{ item.name }}
    td(v-if="!shortTable") {{ task.assignee }}
    td(v-if="!shortTable").text-right(:class="{ overdue: isOverdue(task) }") {{ dateToHuman(item.remind_at) }}
    td.text-right(:class="{ overdue: isOverdue(task) }") {{ dateToHuman(item.end_date) }}
    td(v-if="!shortTable").text-right 0
    td(v-if="!shortTable").text-right 0
    td(v-if="!shortTable").text-right
      b-dropdown.actions(size="xs" variant="light" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        b-dropdown-item(:href="`/business/annual_reviews/${item.id}`") Edit
        b-dropdown-item {{ task.done_at ? 'Incomplite' : 'Complite' }}
        b-dropdown-item(@click="duplicateTask(item.id)") Dublicate
        TaskModalDelete(@deleteConfirmed="deleteTask(item.id)", :inline="false")
          b-dropdown-item.delete Delete
</template>

<script>
import { DateTime } from 'luxon'
import TaskFormModal from '@/common/TaskFormModal'
import TaskModalDelete from '../modals/TaskModalDelete'

export default {
  name: "TaskItem",
  props: {
    item,
    shortTable: {
      type: Boolean,
      default: false
    }
  },
  components: {
    TaskFormModal,
    TaskModalDelete
  },
  computed: {
    progressWidth() {
      const part = 100 / +this.item.review_categories.length
      return +part * +this.item.progress
    }
  },
  methods: {
    dateToHuman(value) {
      const date = DateTime.fromJSDate(new Date(value))
      if (!date.invalid) {
        return date.toFormat('MM/dd/yyyy')
      }
      if (date.invalid) {
        return value
      }
    },
    duplicateTask(reviewId){
      this.$store.dispatch('annual/duplicateTask', { id: reviewId })
        .then(response => this.toast('Success', `The annual review has been duplicated! ${response.id}`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    deleteTask(reviewId){
      this.$store.dispatch('annual/deleteTask', { id: reviewId })
        .then(response => this.toast('Success', `The annual review has been deleted! ${response.id}`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    }
  }
}
</script>

<style scoped>

</style>
