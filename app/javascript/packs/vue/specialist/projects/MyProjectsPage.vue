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
      .card-body.white-card-body
        Get(:contacts="apiProjectsUrl" :callback="getContacts"): template(v-slot="{contacts}"): table.table
          thead
            tr
              th Name
              th Location
              th Status
              th Rating
              th
          tbody
            tr(v-for="contact in contacts" :key="contact.id")
              td {{ contact.name }}
              td {{ contact.location }}
              td {{ contact.status }}
              td: StarRating(:stars="contact.rating")
              td &hellip;
            tr(v-if="!contacts.length")
              td(colspan=5) No contacts
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
    },
    getContacts() {
      return projects => projects.reduce((contacts, project) => {
        const alreadyThere = contacts.find(contact => contact.id === project.business.id)
        if (!alreadyThere) {
          contacts.push({
            id: project.business.id,
            name: project.business.business_name,
            location: [project.business.city, project.business.country, project.business.state].filter(l => l).join(', '),
            status: null,
            rating: 5
          })
        }
        return contacts
      }, [])
    }
  }
}
</script>