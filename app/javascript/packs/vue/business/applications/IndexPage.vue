<template lang="pug">
  .row
    .col-sm
      .card
        .card-header Requirements
        .card-body
    .col-sm
      .card
        .card-header Applicants
        .card-body
          p(v-if="!applications.length") No applicants
          table.table(v-else)
            thead
              tr
                th Name
                th
            tbody
              tr(v-for="application in applications" :key="application.id")
                td {{ application.specialist.first_name }} {{ application.specialist.last_name }}
                td: a(href="#") View
</template>

<script>
export default {
  props: {
    applications: Array,
    required: true
  }
}
</script>