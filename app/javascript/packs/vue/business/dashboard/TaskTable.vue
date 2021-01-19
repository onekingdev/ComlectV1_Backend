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
          CreateTaskModal(v-if="task.remind_at" :task-id="task.id" @created="$emit('created')") {{ task.title }}
          span(v-else) {{ task.title }}
        td {{ task.end }}
</template>

<script>
import { toEvent } from '@/common/TaskHelper'
import { DateTime } from 'luxon'
import CreateTaskModal from '@/common/CreateTaskModal'

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
    CreateTaskModal
  }
}
</script>