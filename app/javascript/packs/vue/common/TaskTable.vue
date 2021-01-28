<template lang="pug">
  table.table.task_table
    thead
      tr
        th Name
        th Due date
    tbody
      tr(v-for="(task, i) in taskEvents" :key="i")
        td
          ion-icon.m-r-1.pointer(v-if="task.remind_at" @click="markDone(task)" name='checkmark-circle-outline')
          ion-icon.m-r-1(v-else name='checkmark-circle-outline')
          TaskFormModal(v-if="task.remind_at" :task-id="task.taskId" @saved="$emit('saved')") {{ task.title }}
          span(v-else) {{ task.title }}
        td(:class="{ overdue: isOverdue(task) }") {{ task.end }}
</template>

<script>
import { toEvent } from '@/common/TaskHelper'
import { DateTime } from 'luxon'
import TaskFormModal from '@/common/TaskFormModal'
import { isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'

export default {
  props: {
    tasks: {
      type: Array,
      required: true
    }
  },
  methods: {
    isOverdue,
    markDone(task) {
      const { taskId, oid } = splitReminderOccurenceId(task.id)
      const oidParam = oid !== null ? `&oid=${oid}` : ''
      fetch(`/api/business/reminders/${taskId}?done=1${oidParam}`, {
        method: 'POST',
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      }).then(response => this.$emit('saved'))
    }
  },
  computed: {
    taskEvents() {
      return this.tasks.map(toEvent)
        .map(e => ({
          ...e,
          start: DateTime.fromSQL(e.start).toLocaleString(),
          end: DateTime.fromSQL(e.end).toLocaleString(),
          ...splitReminderOccurenceId(e.id)
        }))
    }
  },
  components: {
    TaskFormModal
  }
}
</script>

<style scoped>
.pointer {
  cursor: pointer;
}
</style>