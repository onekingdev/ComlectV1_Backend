<template lang="pug">
  div
    .container
      .row.p-x-1
        .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
          div
            h2: b Projects
          div
            a.btn.btn-default(href='/projects') Browse Projects
    b-tabs(content-class="mt-0")
      b-tab(title="My Projects" active)
        .card-body.white-card-body
          .container
            div
              b-dropdown.m-r-1(text='Filter by: All')
                b-dropdown-item All
              b-dropdown.m-r-1(text='Year: All')
                b-dropdown-item 2021
                b-dropdown-item 2020
            Get(:projects="apiProjectsUrl"): template(v-slot="{projects}"): table.table.task_table
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
                  td
                    span.badge(:class="badgeClass(project)") {{ project.status }}
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
import { isOverdue, badgeClass } from '@/common/TaskHelper'

export default {
  computed: {
    apiProjectsUrl() {
      return '/api/specialist/projects/my'
    },
    linkProjectUrl() {
      return id => `/specialist/my-projects/${id}`
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
  },
  methods: {
    isOverdue,
    badgeClass
  }
}
</script>