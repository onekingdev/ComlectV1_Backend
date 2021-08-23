<template lang="pug">
  tr
    td
      .name
        b-icon.pointer.m-r-1(font-scale="1" :icon="item.done_at ? 'check-circle-fill' : 'check-circle'" @click="toggleDone(item)" v-bind:class="{ done_task: item.done_at }")
        //ion-icon.m-r-1.pointer(@click="toggleDone(item)" v-bind:class="{ done_task: item.done_at }" name='checkmark-circle-outline')
        TaskModalCreateEdit.link(:taskProp="item" :task-id="item.taskId" :occurence-id="item.oid" :toastMessages="toastMessages" @saved="$emit('saved')")
          span(v-if="!item.done_at" ) {{ item.body }}
          s(v-else) {{ item.body }}
    td(v-if="!shortTable")
      .d-flex.align-items-center
        ion-icon.mr-1(v-if="linkedTo(item)" :name="linkedTo(item)" :class="linkedToClass(item)")
        .link(v-if="item.linkable_type") {{ item.linkable_type | linkableTypeCorrector }}
        span(v-else) ---
    td(v-if="!shortTable") {{ item.assignee ? item.assignee : '---' }}
    td.text-right(v-if="!shortTable")
      | {{ item.remind_at | asDate }}
    td.text-right(:class="{ overdue: isOverdue(item) }")
      ion-icon.text-dark.mr-2(v-if="isRepeat(item)" name="repeat-outline")
      b-icon.mr-2(v-if="isOverdue(item)" icon="exclamation-triangle-fill" variant="warning")
      | {{ item.end_date | asDate }}
    td.d-none(v-if="!shortTable").text-right 0
    td.d-none(v-if="!shortTable").text-right 0
    td(v-if="!shortTable").text-right
      b-dropdown(size="xs" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        //b-dropdown-item(:href="`/business/reminders/${item.id}`") Edit
        TaskModalCreateEdit(@editConfirmed="editConfirmed", :taskProp="item", :toastMessages="toastMessages" :inline="false")
          b-dropdown-item Edit
        //b-dropdown-item {{ item.done_at ? 'Incomplite' : 'Complite' }}
        TaskModalDelete(@deleteConfirmed="deleteTask(item)", :linkedTo="{ linkable_type: item.linkable_type, linkable_name: item.linkable_name }" :inline="false")
          b-dropdown-item Delete
</template>

<script>
// import { DateTime } from 'luxon'
import { toEvent, isOverdue, splitReminderOccurenceId, linkedTo, linkedToClass, isRepeat } from '@/common/TaskHelper'
import TaskModalCreateEdit from '../modals/TaskModalCreateEdit'
import TaskModalDelete from '../modals/TaskModalDelete'

export default {
  name: "TaskItem",
  props: ['item', 'shortTable', 'toastMessages'],
  components: {
    TaskModalCreateEdit,
    TaskModalDelete,
  },
  computed: { },
  methods: {
    isRepeat,
    isOverdue,
    linkedTo,
    linkedToClass,
    async toggleDone(task) {
      // OLD CODE
      // const { taskId, oid } = splitReminderOccurenceId(task.id)
      // const oidParam = oid !== null ? `&oid=${oid}` : ''
      // var target_state = (!(!!task.done_at)).toString()
      // fetch(`/api/reminders/${taskId}?done=${target_state}${oidParam}`, {
      //   method: 'POST',
      //   headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      // }).then(response => this.$emit('saved'))

      const fixedId = task.id

      const { taskId, oid } = splitReminderOccurenceId(task.id)
      const oidParam = oid !== null ? `&oid=${oid}` : ''                               // BACK RETURNS 404 with this
      const src_id_params = oid !== null ? `&src_id=${task.id.split('_')[0]}` : ''    // BACK RETURNS 404 with this
      let target_state = (!(!!task.done_at)).toString()

      // console.log('task', task)
      // console.log('taskId, oid', taskId, oid)
      // console.log('oidParam', oidParam)
      // console.log('target_state', target_state)

      const statusWord = task.done_at ? 'incompleted' : 'completed'

      try {
        await this.$store.dispatch('reminders/updateTaskStatus', { fixedId, id: taskId, done: target_state, oidParam })
          .then(response => this.toast('Success', `${this.toastMessages.success.complete.replace("$.", statusWord)}.` ))
          .catch(error => this.toast('Error', this.toastMessages.errors.complete, true))
      } catch (error) {
        console.error('error catch in task Item', error)
        this.toast('Error', `${error.message}`, true)
      }
    },
    deleteTask(task, deleteOccurence){
      const occurenceParams = deleteOccurence ? `?oid=${this.occurenceId}` : ''
      this.$store.dispatch('reminders/deleteTask', { id: task.id, occurenceParams })
        .then(response => this.toast('Success', this.toastMessages.success.deleted))
        .catch(error => this.toast('Error', this.toastMessages.errors.deleted, true))
    },
    editConfirmed() { console.log('editConfirmed') }
  },
  filters: {
    linkableTypeCorrector: function (value) {
      if (value === 'AnnualReport') value = 'Internal Review'
      return value.replace(/[A-Z]/g, ' $&')
    }
  },
}
</script>

<style scoped>

</style>
