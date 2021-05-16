<template lang="pug">
  table.table
    thead
      tr
        th Name
        th Assignee
        th Start Date
        th Due Date
        th Comments
        th Files
    tbody
      tr(v-for="(task, i) in tasks" :key="i")
        td {{ task.body }}
        td
        td {{ task.remind_at | asDate  }}
        td {{ task.end_date | asDate  }}
        td 0
        td 0
</template>

<script>
export default {
  props: {
    tasks: {
      type: Array,
      required: true
    }
  }
}
</script>