<template lang="pug">
  Get(:etag="etag" :project="`/api/business/local_projects/${projectId}`"): template(v-slot="{project}")
    CommonHeader(:title="project.title" :sub="currentBusiness" :breadcrumbs="['Projects', project.title]")
      p.text-right.m-b-2: ShowOnCalendarToggle(:project="project")
      b-dropdown.m-r-1(text='Actions' variant='default')
        li: LocalProjectModal(@saved="newEtag" :project-id="project.id" :inline="false")
          button.dropdown-item Edit
        li: DeleteLocalProjectModal(:project="project")
      a.m-r-1.btn.btn-default(v-if="project.visible_project" :href='viewHref(project.visible_project)') View Post
      a.m-r-1.btn.btn-default(v-else :href='postHref(project)') Post Project
      CompleteLocalProjectModal(:project="project" @saved="newEtag")
    b-tabs(content-class="mt-0" v-model="tab")
      b-tab(title="Overview" active)
        .white-card-body.p-y-1
          .container
            .row.p-x-1
              .col-sm-12
                ApplicationsNotice(:project="project.visible_project" v-if="project.visible_project")
                Get(v-for="marketProject in project.projects" :etag="etag" :marketProject="`/api/business/projects/${marketProject.id}`" :key="marketProject.id"): template(v-slot="{marketProject}")
                  TimesheetsNotice(:project="marketProject")
                  EndContractNotice(:project="marketProject" @saved="contractEnded" @errors="contractEndErrors")
                  ChangeContractAlerts(:project="marketProject" @saved="newEtag" for="Business")
            .row.p-x-1
              .col
                DueDateNotice(:project="project" @saved="newEtag")
            .row.p-x-1
              .col-md-8.col-sm-12
                .card
                  ProjectDetails(:project="project" @saved="newEtag")
              .col-md-4.col-sm-12.pl-0
                .card
                  .card-header.d-flex.justify-content-between
                    h3.m-y-0 Collaborators
                    a.link.btn(@click="viewContract()") View All
                  .card-body
                    table.rating_table(v-if="getContracts(project.projects).length")
                      thead
                        tr
                          th
                            | Name
                            b-icon.ml-2(icon='chevron-expand')
                          th
                      tbody
                        tr(v-for="contract in getContracts(project.projects)" :key="contract.specialist.id")
                          td
                            .d-flex.align-items-center.mb-3
                              div
                                UserAvatar.userpic_small.mr-2(:user="contract.specialist")
                              div.d-flex.flex-column
                                b {{ contract.specialist.first_name }} {{ contract.specialist.last_name }}
                                span {{ contract.specialist.seat_role }}
                          td
                            b-dropdown.float-right(text="..." variant="default" right)
                              b-dropdown-item(@click="viewContract(contract)") View Contract
                    .d-flex.justify-content-center(v-if="!getContracts(project.projects).length")
                      h5.text-dark Collaborators not exist
          .container.m-t-1
            .row.p-x-1
              .col-md-12
                DiscussionCard(:project-id="project.id" :token="token")
      b-tab(title="Tasks")
        .card-body.white-card-body
          TaskFormModal(id="ProjectTaskFormModal" @saved="taskSaved")
            button.btn.btn-dark.m-r-1 New Task
          b-dropdown(text="Show: All Tasks" variant="default")
            b-dropdown-item All Tasks
            b-dropdown-item My Tasks
            b-dropdown-item Complete Tasks
          button.btn.btn-default.float-right(@click="completedTasksOpen = false"): strong Collapse All
          TaskTable(v-if="incompleteTasks.length" :tasks="incompleteTasks")
          p(v-else) No incomplete tasks.
          h3.pointer(v-if="completedTasks.length" @click="completedTasksOpen = !completedTasksOpen")
            span.caret(:class="{caret_rotated:!completedTasksOpen}")
            | Completed Tasks
          b-collapse.m-t-1(v-if="completedTasks.length" v-model="completedTasksOpen")
            TaskTable(:tasks="completedTasks")
      b-tab(title="Documents")
        DocumentList(:project="project")
      b-tab(title="Collaborators")
        .white-card-body.p-y-1
          .container
            .row.p-x-1
              .col-sm-12
                .card(v-if="!showingContract")
                  .card-header.d-flex.justify-content-between
                    h3.m-y-0 Collaborators
                    Get(:etag="etag" :specialists="`/api/business/specialists`" :callback="getSpecialistsOptions" ): template(v-slot="{specialists}")
                      button.btn.btn-default.float-right(v-b-modal="'AddCollaboratorModal'") Add Collaborator
                      b-modal#AddCollaboratorModal(title="Add Collaborator" :project="project")
                        p Select a user to add.
                        p
                          strong Note:&nbsp;
                          | An unlimited amount of employees can be added to the project but only one specialist can be actively working on a project at a time.
                        InputSelect(value="role" :options="specialists") Select User
                        template(#modal-footer="{ hide }")
                          button.btn(@click="hide") Cancel
                          Post(:action="hireUrl + '?job_application_id=' + project.id" :model="{role}" @saved="newEtag()")
                            button.btn.btn-dark Add
                  .card-body
                    .card
                      .card-header(v-for="contract in getContracts(project.projects)" :key="contract.specialist.id")
                        .d-flex.justify-content-between.align-items-center
                          .d-flex.align-items-center.mb-2
                              div
                                UserAvatar.userpic_small.mr-2(:user="contract.specialist")
                              div.d-flex.flex-column
                                b {{ contract.specialist.first_name }} {{ contract.specialist.last_name }}
                                span {{ contract.specialist.seat_role }}
                          .d-flex.justify-content-end
                            b-dropdown.bg-white.mr-2(variant="light", right)
                              template(#button-content)
                                | Actions
                                b-icon.ml-2(icon="chevron-down")
                              b-dropdown-item Messages
                              b-dropdown-item Edit Permissions
                            button.btn.btn-default(@click="showingContract = contract") View Contract
                      .card-header(v-if="!getContracts(project.projects).length")
                        .d-flex.justify-content-center
                          h5.text-dark Collaborators not exist
                div(v-else)
                  .row: .col-sm-12
                    EndContractModal(:project="showingContract" @saved="contractEnded" @errors="contractEndErrors")
                      button.btn.btn-dark.float-right End Contract
                    b-dropdown.m-x-1.float-right(text="Actions" variant="default")
                      EditRoleModal(:specialist="showingContract.specialist" :inline="false" @saved="accepted")
                        b-dropdown-item Set role
                      b-dropdown-item(v-b-modal="'IssueModal'") Report Issue
                    IssueModal(:project-id="showingContract.id" :token="token")
                    Breadcrumbs.m-y-1(:items="['Collaborators', `${showingContract.specialist.first_name} ${showingContract.specialist.last_name}`]")
                  .row: .col-sm-12
                    PropertiesTable(title="Contract Details" :properties="contractDetails(showingContract)")
                      EditContractModal(:project="showingContract" @saved="newEtag(), tab = 0")
</template>

<script>
import { fields, readablePaymentSchedule } from '@/common/ProposalFields'
import DiscussionCard from '@/common/projects/DiscussionCard'
import ApplicationsNotice from './alerts/ApplicationsNotice'
import DueDateNotice from './alerts/DueDateNotice'
import TimesheetsNotice from './alerts/TimesheetsNotice'
import EndContractNotice from './alerts/EndContractNotice'
import ProjectDetails from './ProjectDetails'
import DocumentList from './DocumentList'
import EtaggerMixin from '@/mixins/EtaggerMixin'
import LocalProjectModal from './LocalProjectModal'
import CompleteLocalProjectModal from './CompleteLocalProjectModal'
import DeleteLocalProjectModal from './DeleteLocalProjectModal'
import EndContractModal from './EndContractModal'
import ShowOnCalendarToggle from './ShowOnCalendarToggle'
import ChangeContractAlerts from '@/common/projects/ChangeContractAlerts'
import EditContractModal from '@/common/projects/EditContractModal'
import TaskFormModal from '@/common/TaskFormModal'
import TaskTable from './ShowPageTaskTable'
import IssueModal from './IssueModal'
import EditRoleModal from './EditRoleModal'

const TOKEN = localStorage.getItem('app.currentUser.token') ? JSON.parse(localStorage.getItem('app.currentUser.token')) : ''

export default {
  mixins: [EtaggerMixin()],
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
      role: '',
      modalId: null,
      completedTasksOpen: true,
    }
  },
  created() {
    this.modalId = 'modal_' + Math.random().toFixed(9) + Math.random().toFixed(7)
  },
  methods: {
    contractEnded() {
      this.newEtag()
      this.toast('Success', 'Project End has been requested')
    },
    contractEndErrors(errors) {
      errors.length && this.toast('Error', 'Cannot request End project')
    },
    taskSaved() {
      this.toast('Success', 'Task created')
    },
    getContracts(projects) {
      return projects.filter(project => !!project.specialist)
    },
    viewContract(collaborator) {
      this.tab = 3
      this.showingContract = collaborator || null
    },
    contractDetails: fields,
    readablePaymentSchedule,
    getSpecialistsOptions(specialists) {
      return specialists.map(({ id, first_name, last_name }) => ({ id: id, label: `${first_name} ${last_name}`}))
    },
    accepted(id, role) {
      fetch(`/api/business/specialist_roles/${id}`, {
        method: 'PATCH',
        headers: { 'Authorization': `${TOKEN}`,  'Accept': 'application/json',  'Content-Type': 'application/json' },
        body: JSON.stringify({ "specialist": { "role": `${role}` } })
      })
        .then(response => response.json())
        .then(result => this.toast('Success', 'The Role has been setted!'))
        .catch(error => console.error(error))
    },
  },
  computed: {
    postHref() {
      return project => this.$store.getters.url('URL_POST_LOCAL_PROJECT', project.id)
    },
    viewHref() {
      return project => this.$store.getters.url('URL_PROJECT_POST', project.id)
    },
    hireUrl() {
      return project => this.$store.getters.url('URL_API_PROJECT_HIRES', project.id)
    },
    applicationsUrl() {
      return this.$store.getters.url('URL_API_PROJECT_APPLICATIONS', this.projectId)
    },
    confirmModalId() {
      return (this.modalId || '') + '_confirm'
    },
    incompleteTasks() {
      return []
    },
    completedTasks() {
      return []
    }
  },
  components: {
    ApplicationsNotice,
    DueDateNotice,
    ChangeContractAlerts,
    DiscussionCard,
    LocalProjectModal,
    CompleteLocalProjectModal,
    DeleteLocalProjectModal,
    TimesheetsNotice,
    EndContractNotice,
    EndContractModal,
    ProjectDetails,
    ShowOnCalendarToggle,
    DocumentList,
    EditContractModal,
    IssueModal,
    EditRoleModal,
    TaskFormModal,
    TaskTable,
  }
}
</script>
