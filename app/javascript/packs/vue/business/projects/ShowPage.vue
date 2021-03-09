<template lang="pug">
  Get(:etag="etag" :project="`/api/business/local_projects/${projectId}`"): template(v-slot="{project}")
    .container
      .row.p-x-1
        .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
          div
            Breadcrumbs(:items="['Projects', project.title]")
            h2 {{ project.title }}
            p {{ currentBusiness }}
          div
            p.text-right.m-b-2: b-form-checkbox Show on Calendar
            b-dropdown.m-r-1(text='Actions')
              li: LocalProjectModal(@saved="refetch" :project-id="project.id" :inline="false")
                button.dropdown-item Edit
              b-dropdown-item Delete Project
            a.m-r-1.btn.btn-default(:href='postHref(project)') Post Project
            a.btn.btn-dark Complete Project
    b-tabs(content-class="mt-0")
      b-tab(title="Overview" active)
        .white-card-body.p-y-1
          .container
            .row.p-x-1
              .col-sm-12
                ApplicationsNotice(:project="project.visible_project" v-if="project.visible_project")
                Get(v-if="project.visible_project" :etag="etag" :project="`/api/business/projects/${project.visible_project.id}`"): template(v-slot="{project}")
                  TimesheetsNotice(:project="project")
            .row.p-x-1
              .col-md-7.col-sm-12
                .card
                  ProjectDetails(:project="project" @saved="refetch")
              .col-md-5.col-sm-12.pl-0
                .card
                  .card-header.d-flex.justify-content-between
                    h3.m-y-0 Collaborators
                    a.btn View All
                  .card-body
                    table.rating_table
                      tbody
                        tr
                          td
                            //img.m-r-1.userpic_small(v-bind:src="project['business']['logo']")
                          td
                          td
          .container.m-t-1
            .row.p-x-1
              .col-md-12
                .card
                  .card-header
                    h3 Discussion
                  .card-body No comments posted
      b-tab(title="Tasks")
        .card-body.white-card-body
      b-tab(title="Documents")
        .card-body.white-card-body
      b-tab(title="Collaborators")
        .card-body.white-card-body
      b-tab(title="Activity")
        .card-body.white-card-body
</template>

<script>
import ApplicationsNotice from './ApplicationsNotice'
import TimesheetsNotice from './TimesheetsNotice'
import ProjectDetails from './ProjectDetails'
import EtaggerMixin from '@/mixins/EtaggerMixin'
import LocalProjectModal from './LocalProjectModal'

export default {
  mixins: [EtaggerMixin],
  props: {
    currentBusiness: {
      type: String,
      required: true
    },
    projectId: {
      type: Number,
      required: true
    }
  },
  components: {
    ApplicationsNotice,
    LocalProjectModal,
    TimesheetsNotice,
    ProjectDetails
  },
  computed: {
    postHref() {
      return project => this.$store.getters.url('URL_POST_LOCAL_PROJECT', project.id)
    }
  }
}
</script>