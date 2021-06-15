<template lang="pug">
  tr
    td
      ion-icon.m-r-1.pointer(@click="toggleDone(item)" v-bind:class="{ done_task: item.done_at }" name='checkmark-circle-outline')
      TaskFormModal(:task-id="item.taskId" :occurence-id="item.oid" @saved="$emit('saved')") {{ item.body }} {{ item.name }}
    td(v-if="!shortTable") {{ item.assignee }}
    td(v-if="!shortTable").text-right(:class="{ overdue: isOverdue(item) }") {{ dateToHuman(item.remind_at) }}
    td.text-right(:class="{ overdue: isOverdue(item) }") {{ dateToHuman(item.end_date) }}
    td(v-if="!shortTable").text-right 0
    td(v-if="!shortTable").text-right 0
    td(v-if="!shortTable").text-right
      b-dropdown.actions(size="xs" variant="light" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        b-dropdown-item(:href="`/business/reminders/${item.id}`") Edit
        b-dropdown-item {{ item.done_at ? 'Incomplite' : 'Complite' }}
        b-dropdown-item(@click="duplicateTask(item.id)") Dublicate
        TaskModalDelete(@deleteConfirmed="deleteTask(item.id)", :inline="false")
          b-dropdown-item.delete Delete
</template>

<script>
import { DateTime } from 'luxon'
import { toEvent, isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'
import TaskFormModal from '@/common/TaskFormModal'
import TaskModalDelete from '../modals/TaskModalDelete'

export default {
  name: "TaskItem",
  props: ['item', 'shortTable'],
  components: {
    TaskFormModal,
    TaskModalDelete
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
      var target_state = (!(!!task.done_at)).toString()
      fetch(`/api/business/reminders/${taskId}?done=${target_state}${oidParam}`, {
        method: 'POST',
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      }).then(response => this.$emit('saved'))
    },
    dateToHuman(value) {
      const date = DateTime.fromJSDate(new Date(value))
      if (!date.invalid) {
        return date.toFormat('MM/dd/yyyy')
      }
      if (date.invalid) {
        return value
      }
    },
    duplicateTask(id){
      console.log('Hey duplicate it!', id)
      // this.$store.dispatch('reminders/duplicateTask', { id: id })
      //   .then(response => this.toast('Success', `The annual review has been duplicated! ${response.id}`))
      //   .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    // deleteTask(reviewId){
    //   this.$store.dispatch('reminders/deleteTask', { id: reviewId })
    //     .then(response => this.toast('Success', `The annual review has been deleted! ${response.id}`))
    //     .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    // },
    deleteTask(id) {
      fetch(`${endpointUrl}${id}`, {method: 'DELETE', headers: {'Accept': 'application/json'}})
        .then(response => response.json())
        .then(response => {
          console.log('result', response)
          this.makeToast('Success', `Task successfully deleted!`)
        })
        .catch(error => this.makeToast('Error', `${error.message}`))
    },
  },
}
</script>

<style scoped>

</style>
