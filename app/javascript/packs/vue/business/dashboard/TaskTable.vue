<template lang="pug">
  table.table
    thead
      tr
        th Name
        th Due date
    tbody
      tr(v-for="(task, i) in taskEvents" :key="i")
        td {{ task.title }}
        td {{ task.start }}
</template>

<script>
import { toEvent } from '@/common/TaskHelper'
import { DateTime } from 'luxon'

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
          start: DateTime.fromSQL(e.start).toLocaleString()
        }))
    }
  }
}
</script>