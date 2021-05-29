<template lang="pug">
  div.policy
    .container-fluid
      .row
        .col-12.col-lg-3.px-0(v-if="leftMenu")
          .card-body.white-card-body.left-tree
            PoliciesModalCreate(@saved="updateList")
              button.btn.btn-dark.mb-3.mr-3 New Policy
            .row
              .col-12
                .table
                  nested-draggable(v-model='policiesComputed', :policiesList="policiesListNested" :shortTable="true")
        .col(v-if="policy")
          .row
            .col-md-12.px-0
              .card-body.white-card-body.p-3.px-4
                .d-flex.justify-content-between
                  .d-flex.align-items-center
                    button.btn.btn__menu.mr-3(@click="leftMenu = !leftMenu")
                      b-icon(icon='list')
                    b-badge.btn.btn-default.mr-3(variant="light") none
                    h3.policy__main-title.m-y-0 Entire policies
                  .d-flex.justify-content-end.align-items-center
                    a.link.btn.mr-3(@click="saveDraft") Save Draft
                    button.btn.btn-default.mr-3(@click="download") Download
                    PoliciesModalPublish(@publishConfirmed="publishPolicy")
                      button.btn.btn-dark.mr-3 Publish
                    button.btn.btn__close.mr-3(@click="closeAndExit")
                      b-icon(icon='x')
          .row
            .col-12.px-0
              b-tabs(content-class="mt-0")
                template(#tabs-end)
                  b-dropdown.ml-auto.my-auto.mr-5.actions(text='Actions', variant="default", right)
                    template(#button-content)
                      | Actions
                      b-icon.m-l-1(icon="chevron-down" font-scale="1")
                    // PoliciesModalArchive(:archiveStatus="!policy.archived" @archiveConfirmed="archivePolicy(policy.id, !policy.archived)" :inline="false")
                      b-dropdown-item {{ !policy.archived ? 'Archive' : 'Unarchive' }} Policy
                    // PoliciesModalDelete(v-if="policy.archived" @deleteConfirmed="deletePolicy(policy.id)", :policyId="policy.id",  :inline="false")
                      b-dropdown-item.delete Delete Policy
                b-tab(title="Details" active)
                  .row(v-if="loading", :loading="loading")
                    .col-12
                      .card-body.white-card-body.p-0.position-relative
                        .policy-details
                          .policy-details__body
                            .d-flex.flex-column.justify-content-center.align-items-center.mb-2
                              b-icon(icon="three-dots", animation="cylon", font-scale="4")
                              h5 Loading....
                  .row
                    .col-12
                      .card-body.white-card-body.p-0.position-relative.m-b-2(v-if="policiesList" v-for="policy in policiesList" :key="policy.id")
                        .policy-details
                          // h3.policy-details__title Policy Details
                          .policy-details__body
                            .policy-details-section
                              .policy-details__name Name
                              .d-flex
                                input.policy-details__input(v-model="policy.title")
                              .policy-details__name Description
                              .policy-details__text-editor(@click="toggleVueEditorHandler", v-if="!toggleVueEditor", v-b-tooltip.hover.left title="Click to edit text", v-html="policy.description ? policy.description : description")
                              vue-editor.policy-details__text-editor(v-if="toggleVueEditor", v-model="policy.description", @blur="handleBlur")
                        HistoryPolicy(:policy="policy")
                      // b-tab(title="Risks")
                      //   PolicyRisks(:policyId="policy.id")
                      // b-tab(title="Tasks")
                      //   .policy-details
                      //     h3.policy-details__title Tasks
                      //     .policy-details__body Tasks
</template>

<script>
  import nestedDraggable from "./infra/nestedMain";
  import rawdisplayer from "./infra/raw-displayer";
  import { VueEditor } from "vue2-editor";
  import SubsectionPolicy from "./Details/PolicySubsection";
  import HistoryPolicy from "./Details/PolicyHistory";
  import PolicyRisks from "./Risks/PolicyRisks";
  import PoliciesModalCreate from "./Modals/PoliciesModalCreate";
  import PoliciesModalDelete from "./Modals/PoliciesModalDelete";
  import PoliciesModalArchive from "./Modals/PoliciesModalArchive";
  import PoliciesModalRemoveSubsection from "./Modals/PoliciesModalRemoveSubsection";
  import PoliciesModalPublish from "./Modals/PoliciesModalPublish";

  export default {
    // props: {
    //   policyId: {
    //     type: Number,
    //     required: true
    //   },
    // },
    components: {
      nestedDraggable,
      rawdisplayer,
      VueEditor,
      SubsectionPolicy,
      HistoryPolicy,
      PolicyRisks,
      PoliciesModalCreate,
      PoliciesModalDelete,
      PoliciesModalArchive,
      PoliciesModalRemoveSubsection,
      PoliciesModalPublish
    },
    data() {
      return {
        leftMenu: true,
        description: "",
        title: "Section Name",
        toggleVueEditor: false,
        sections: [],
        count: 0,
        policyId: 155
      }
    },
    methods: {
      saveDraft () {
        this.updatePolicy()
      },
      download () {
        this.$store
          .dispatch("downloadPolicy", { policyId: this.policyId })
          .then((myBlob) => {
            // console.log('response', myBlob)
            this.makeToast('Success', 'Policy succesfully downloaded.')
          })
          .catch((err) => {
            // console.log(err)
            this.makeToast('Error', err.message)
          });
      },
      publishPolicy () {
        this.$store
          .dispatch("publishPolicy", { policyId: this.policyId })
          .then(response => {
            console.log(response)
            this.makeToast('Success', 'Policy succesfully published. Please wait you will be redirected to the new Draft')
            setTimeout(() => {
              window.location.href = `${window.location.origin}/business/compliance_policies/${response.id}`
            }, 2000)
          })
          .catch((err) => {
            this.makeToast('Error', err.message)
          });
      },
      deletePolicy(policyId) {
        console.log(`delete ${policyId}`)
        this.$store
          .dispatch('deletePolicyById', { policyId })
          .then(response => {
            this.makeToast('Success', `Policy successfully deleted!`)
          })
          .catch(error => {
            this.makeToast('Error', `Couldn't submit form! ${error}`)
          })
      },
      closeAndExit () {
        window.location.href = `${window.location.origin}/business/compliance_policies`
      },
      archivePolicy(policyId, archiveStatus) {
        this.$store
          .dispatch('archivePolicyById', { policyId: this.policyId, archived: archiveStatus })
          .then(response => {
            console.log('response', response)
            this.makeToast('Success', `Policy successfully ${archiveStatus ? 'archived' : 'unarchived'}!`)
          })
          .catch(error => {
            console.error(error)
            this.makeToast('Error', `Couldn't submit form! ${error}`)
          })
      },
      deleteAllSections(){
        console.log(`delete all`)
        this.policy.sections = []

        // this.policiesComputed = {
        //   id: this.policy.id,
        //   children: this.policy.sections,
        // }

        this.updatePolicy()
      },

      updatePolicy() {
        const dataToSend = {
          id: this.policy.id,
          name: this.policy.title,
          description: this.policy.description,
          sections: this.policy.sections,
        };
        console.log('updatePolicy dataToSend', dataToSend);

        // UPDATE STORE
        this.$store
          .dispatch("updatePolicy", dataToSend)
          .then((response) => {
            // this.$router.push("/list");
            // console.log("Policy successfull saved!");
            this.makeToast('Success', `Policy successfully updated!`)
            console.log('response updatePolicy', response)
          })
          .catch((error) => {
            console.log(error)
            this.makeToast('Error', error)
          });
      },

      addSection(event) {
        if(event) event.target.closest('.policy-details__btn').style.display = 'none';
        const id = Math.floor(Math.random() * 100)

        this.policiesComputed = {
          id: id,
          title: `${this.title}`,
          description: this.description,
          children: [],
        }
        console.log('this.policy.sections', this.policy.sections)
      },
      deleteSection(index) {
        this.policy.sections.splice(index, 1)
        if (this.policy.sections.length === 0) document.querySelector('.policy-details__btn').style.display = 'block';
      },
      toggleVueEditorHandler() {
        this.toggleVueEditor = !this.toggleVueEditor;
      },
      handleBlur() {
        this.toggleVueEditorHandler()
      },

      updateList() {
        this.$store
          .dispatch("getPolicies")
          .then((response) => {
            // console.log('response 1', response);
            this.policies = response
            // this.policy = response.find(el => el.id === this.policyId)
            // console.log('this.policy in create page', this.policy)
          })
          .catch((err) => {
            // console.error(err);
            this.makeToast('Error', err.message)
          });
      },

      deletePolicy(policyId) {
        this.$store
          .dispatch('deletePolicyById', { policyId })
          .then(response => {
            this.makeToast('Success', `Policy successfully deleted!`)
          })
          .catch(error => {
            this.makeToast('Error', `Couldn't submit form! ${error}`)
          })
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
            console.log('response', response)
            this.makeToast('Success', 'Policy succesfully moved.')
          })
          .catch((err) => {
            // console.error(err)
            this.makeToast('Error', err.message)
          });
      },

      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
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
      policiesList() {
        return this.$store.getters.policiesList;
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
          console.log(value)
          this.$store.dispatch("updatePolicySectionsById", {
            id: this.policy.id,
            sections: value
          });
        }
      },
      policyById() {
        const id = this.policyId
        return this.$store.getters.policyById(id)
      },
      policiesListNested () {
        return this.$store.getters.policiesListNested
      }
    },
    watch: {
      policiesComputed (oldArr, newArr) {
        console.log('watch record', oldArr, newArr)
      },
    },
    mounted() {
      this.updateList ()
    },
  };
</script>
