<template lang="pug">
  Get(:etag="etag" :project="`/api/business/local_projects/${projectId}`"): template(v-slot="{project}")
    CommonHeader(:title="project.title" :sub="currentBusiness" :breadcrumbs="['Projects', project.title]")
      p.text-right.m-b-2: b-form-checkbox Show on Calendar
      b-dropdown.m-r-1(text='Actions' variant='default')
        li: LocalProjectModal(@saved="newEtag" :project-id="project.id" :inline="false")
          button.dropdown-item Edit
        b-dropdown-item Delete Project
      a.m-r-1.btn.btn-default(v-if="project.visible_project" :href='viewHref(project.visible_project)') View Post
      a.m-r-1.btn.btn-default(v-else :href='postHref(project)') Post Project
      button.btn.btn-dark(v-b-modal.CompleteProjectModal) Complete Project
        b-modal.fade(id="CompleteProjectModal" title="Complete Project" no-stacking)
          p ✔ The following project will be marked as complete.
          p {{ project.title }}
          p: b Do you want to continue?
          template(slot="modal-footer")
            button.btn(@click="$bvModal.hide('CompleteProjectModal')") Cancel
            Post(:action="completeUrl(project)" :model="{}" @saved="completeSuccess" @errors="completeErrors")
              button.btn.btn-dark.m-r-1 Confirm
    b-tabs(content-class="mt-0" v-model="tabIndex" @activate-tab="showingContract = null")
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
                  ProjectDetails(:project="project" @saved="newEtag")
              .col-md-5.col-sm-12.pl-0
                .card
                  .card-header.d-flex.justify-content-between
                    h3.m-y-0 Collaborators
                    button.btn.btn-default(@click="tabIndex = 3") View All
                  .card-body
                    table.rating_table
                      tbody
                        tr(v-for="collaborator in collaborators(project.visible_project)" :key="collaborator.id")
                          td
                            img.m-r-1.userpic_small(v-if="collaborator.photo" :src="collaborator.photo")
                            b {{ collaborator.first_name }} {{collaborator.last_name }},
                            | Specialist
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
        .white-card-body.p-y-1
          .container
            .row.p-x-1
              .col-sm-12
                .card
                  .card-header.d-flex.justify-content-between
                    h3.m-y-0 Collaborators
                  .card-body
                    table.rating_table(v-if="!showingContract")
                      tbody
                        tr(v-for="collaborator in collaborators(project.visible_project)" :key="collaborator.id")
                          td
                            button.btn.btn-default.float-right(@click="showingContract = collaborator") View Contract
                            img.m-r-1.userpic_small(v-if="collaborator.photo" :src="collaborator.photo")
                            b {{ collaborator.first_name }} {{collaborator.last_name }},
                            | Specialist
                          td
                    div(v-else)
                      Breadcrumbs(:items="['Collaborators', `${showingContract.first_name} ${showingContract.last_name}`]")
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
  data() {
    return {
      tabIndex: 0,
      showingContract: null
    }
  },
  components: {
    ApplicationsNotice,
    LocalProjectModal,
    TimesheetsNotice,
    ProjectDetails
  },
  methods: {
    completeSuccess() {
      alert('Complete success')
    },
    completeErrors(errors) {
      alert('Complete error')
    },
    collaborators(project) {
      return [project.specialist]
    },
  },
  computed: {
    postHref() {
      return project => this.$store.getters.url('URL_POST_LOCAL_PROJECT', project.id)
    },
    viewHref() {
      return project => this.$store.getters.url('URL_PROJECT_POST', project.id)
    },
    completeUrl() {
      return project => '/api/projects/' + project.id + '/end'
    },
  }
}
</script>