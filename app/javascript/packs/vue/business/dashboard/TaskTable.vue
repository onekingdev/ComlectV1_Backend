<template lang="pug">
  table.table.task_table
    thead
      tr
        th Name
        th Due date
    tbody
      tr(v-for="(task, i) in taskEvents" :key="i")
        td
          ion-icon.m-r-1(name='checkmark-circle-outline')
          TaskFormModal(v-if="task.remind_at" :task-id="+task.id" @saved="$emit('saved')") {{ task.title }}
          span(v-else) {{ task.title }}
        td(:class="{ overdue: isOverdue(task) }") {{ task.end }}
</template>

<script>
import { toEvent } from '@/common/TaskHelper'
import { DateTime } from 'luxon'
import TaskFormModal from '@/common/TaskFormModal'
import { isOverdue } from '@/common/TaskHelper'

export default {
  props: {
    tasks: {
      type: Array,
      required: true
    }
  },
  computed: {
    taskEvents() {
      return this.tasks.map(toEvent)
        .map(e => ({
          ...e,
          start: DateTime.fromSQL(e.start).toLocaleString(),
          end: DateTime.fromSQL(e.end).toLocaleString()
        }))
    }
  },
  components: {
    TaskFormModal
  },
  methods: {
    isOverdue: isOverdue
  }
}
</script>