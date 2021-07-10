<template lang="pug">
  tr
    td
      b-icon.m-r-1.pointer(:icon="item.done_at ? 'check-circle-fill' : 'check-circle'" @click="toggleDone(item)" v-bind:class="{ done_task: item.done_at }")
      //ion-icon.m-r-1.pointer(@click="toggleDone(item)" v-bind:class="{ done_task: item.done_at }" name='checkmark-circle-outline')
      TaskFormModal(:task-id="item.taskId" :occurence-id="item.oid" @saved="$emit('saved')") {{ item.body }} {{ item.name }}
    td(v-if="!shortTable") {{ item.linkable_type }}
    td(v-if="!shortTable") {{ item.assignee }}
    td.text-right(v-if="!shortTable" :class="{ overdue: isOverdue(item) }") {{ item.remind_at | dateToHuman}}
    td.text-right(:class="{ overdue: isOverdue(item) }") {{ item.end_date | dateToHuman }}
    td(v-if="!shortTable").text-right 0
    td(v-if="!shortTable").text-right 0
    td(v-if="!shortTable").text-right
      b-dropdown.actions(size="xs" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        //b-dropdown-item(:href="`/business/reminders/${item.id}`") Edit
        TaskModalCreate(@editConfirmed="editConfirmed(item.id)", :taskId="item.id" :inline="false")
          b-dropdown-item Edit
        //b-dropdown-item {{ item.done_at ? 'Incomplite' : 'Complite' }}
        //b-dropdown-item(@click="duplicateTask(item.id)") Duplicate
        TaskModalDelete(@deleteConfirmed="deleteTask(item.id)", :inline="false")
          b-dropdown-item Delete
</template>

<script>
import { DateTime } from 'luxon'
import { toEvent, isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'
import TaskFormModal from '@/common/TaskFormModal'
import TaskModalCreate from '../modals/TaskModalCreate'
import TaskModalDelete from '../modals/TaskModalDelete'

export default {
  name: "TaskItem",
  props: ['item', 'shortTable'],
  components: {
    TaskFormModal,
    TaskModalCreate,
    TaskModalDelete,
  },
  computed: {
    progressWidth() {
      const part = 100 / +this.item.review_categories.length
      return +part * +this.item.progress
    },
    taskEvents() {
      const data = this.tasks.map(toEvent)
        .map(e => ({
          ...e,
          start: DateTime.fromSQL(e.start).toLocaleString(),
          end: DateTime.fromSQL(e.end).toLocaleString(),
          ...splitReminderOccurenceId(e.id)
        }))
      console.log(data)
      return data
    }
  },
  methods: {
    isOverdue,
    toggleDone(task) {
      const { taskId, oid } = splitReminderOccurenceId(task.id)
      const oidParam = oid !== null ? `&oid=${oid}` : ''
      let target_state = (!(!!task.done_at)).toString()

       this.$store.dispatch('reminders/updateTaskStatus', { id: taskId, done: target_state })
        .then(response => this.toast('Success', `Updated!`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    duplicateTask(id){
      console.log('Hey duplicate it!', id)
      // this.$store.dispatch('reminders/duplicateTask', { id: id })
      //   .then(response => this.toast('Success', `The annual review has been duplicated! ${response.id}`))
      //   .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    deleteTask(id){
      this.$store.dispatch('reminders/deleteTask', { id })
        .then(response => this.toast('Success', `The Task has been deleted!`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    editConfirmed(id) {
      console.log(id)
    }
  },
  filters: {
    dateToHuman(value) {
      const date = DateTime.fromJSDate(new Date(value))
      if (!date.invalid) {
        return date.toFormat('MM/dd/yyyy')
      }
      if (date.invalid) {
        return value
      }
    },
  }
}
</script>

<style scoped>

</style>
