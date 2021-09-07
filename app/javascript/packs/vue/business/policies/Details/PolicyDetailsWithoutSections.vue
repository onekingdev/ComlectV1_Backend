<template lang="pug">
  div.policy
    .container-fluid
      .row
        .col-12.col-lg-3.px-0(v-if="leftMenu")
          .card-body.white-card-body.p-20.left-tree
            PoliciesModalCreate(@saved="updateList")
              button.btn.btn-dark.mb-3.mr-3 New Policy
            .table
              nested-draggable(v-model='policiesComputed', :policiesList="policiesListNested" :shortTable="true")
        .col.col-lg-9.px-0(v-if="policy")
          .policy-topbar
            .d-flex.align-items-center
              button.btn.btn__menu.mr-3(@click="leftMenu = !leftMenu")
                b-icon(icon='list')
              b-badge.mr-3(:variant="statusVariant(policy.status)") {{ policy.status }}
              h3.policy__main-title.m-y-0 {{ policy.title }}
            .d-flex.justify-content-end.align-items-center(v-if="!policy.archived")
              a.link.btn.mr-3(@click="saveDraft") Save Draft
              span.dowloading(v-if="isDowloading")
                img(src='@/assets/sm-loading.gif' width="25" height="25")
              button.btn.btn-default.mr-3(v-if="!isDowloading && policy.status != 'draft' && policy.status != 'archived'" @click="download") Download
              PoliciesModalPublish(@publishConfirmed="publishPolicy")
                button.btn.btn-dark.mr-3 Publish
              button.btn.btn__close(@click="closeAndExit")
                b-icon(icon='x')
          b-tabs.policy-tabs(content-class="mt-0")
            template(#tabs-end)
              b-dropdown.actions(text='Actions', variant="default", right)
                template(#button-content)
                  | Actions
                  b-icon.m-l-1(icon="chevron-down" font-scale="1")
                PoliciesModalArchive(:archiveStatus="!policy.archived" @archiveConfirmed="archivePolicy(policy.id, !policy.archived)" :inline="false")
                  b-dropdown-item {{ !policy.archived ? 'Archive' : 'Unarchive' }}
                PoliciesModalDelete(@deleteConfirmed="deletePolicy(policy.id)", :policyId="policy.id",  :inline="false")
                  b-dropdown-item.delete Delete

            b-tab(title="Detail" active)
              .card-body.white-card-body.card-body_full-height.policy-details-card.p-0
                Loading
                .policy-details(v-if="!loading")
                  h3.policy-details__title Policy Details
                  .policy-details__body.mb-0.flex-grow-1
                    .policy-details-section
                      .policy-details__name Name
                      .d-flex
                        div(v-html="policy.title" v-if="currentUserBasic || policy.archived")
                        input.policy-details__input(v-if="!currentUserBasic && !policy.archived" v-model="policy.title" placeholder="Enter policy name")
                      .policy-details__name Description
                      div(v-html="policy.description" v-if="currentUserBasic || policy.archived")
                      Tiptap(v-model="policy.description" v-if="!currentUserBasic && !policy.archived")
            b-tab(title="Risks" lazy)
              .card-body.white-card-body.card-body_full-height.policy-details-card.p-0
                PolicyRisks(:policy="policy" :policyId="policyId" :currentUserBasic="currentUserBasic")
            b-tab(title="Tasks" lazy)
              .card-body.white-card-body.card-body_full-height.policy-details-card.p-0
                PolicyTasks(:policy="policy" :currentUserBasic="currentUserBasic" @saved="updateList")
            b-tab(title="History")
              .card-body.white-card-body.card-body_full-height.policy-details-card.p-0
                HistoryPolicy(:policy="policy")
</template>

<script>
import Tiptap from '@/common/Tiptap'
  import Loading from '@/common/Loading/Loading'
  import nestedDraggable from "../infra/nestedMain";
  import rawdisplayer from "../infra/raw-displayer";
  import { VueEditor } from "vue2-editor";
  import SubsectionPolicy from "./PolicySubsection";
  import HistoryPolicy from "./PolicyHistory";
  import PolicyRisks from "../Risks/PolicyRisks";
  import PolicyTasks from "../Tasks/PolicyTasks";
  import PoliciesModalCreate from "../Modals/PoliciesModalCreate";
  import PoliciesModalDelete from "../Modals/PoliciesModalDelete";
  import PoliciesModalArchive from "../Modals/PoliciesModalArchive";
  import PoliciesModalRemoveSubsection from "../Modals/PoliciesModalRemoveSubsection";
  import PoliciesModalPublish from "../Modals/PoliciesModalPublish";

  export default {
    props: {
      policyId: {
        type: Number,
        required: true
      },
    },
    components: {
      Tiptap,
      Loading,
      nestedDraggable,
      rawdisplayer,
      VueEditor,
      SubsectionPolicy,
      HistoryPolicy,
      PolicyRisks,
      PolicyTasks,
      PoliciesModalCreate,
      PoliciesModalDelete,
      PoliciesModalArchive,
      PoliciesModalRemoveSubsection,
      PoliciesModalPublish
    },
    // created() {
    //   this.$store.commit('changeSidebar', 'builder')
    // },
    data() {
      return {
        leftMenu: true,
        description: 'Enter policy details',
        title: "Section Name",
        sections: [],
        count: 0,
        isDowloading: false,
      }
    },
    methods: {
      statusVariant(str_status) {
        switch(str_status) {
          case 'published':
            return 'success'
            break;
          case 'archived':
            return 'danger'
            break
          case 'draft':
            return 'light'
            break
          default:
            return 'light'
        }
      },
      saveDraft () {
        this.updatePolicy()
      },
      download () {
        this.isDowloading = true
        this.$store
          .dispatch("downloadPolicy", { policyId: this.policyId })
          .then((myBlob) => {
            //console.log('response', myBlob)
            this.toast('Success', 'Policy has been queued for download.')
          })
          .catch((err) => {
            //console.log(err)
            this.isDowloading = false
            this.toast('Error', err.message, true)
          });
      },
      publishPolicy () {
        this.$store
          .dispatch("publishPolicy", { policyId: this.policyId })
          .then(response => {
            //console.log(response)
            this.toast('Success', 'Policy has been published.')
            setTimeout(() => {
              //window.location.href = `${window.location.origin}/business/compliance_policies/${response.id}`
              this.$router.push(`/business/compliance_policies/${response.id}`)
            }, 2000)
          })
          .catch((err) => {
            this.toast('Error', err.message, true)
          });
      },
      updatePolicy() {
        const dataToSend = {
          id: this.policy.id,
          name: this.policy.title,
          description: this.policy.description,
          sections: this.policy.sections,
        };
        //console.log('updatePolicy dataToSend', dataToSend);

        // UPDATE STORE
        this.$store
          .dispatch("updatePolicy", dataToSend)
          .then((response) => {
            if (response.id) {
              this.toast('Success', 'Policy has been updated.')
            } else {
              this.toast('Error', 'Policy has not been updated. Please try again.')
            }
          })
          .catch((error) => {
            //console.log(error)
            this.toast('Error', error, true)
          });
      },
      deletePolicy(policyId) {
        //console.log(`delete ${policyId}`)
        this.$store
          .dispatch('deletePolicyById', { policyId })
          .then(response => {
            this.toast('Success', `Policy successfully deleted!`)
          })
          .catch(error => {
            this.toast('Error', `Couldn't submit form! ${error}`, true)
          })
      },
      closeAndExit () {
        //window.location.href = `${window.location.origin}/business/compliance_policies`
        this.$store.commit('changeSidebar', 'default')
        this.$router.push(`/business/compliance_policies`)
      },
      archivePolicy(policyId, archiveStatus) {
        this.$store
          .dispatch('archivePolicyById', { policyId: this.policyId, archived: archiveStatus })
          .then(response => {
            //console.log('response', response)
            this.toast('Success', `Policy successfully ${archiveStatus ? 'archived' : 'unarchived'}!`)
            this.$router.push(`/business/compliance_policies`)
            this.$store.commit('changeSidebar', 'default')
          })
          .catch(error => {
            console.error(error)
            this.toast('Error', `Couldn't submit form! ${error}`, true)
          })
      },
      deleteAllSections(){
        //console.log(`delete all`)
        this.policy.sections = []

        // this.policiesComputed = {
        //   id: this.policy.id,
        //   children: this.policy.sections,
        // }

        this.updatePolicy()
      },
      addSection(event) {
        if(event) event.target.closest('.policy-details__btn').style.display = 'none';
        const id = Math.floor(Math.random() * 100)

        // this.policy.sections.push({
        //   id: id,
        //   title: `${this.title}-№-${this.count++}-${id}`,
        //   description: this.description,
        //   children: [],
        // })
        this.policiesComputed = {
          id: id,
          title: `${this.title}`,
          description: this.description,
          children: [],
        }
        //console.log('this.policy.sections', this.policy.sections)
      },
      deleteSection(index) {
        this.policy.sections.splice(index, 1)
        if (this.policy.sections.length === 0) document.querySelector('.policy-details__btn').style.display = 'block';
      },
      updateList() {
        this.$store.dispatch("getPolicies")
          .then((response) => {
            //console.log('response 1', response);
            this.policies = response
            // this.policy = response.find(el => el.id === this.policyId)
            //console.log('this.policy in create page', this.policy)
          })
          .catch((err) => {
            // console.error(err);
            this.toast('Error', err.message, true)
          });
      },
      movePolicy(event) {
        const curPos = this.policies[event.oldIndex].position
        const newPos = this.policies[event.newIndex].position

        this.policies[event.newIndex].position = curPos
        this.policies[event.oldIndex].position = newPos

        const arrToChange = [
          {
            id: this.policies[event.newIndex].id,
            position: this.policies[event.newIndex].position
          },
          {
            id: this.policies[event.oldIndex].id,
            position: this.policies[event.oldIndex].position
          }
        ]

        this.$store
          .dispatch("moveUpPolicy", arrToChange)
          .then((response) => {
            //console.log('response', response)
            this.toast('Success', 'Policy succesfully moved.')
          })
          .catch((err) => {
            // console.error(err)
            this.toast('Error', err.message, true)
          });
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      policy(){
        const id = this.policyId
        return this.$store.getters.policyById(id)
      },
      policiesComputed: {
        get() {
          const policies = this.$store.getters.policiesList
          let tmp;
          const newPoliciesList = policies.map(el => {
            tmp = el['name'];
            el['title'] = tmp;
            tmp = el['sections']
            el['children'] = tmp;
            if (!el['sections']) el['sections'] = []
            return el
          });
          return newPoliciesList;
        },
        set(value) {
          //console.log(value)
          this.$store.dispatch("updatePolicySectionsById", {
            id: this.policy.id,
            sections: value
          });
        }
      },
      currentUserBasic() {
        return (window.localStorage["app.currentUser.role"] == "basic")
      },
      policyById() {
        const id = this.policyId
        return this.$store.getters.policyById(id)
      },
      policiesListNested () {
        return this.$store.getters.policiesListNested
      },
    },
    mounted() {
      this.updateList()
    },
    // filters: {
    //   strippedContent: function(string) {
    //     return string.replace(/<\/?[^>]+>/ig, " ");
    //   }
    // }
  };
</script>
