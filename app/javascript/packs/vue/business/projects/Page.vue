<template lang="pug">
  .page
    .page-header
      .page-header__title
        h2.m-b-10 Projects
        p.page-header__subtitle.mb-0 Plan projects with employees or hire external specialists to help
      .page-header__actions
        router-link.btn.btn-default.m-r-1(to='/business/projects/new') Post Project
        LocalProjectModal(@saved="newEtag")
          a.btn.btn-primary New Project
    b-tabs.special-navs(content-class="mt-0")
      b-tab(title="My Projects" active)
        .card-body.white-card-body.card-body_full-height
          div.m-b-20
            b-dropdown.m-r-1(variant="default")
              template(#button-content)
                | Filter by: All
                ion-icon.ml-2(name="chevron-down-outline" size="small")
              b-dropdown-item All
              b-dropdown-item In Progress
              b-dropdown-item Pending
              b-dropdown-item Overdue
              b-dropdown-item Complete
            //b-dropdown.m-r-1(variant="default")
            //  template(#button-content)
            //    | Year: All
            //    ion-icon.ml-2(name="chevron-down-outline" size="small")
            //  b-dropdown-item 2021
            //  b-dropdown-item 2020
          Get(projects="/api/business/local_projects/" :etag="etag"): template(v-slot="{projects}")
              ProjectTable(:projects="projects")
      b-tab(title="Contacts")
        .card-body.white-card-body.card-body_full-height
          Get(contacts="/api/business/local_projects/" :etag="etag" :callback="getContacts"): template(v-slot="{contacts}"): table.table
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
                td: .badge.badge-success {{ contact.status }}
                td: StarRating(:stars="contact.rating")
                td &hellip;
      b-tab(title="Ratings and Reviews")
        .card-body.white-card-body.card-body_full-height
          Get(ratings='/api/project_ratings'): template(v-slot="{ratings}")
            table.rating_table(v-if="ratings.length")
              tbody
                tr(v-for="rating in ratings")
                  td
                    img.m-r-1.userpic_small(v-bind:src="rating.rater_pic")
                  td
                    h3 {{rating.project_title}}
                    p {{rating.rater_name}} | {{rating.created_at | asDate}}
                    p: i "{{rating.review}}"
                  td: StarRating(:stars="rating.value")
                tr(v-if="!ratings.length")
                  td.text-center
                    h3.text-dark.p-y-2 No ratings
            .row.h-100(v-if="!ratings.length")
              .col.h-100.text-center
                EmptyState(name="Tasks")
</template>

<script>
import ProjectTable from './ProjectTable'
import LocalProjectModal from './LocalProjectModal'
import EtaggerMixin from '@/mixins/EtaggerMixin'

export default {
  mixins: [EtaggerMixin()],
  methods: {
    getContacts(projects) {
      return projects.reduce((result, project) => {
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
