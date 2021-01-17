<template lang="pug">
  .card
    .card-header.d-flex.justify-content-between
      h3 Projects
      div
        button.btn.btn-dark.float-end New Project
        button.btn.float-end View all
    .card-body
      table.table
        thead
          tr
            th Assignee(s)
            th Title
            th Cost
            th Status
            th Start Date
            th End Date
        tbody
          tr
            td(colspan=6)
</template>

<script>
export default {
}
</script>