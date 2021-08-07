<template lang="pug">
  tr
    td
      .name
        b-icon.pointer.m-r-1(font-scale="1" :icon="item.done_at ? 'check-circle-fill' : 'check-circle'" @click="toggleDone(item)" v-bind:class="{ done_task: item.done_at }")
        //ion-icon.m-r-1.pointer(@click="toggleDone(item)" v-bind:class="{ done_task: item.done_at }" name='checkmark-circle-outline')
        TaskModalCreateEdit.link(:taskProp="item" @saved="$emit('saved')")
          span(v-if="!item.done_at" ) {{ item.body }}
          s(v-else) {{ item.body }}
    td(v-if="!shortTable")
      .d-flex.align-items-center
        ion-icon.mr-1(v-if="linkedTo(item)" :name="linkedTo(item)" :class="linkedToClass(item)")
        .link(v-if="item.linkable_type") {{ item.linkable_type }}
        span(v-else) ---
    td(v-if="!shortTable") {{ item.assignee ? item.assignee : '---' }}
    td.text-right(v-if="!shortTable")
      | {{ item.remind_at | asDate }}
    td.text-right(:class="{ overdue: isOverdue(item) }")
      b-icon.mr-2(v-if="isOverdue(item)" icon="exclamation-triangle-fill" variant="warning")
      ion-icon.text-dark.mr-2(v-if="isRepeat(item)" name="repeat-outline")
      | {{ item.end_date | asDate }}
    td.d-none(v-if="!shortTable").text-right 0
    td.d-none(v-if="!shortTable").text-right 0
    td(v-if="!shortTable").text-right
      b-dropdown(size="xs" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        //b-dropdown-item(:href="`/business/reminders/${item.id}`") Edit
        TaskModalCreateEdit(@editConfirmed="editConfirmed", :taskProp="item", :inline="false")
          b-dropdown-item Edit
        //b-dropdown-item {{ item.done_at ? 'Incomplite' : 'Complite' }}
        TaskModalDelete(@deleteConfirmed="deleteTask(item)", :inline="false")
          b-dropdown-item Delete
</template>

<script>
// import { DateTime } from 'luxon'
import { toEvent, isOverdue, splitReminderOccurenceId, linkedTo, linkedToClass, isRepeat } from '@/common/TaskHelper'
import TaskModalCreateEdit from '../modals/TaskModalCreateEdit'
import TaskModalDelete from '../modals/TaskModalDelete'

export default {
  name: "TaskItem",
  props: ['item', 'shortTable'],
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
      const { taskId, oid } = splitReminderOccurenceId(task.id)
      const oidParam = oid !== null ? `&oid=${oid}` : ''                // BACK RETURNS 404 with this
      const src_id_params = oid !== null ? `&src_id=${task.id}` : ''    // BACK RETURNS 404 with this
      let target_state = (!(!!task.done_at)).toString()

      try {
        await this.$store.dispatch('reminders/updateTaskStatus', { id: taskId, done: target_state, oidParam, src_id_params })
          .then(response => this.toast('Success', `Updated!`))
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`, true))
      } catch (error) {
        console.error('error catch in task Item', error)
      }
    },
    deleteTask(task, deleteOccurence){
      const occurenceParams = deleteOccurence ? `?oid=${this.occurenceId}` : ''
      this.$store.dispatch('reminders/deleteTask', { id: task.id, occurenceParams })
        .then(response => this.toast('Success', `The task deleted!`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`, true))
    },
    editConfirmed() { console.log('editConfirmed') }
  },
}
</script>

<style scoped>

</style>
