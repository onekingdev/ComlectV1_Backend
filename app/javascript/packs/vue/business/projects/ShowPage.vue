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
    b-tabs(content-class="mt-0" v-model="tabIndex")
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
                    button.btn.btn-dark.float-right(v-b-modal.EndContractModal) End Contract
                      b-modal.fade(id="EndContractModal" title="End Contract")
                        p ℹ️ Ending this contract will remove this specialist as a collaborator to the project, revoke and permissions granted due to the project, and payout the full contract price.
                        p: b Do you want to continue?
                        .card
                          .card-header
                            .row
                              .col-sm
                                img.m-r-1.userpic_small(v-if="showingContract.specialist.photo" :src="showingContract.specialist.photo")
                                h3 {{ showingContract.specialist.first_name }} {{showingContract.specialist.last_name }}
                                p Specialist
                              .col-sm
                                span.float-right Outstanding Due <br> {{ 500 | usdWhole }}
                          .card-header
                            p
                              b Project name
                              span.float-right {{ showingContract.title }}
                            p
                              b Payment method
                              span.float-right {{ readablePaymentSchedule(showingContract.payment_schedule) }}
                            p
                              b Date Issued
                              span.float-right
                            p
                              b Payment Method
                              span.float-right Transfer to Visa
                          .card-header
                            p.text-right.text-muted *Transactional fees lorem ipsum dolor.
                        template(slot="modal-footer")
                          button.btn(@click="$bvModal.hide('EndContractModal')") Cancel
                          Post(:action="completeUrl(showingContract)" :model="{}" @saved="completeSuccess" @errors="completeErrors")
                            button.btn.btn-dark.m-r-1 Confirm
                    Breadcrumbs.m-y-1(:items="['Collaborators', `${showingContract.specialist.first_name} ${showingContract.specialist.last_name}`]")
                  .row: .col-sm-12
                    PropertiesTable(title="Contract Details" :properties="contractDetails(showingContract)")
      b-tab(title="Activity")
        .card-body.white-card-body
</template>

<script>
import { fields, readablePaymentSchedule } from '@/common/ProposalFields'
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
      this.newEtag()
      this.$bvModal.hide('EndContractModal')
      this.$bvToast.toast('Project End has been requested', { title: 'Success', autoHideDelay: 5000 })
    },
    completeErrors(errors) {
      errors.length && this.$bvToast.toast('Cannot request End project', { title: 'Error', autoHideDelay: 5000 })
    },
    getContracts(projects) {
      return projects.filter(project => !!project.specialist)
    },
    viewContract(collaborator) {
      this.tabIndex = 3
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
    completeUrl() {
      return project => '/api/projects/' + project.id + '/end'
    },
  }
}
</script>