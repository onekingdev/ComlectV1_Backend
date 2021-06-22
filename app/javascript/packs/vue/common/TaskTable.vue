<template lang="pug">
  table.table.task_table(:class="{ 'short-table': shortTable }")
    thead
      tr
        th Name
        th Due date
    tbody
      tr(v-for="(task, i) in taskEvents" :key="i")
        td
          ion-icon.m-r-1.pointer(@click="toggleDone(task)" v-bind:class="{ done_task: task.done_at }" name='checkmark-circle-outline')
          TaskFormModal(:task-id="task.taskId" :occurence-id="task.oid" @saved="$emit('saved')") {{ task.title }}
        td(:class="{ overdue: isOverdue(task) }") {{ task.end }}
</template>

<script>
import { DateTime } from 'luxon'
import TaskFormModal from '@/common/TaskFormModal'
import { toEvent, isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'

export default {
  props: {
    tasks: {
      type: Array,
      required: true
    },
    shortTable: {
      type: Boolean,
      required: false,
      default: false
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
