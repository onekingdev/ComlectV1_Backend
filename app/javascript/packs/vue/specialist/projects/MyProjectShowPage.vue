<template lang="pug">
  b-tabs
    b-tab(title="Overview" active)
      .row
        .col-sm
          .card
            .card-header Project Details
            .card-body
              dl.row
                dt.col-sm-3 Title
                dd.col-sm-9
                dt.col-sm-3 Start Date
                dd.col-sm-9
                dt.col-sm-3 Due Date
                dd.col-sm-9
                dt.col-sm-3 Description
                dd.col-sm-9
        .col-sm
          .card
            .card-header Collaborators
            .card-body
              table.table
                thead
                  tr
                    th Name
                    th
                tbody
                  tr
                    td
                    td
</template>

<script>
export default {
}
</script>