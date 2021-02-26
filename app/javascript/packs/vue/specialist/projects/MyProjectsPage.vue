<template lang="pug">
  b-tabs(content-class="mt-3")
    b-tab(title="My Projects" active)
      .row
        .col-sm
          select.custom-select
            option(value) Filter by: All
        .col-sm
          select.custom-select
            option(value) Year: All
      table.table
        thead
          tr
            th Title
            th Client
            th Payment
            th Status
            th Start Date
            th End Date
        tbody
          tr(v-for="project in projects" :key="project.id")
            td
            td
            td
            td
            td
            td
    b-tab(title="Contacts")
      p Contacts
    b-tab(title="Ratings and Reviews")
      p Ratings and Reviews
</template>

<script>
export default {
  computed: {
    projects() {
      return []
    }
  }
}
</script>