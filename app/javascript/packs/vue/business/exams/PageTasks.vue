<template lang="pug">
  .container
    .row.p-x-1
      .col
        .card-body.white-card-body.reviews__card
          .reviews__topiclist
            .reviews__card--header.p-b-20
              h2 Tasks
              div
                a.btn.btn-default.m-r-1 Download
                a.btn.btn-dark Create task
            .reviews__card--internal.borderless
              table.table.task_table
                thead
                  tr
                    th(width="40%")
                      | Name
                      b-icon.ml-2(icon='chevron-expand')
                    th
                      | Assignee
                      b-icon.ml-2(icon='chevron-expand')
                    th.text-right
                      | Start date
                      b-icon.ml-2(icon='chevron-expand')
                    th.text-right
                      | Due date
                      b-icon.ml-2(icon='chevron-expand')
                    th.text-right
                      | Files
                      b-icon.ml-2(icon='chevron-expand')
                    th.text-right
                      | Comments
                      b-icon.ml-2(icon='chevron-expand')
                    th.text-right(width="35px")
              EmptyState

</template>

<script>

</script>
