<template lang="pug">
  tr
    td
      .name
        b-icon.m-r-1.pointer(font-scale="1" :icon="item.done_at ? 'check-circle-fill' : 'check-circle'" @click="toggleDone(item)" v-bind:class="{ done_task: item.done_at }")
        //ion-icon.m-r-1.pointer(@click="toggleDone(item)" v-bind:class="{ done_task: item.done_at }" name='checkmark-circle-outline')
        TaskModalEdit.link(:taskProp="item" @saved="$emit('saved')")
          span(v-if="!item.done_at" ) {{ item.body }}
          s(v-else) {{ item.body }}
    td(v-if="!shortTable")
      .d-flex.align-items-center.link
        ion-icon.m-r-1(name="list-circle-outline")
        | {{ item.linkable_type ? item.linkable_type : 'not selected' }}
    td(v-if="!shortTable") {{ item.assignee }}
    td.text-right(v-if="!shortTable" :class="{ overdue: isOverdue(item) }")
      b-icon.mr-2(v-if="isOverdue(item)" icon="exclamation-triangle-fill" variant="warning")
      | {{ item.remind_at | dateToHuman}}
    td.text-right(:class="{ overdue: isOverdue(item) }")
      b-icon.mr-2(v-if="isOverdue(item)" icon="exclamation-triangle-fill" variant="warning")
      | {{ item.end_date | dateToHuman }}
    td(v-if="!shortTable").text-right 0
    td(v-if="!shortTable").text-right 0
    td(v-if="!shortTable").text-right
      b-dropdown.actions(size="xs" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        //b-dropdown-item(:href="`/business/reminders/${item.id}`") Edit
        TaskModalEdit(@editConfirmed="editConfirmed", :taskProp="item", :inline="false")
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
import TaskModalEdit from '../modals/TaskModalEdit'
import TaskModalDelete from '../modals/TaskModalDelete'

export default {
  name: "TaskItem",
  props: ['item', 'shortTable'],
  components: {
    TaskFormModal,
    TaskModalEdit,
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
    editConfirmed() {
      console.log('editConfirmed')
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
  .link ion-icon {
    color: var(--blue)
  }
</style>
