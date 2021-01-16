<template lang="pug">
  table.table
    thead
      tr
        th Name
        th Due date
    tbody
      tr(v-for="(task, i) in taskEvents" :key="i")
        td {{ task.start }}
        td {{ task.title }}
</template>

<script>
import { toEvent } from '../../common/TaskHelper'

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
    }
  }
}
</script>