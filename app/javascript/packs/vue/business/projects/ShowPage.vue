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
                DiscussionCard(:project-id="project.id" :token="token")
      b-tab(title="Tasks")
        .card-body.white-card-body
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
                          strong Note:
                          | An unlimited amount of employees can be added to the project but only one specialist can be actively working on a project at a time.
                        InputSelect(value="role" :options="specialists") Select User
                        template(#modal-footer="{ hide }")
                          button.btn(@click="hide") Cancel
                          Post(:action="hireUrl + '?job_application_id=' + project.id" :model="{role}" @saved="newEtag()")
                            button.btn.btn-dark Add
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
                    EndContractModal(:project="showingContract" @saved="contractEnded" @errors="contractEndErrors")
                      button.btn.btn-dark.float-right End Contract
                    b-dropdown.m-x-1.float-right(text="Actions" variant="default")
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
import IssueModal from './IssueModal'

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
    }
  },
  methods: {
    contractEnded() {
      this.newEtag()
      this.toast('Success', 'Project End has been requested')
    },
    contractEndErrors(errors) {
      errors.length && this.toast('Error', 'Cannot request End project')
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
    }
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
    IssueModal
  }
}
</script>
