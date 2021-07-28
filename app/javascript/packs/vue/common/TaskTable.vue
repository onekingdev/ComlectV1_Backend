<template lang="pug">
  table.table.task_table(:class="{ 'short-table': shortTable }")
    thead
      tr
        th Name
        th.text-right Due date
    tbody
      tr(v-for="(task, i) in taskEventsShort" :key="i")
        td
          //ion-icon.m-r-1.pointer(@click="toggleDone(task)" v-bind:class="{ done_task: task.done_at }" name='checkmark-circle-outline')
          TaskFormModal.link(:task-id="task.taskId" :occurence-id="task.oid" @saved="$emit('saved')") {{ task.title }}
        td.text-right(class="due-date" :class="{ overdue: isOverdue(task) }")
          b-icon.mr-2(v-if="isOverdue(task)" icon="exclamation-triangle-fill" variant="warning")
          | {{ task.end }}
</template>

<script>
import { DateTime } from 'luxon'
import TaskFormModal from '@/common/TaskFormModal'
import { toEvent, isOverdue, splitReminderOccurenceId } from '@/common/TaskHelper'

const SHORT_TASK_COUNT = 6

export default {
  props: {
    tasks: {
      type: Array,
      required: true
    },
    shortTable: {
      type: Boolean,
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
    },
    taskEventsShort() {
      return this.shortTable ? this.taskEvents.slice(0, SHORT_TASK_COUNT) : this.taskEvents
    }
  },
  components: {
    TaskFormModal
  }
}
</script>
