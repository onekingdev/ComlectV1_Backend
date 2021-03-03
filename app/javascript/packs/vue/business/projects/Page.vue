<template lang="pug">
  div
    .container
      .row.p-x-1
        .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
          div
            h2 <b>Projects</b>
            p Plan projects with employees or hire specialists for additional help
          div
            a.btn.btn-default(href='/business/projects/new') Post Project
            LocalProjectModal(@saved="refetch")
              a.btn.m-l-1.btn-dark New Project

    b-tabs(content-class="mt-0")
      b-tab(title="My Projects" active="")
        .card-body.white-card-body
          div
            b-dropdown.m-r-1(text='Filter by: All')
              b-dropdown-item All
              b-dropdown-item In Progress
              b-dropdown-item Pending
              b-dropdown-item Overdue
              b-dropdown-item Complete
            b-dropdown.m-r-1(text='Year: All')
              b-dropdown-item 2021
              b-dropdown-item 2020
          ProjectTable(:projects="projects")
      b-tab(title="Contacts")
        .card-body.white-card-body
          table.table
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
        .card-body.white-card-body
          p Ratings and Reviews

</template>

<script>
import ProjectTable from '@/common/ProjectTable'
import LocalProjectModal from './LocalProjectModal'

const endpointUrl = '/api/business/local_projects/'

export default {
  data() {
    return {
      projects: []
    }
  },
  created() {
    this.refetch()
  },
  methods: {
    refetch() {
      fetch(endpointUrl, { headers: {'Accept': 'application/json'} })
        .then(response => response.json())
        .then(result => this.projects = result)
    }
  },
  computed: {
    contacts() {
      return this.projects.reduce((result, project) => {
        for (const p in project.projects) {
          const spec = project.projects[p].specialist
          if (spec && !result.find(s => s.id === spec.id)) {
            result.push({
              id: spec.id,
              name: spec.first_name + ' ' + spec.last_name,
              location: [spec.country, spec.state, spec.city].filter(a => a).join(', '),
              status: spec.visibility,
              rating: 5
            })
          }
        }
        return result
      }, [])
    }
  },
  components: {
    ProjectTable,
    LocalProjectModal
  }
}
</script>