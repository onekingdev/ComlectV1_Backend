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
      button.btn.btn-dark Complete Project
    b-tabs(content-class="mt-0" v-model="tab")
      b-tab(title="Overview" active)
        .white-card-body.p-y-1
          .container
            .row.p-x-1
              .col-sm-12
                ApplicationsNotice(:project="project.visible_project" v-if="project.visible_project")
                Get(v-for="marketProject in project.projects" :etag="etag" :marketProject="`/api/business/projects/${marketProject.id}`" :key="marketProject.id"): template(v-slot="{marketProject}")
                  TimesheetsNotice(:project="marketProject")
                  EndContractNotice(:project="marketProject" @saved="completeSuccess" @errors="completeErrors")
                  ChangeContractAlerts(:project="marketProject" @saved="newEtag" for="Business")
            .row.p-x-1
              .col-md-7.col-sm-12
                .card
                  ProjectDetails(:project="project" @saved="newEtag")
              .col-md-5.col-sm-12.pl-0
                .card
                  .card-header.d-flex.justify-content-between
                    h3.m-y-0 Collaborators
                    button.btn.btn-default(@click="viewContract()") View All
                  .card-body
                    table.rating_table
                      tbody
                        tr(v-for="contract in getContracts(project.projects)" :key="contract.specialist.id")
                          td
                            img.m-r-1.userpic_small(v-if="contract.specialist.photo" :src="contract.specialist.photo")
                            b {{ contract.specialist.first_name }} {{ contract.specialist.last_name }},
                            |  Specialist
                          td
                            b-dropdown.float-right(text="..." variant="default")
                              b-dropdown-item(@click="viewContract(contract)") View Contract
          .container.m-t-1
            .row.p-x-1
              .col-md-12
                .card
                  .card-header
                    h3 Discussion
                  Get(:messages="messagesUrl(project)" :etag="etag"): template(v-slot="{messages}")
                    .card-body(v-if="!messages.length")
                      | No comments posted
                      hr
                    .card-body(v-else)
                      div(v-for="message in messages" :key="message.id")
                        p
                          span.float-right {{ message.created_at | asDate }}
                          | {{ message.message }}
                        hr
                  .card-body
                    InputTextarea(v-model="newComment.message" placeholder="Make a comment or leave a note..." :errors="newCommentErrors && newCommentErrors.message") Comment
                    Post(v-bind="postCommentProps(project)" @saved="commentSaved" @errors="newCommentErrors = $event")
                      button.btn.btn-default Add Comment
      b-tab(title="Tasks")
        .card-body.white-card-body
      b-tab(title="Documents")
        .card-body.white-card-body
      b-tab(title="Collaborators")
        .white-card-body.p-y-1
          .container
            .row.p-x-1
              .col-sm-12
                .card(v-if="!showingContract")
                  .card-header.d-flex.justify-content-between
                    h3.m-y-0 Collaborators
                  .card-body
                    table.rating_table
                      tbody
                        tr(v-for="contract in getContracts(project.projects)" :key="contract.specialist.id")
                          td
                            button.btn.btn-default.float-right(@click="showingContract = contract") View Contract
                            img.m-r-1.userpic_small(v-if="contract.specialist.photo" :src="contract.specialist.photo")
                            b {{ contract.specialist.first_name }} {{contract.specialist.last_name }},
                            |  Specialist
                          td
                div(v-else)
                  .row: .col-sm-12
                    EndContractModal(:project="showingContract" @saved="completeSuccess" @errors="completeErrors")
                      button.btn.btn-dark.float-right End Contract
                    Breadcrumbs.m-y-1(:items="['Collaborators', `${showingContract.specialist.first_name} ${showingContract.specialist.last_name}`]")
                  .row: .col-sm-12
                    PropertiesTable(title="Contract Details" :properties="contractDetails(showingContract)")
                      EditContractModal(:project="showingContract" @saved="newEtag(), tab = 0")
      b-tab(title="Activity")
        .card-body.white-card-body
</template>

<script>
import { fields, readablePaymentSchedule } from '@/common/ProposalFields'
import ApplicationsNotice from './alerts/ApplicationsNotice'
import TimesheetsNotice from './alerts/TimesheetsNotice'
import EndContractNotice from './alerts/EndContractNotice'
import ProjectDetails from './ProjectDetails'
import EtaggerMixin from '@/mixins/EtaggerMixin'
import LocalProjectModal from './LocalProjectModal'
import EndContractModal from './EndContractModal'
import ChangeContractAlerts from '@/common/projects/ChangeContractAlerts'
import EditContractModal from '@/common/projects/EditContractModal'

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
    },
    token: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      tab: 0,
      showingContract: null,
      newComment: { message: null },
      newCommentErrors: null
    }
  },
  methods: {
    completeSuccess() {
      this.newEtag()
      this.toast('Success', 'Project End has been requested')
    },
    completeErrors(errors) {
      errors.length && this.toast('Error', 'Cannot request End project')
    },
    commentSaved() {
      this.newEtag()
      this.toast('Success', 'Comment added')
      this.newComment.message = null
    },
    postCommentProps(project) {
      return {
        action: this.messagesUrl(project),
        model: { message: this.newComment },
        headers: { Authorization: this.token },
      }
    },
    getContracts(projects) {
      return projects.filter(project => !!project.specialist)
    },
    viewContract(collaborator) {
      this.tab = 3
      this.showingContract = collaborator || null
    },
    contractDetails: fields,
    readablePaymentSchedule
  },
  computed: {
    postHref() {
      return project => this.$store.getters.url('URL_POST_LOCAL_PROJECT', project.id)
    },
    viewHref() {
      return project => this.$store.getters.url('URL_PROJECT_POST', project.id)
    },
    messagesUrl() {
      return project => `/api/local_projects/${project.id}/messages`
    },
  },
  components: {
    ApplicationsNotice,
    ChangeContractAlerts,
    LocalProjectModal,
    TimesheetsNotice,
    EndContractNotice,
    EndContractModal,
    ProjectDetails,
    EditContractModal
  }
}
</script>