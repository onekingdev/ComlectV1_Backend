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
      Get(:projects="apiProjectsUrl"): template(v-slot="{projects}"): table.table
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
            td: a(:href="linkProjectUrl(project.id)") {{ project.title }}
            td {{ project.business.business_name }}
            td {{ (project.fixed_budget || project.est_budget) | usdWhole }}
            td {{ project.status }}
            td {{ project.starts_on | asDate }}
            td {{ project.ends_on | asDate }}
    b-tab(title="Contacts")
      p Contacts
    b-tab(title="Ratings and Reviews")
      p Ratings and Reviews
</template>

<script>
export default {
  computed: {
    apiProjectsUrl() {
      return this.$store.getters.url('URL_API_MY_PROJECTS')
    },
    linkProjectUrl() {
      return id => this.$store.getters.url('URL_MY_PROJECT_SHOW', id)
    }
  }
}
</script>