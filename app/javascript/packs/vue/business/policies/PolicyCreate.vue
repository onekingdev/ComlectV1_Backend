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
                  nested-draggable(:policies='policiesComputed' @movePolicy="movePolicy")
            <!--rawdisplayer(:value='policiesComputed' title='List')-->
        .col
          .row
            .col-md-12.px-0
              .card-body.white-card-body.p-3.px-4
                .d-flex.justify-content-between
                  .d-flex.align-items-center
                    button.btn.btn__menu.mr-3(@click="leftMenu = !leftMenu")
                      b-icon(icon='list')
                    button.btn.mr-3(:class="policy.status === 'published' ? 'btn-success' : 'btn-default'") {{ policy.status }}
                    h3.policy__main-title.m-y-0 {{ policy.title }}
                  .d-flex.justify-content-end.align-items-center
                    a.link.btn.mr-3(@click="saveDraft") Save Draft
                    button.btn.btn.btn-default.mr-3(@click="download") Download
                    button.btn.btn-dark.mr-3(@click="publish") Publish
                    PoliciesModalDelete(:policyId="policy.id", @deleteConfirmed="deletePolicy(policy.id)")
                      button.btn.btn__close.mr-3
                        b-icon(icon='x')
          .row
            .col-12.px-0
              b-tabs(content-class="mt-0")
                .policy-actions
                  b-dropdown.bg-white(text='Actions', variant="secondary", right)
                    b-dropdown-item
                      PoliciesModalArchive(@archiveConfirmed="archivePolicy") Archive Policy
                    b-dropdown-item
                      PoliciesModalRemoveSubsection(@removeSubsectionConfirmed="deleteAllSections") Delete sections
                    <!--b-dropdown-item Save all-->
                .col-12.px-lg-5.px-md-3
                  .card-body.white-card-body.p-0.position-relative
                    b-tab(title="Details" active)
                      .policy-details(v-if="loading", :loading="loading")
                        .policy-details__body
                          .d-flex.flex-column.justify-content-center.align-items-center.mb-2
                            b-icon(icon="three-dots", animation="cylon", font-scale="4")
                            h5 Loading....
                      .policy-details
                        h3.policy-details__title Policy Details
                        .policy-details__body
                          .policy-details-section
                            .policy-details__name Name
                            .d-flex
                              input.policy-details__input(v-model="policy.title")
                            .policy-details__name Description
                            .policy-details__text-editor(@click="toggleVueEditorHandler", v-if="!toggleVueEditor", v-b-tooltip.hover.left title="Click to edit text", v-html="policy.description ? policy.description : description")
                            vue-editor.policy-details__text-editor(v-if="toggleVueEditor", v-model="policy.description", @blur="handleBlur")
                            button.policy-details__btn.mr-3.btn.btn-default(v-if="policy.sections.length === 0" @click="addSection")
                              b-icon.mr-2(icon='plus-circle-fill')
                              | Add Section
                          SubsectionPolicy(
                          v-if="policy.sections"
                          :section="section"
                          :index="index"
                          :length = "policy.sections ? policy.sections.length : 0"
                          v-for="(section, index) in policy.sections"
                          :key="section.id"
                          @addSection="addSection"
                          @deleteSection="deleteSection")
                          <!--component(v-for="subSection in subSections", v-bind:is="subSection.component", :key="subSection.id", :subSection="subSection", :policyID="policyID", @clickedAddSection="addSectionFromChild", @clickedDeleteSection="deleteSection", @clickedSaveIt="onClickSaveSubsection")-->
                      HistoryPolicy(:policy="policy")
                    b-tab(title="Risks")
                      .policy-details
                        h3.policy-details__title Risks
                        .policy-details__body Risks
                    b-tab(title="Tasks")
                      .policy-details
                        h3.policy-details__title Tasks
                        .policy-details__body Tasks
                    b-tab(title="Activity")
                      .policy-details
                        h3.policy-details__title Activity
                        .policy-details__body Activity
            <!--.col-12-->
              <!--pre {{ policy }}-->
</template>

<script>
  import nestedDraggable from "./infra/nested";
  import rawdisplayer from "./infra/raw-displayer";
  import { VueEditor } from "vue2-editor";
  import SubsectionPolicy from "./PolicySubsection";
  import HistoryPolicy from "./PolicyHistory";
  import PoliciesModalCreate from "./Modals/PoliciesModalCreate";
  import PoliciesModalDelete from "./Modals/PoliciesModalDelete";
  import PoliciesModalArchive from "./Modals/PoliciesModalArchive";
  import PoliciesModalRemoveSubsection from "./Modals/PoliciesModalRemoveSubsection";

  export default {
    props: {
      policyId: {
        type: Number,
        required: true
      },
      // policy: {
      //   type: Object,
      //   required: false,
      // },
    },
    components: {
      nestedDraggable,
      rawdisplayer,
      VueEditor,
      SubsectionPolicy,
      HistoryPolicy,
      PoliciesModalCreate,
      PoliciesModalDelete,
      PoliciesModalArchive,
      PoliciesModalRemoveSubsection,
    },
    data() {
      return {
        leftMenu: true,
        description: "N/A",
        title: "New Policy Subtitle",
        toggleVueEditor: false,
        sections: [],
        count: 0,
        policy: {
          "id": this.policyId,
          "title": "New Policy",
          "created_at": "",
          "updated_at": "",
          "position": 0,
          "description": "N/A",
          "src_id": null,
          "status": "draft",
          "sections": [],
          "versions": []
        }
      }
    },
    methods: {
      saveDraft () {
        this.updatePolicy()
      },
      download () {
        this.$store
          .dispatch("downloadPolicy", { policyId: this.policyId })
          .then((response) => {
            console.log('response', response)
            this.makeToast('Success', 'Policy succesfully downloaded.')
          })
          .catch((err) => {
            console.log(err)
            this.makeToast('Error', err.message)
          });
      },
      publish () {
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
      archivePolicy() {
        console.log(`archive ${this.policyId}`)
        this.$store
          .dispatch('archivePolicyById', { policyId: this.policyId, archived: true })
          .then(response => {
            this.makeToast('Success', `Policy successfully archived!`)
          })
          .catch(error => {
            this.makeToast('Error', `Couldn't submit form! ${error}`)
          })
      },
      deleteAllSections(){
        console.log(`delete all`)
        this.policy.sections = []
      },

      // createPolicy(newPolicy) {
      //   // this.policyID = Math.floor(Math.random() * 100)
      //
      //   if (newPolicy) {
      //     this.sections = [];
      //     document.querySelector('.policy-details__btn').style.display = 'block';
      //   }
      //   if (this.name && this.description) {
      //     const dataToSend = {
      //       policyId: this.policyId,
      //       ownerId: this.ownerId,
      //       name: this.name,
      //       description: this.description,
      //       sections: this.sections,
      //     };
      //     console.log(dataToSend);
      //
      //     // SAVE DATA TO STORE
      //     this.$store
      //       .dispatch("createPolicy", dataToSend)
      //       .then((response) => {
      //         // this.$router.push("/list");
      //         // console.log("Policy successfull saved!");
      //         // console.log('response', response)
      //       })
      //       .catch((err) => {
      //         // console.log(err)
      //       });
      //   }
      // },
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
            console.log('response', response)
          })
          .catch((error) => {
            console.log(error)
            this.makeToast('Error', error)
          });
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
          title: `${this.title}-№-${this.count++}-${id}`,
          description: this.description,
          children: [],
        }
        console.log('this.policy.sections')
        console.log(this.policy.sections)
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

      updateList () {
        this.$store
          .dispatch("getPolicies")
          .then((response) => {
            // console.log('response 1', response);
            this.policies = response
            this.policy = response.find(el => el.id === this.policyId)
            console.log(this.policy)
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
      // policiesComputed() {
      //   const policies = this.$store.getters.policiesList
      //   let tmp;
      //   const newPoliciesList = policies.map(el => {
      //     tmp = el['name'];
      //     el['title'] = tmp;
      //     tmp = el['sections']
      //     el['children'] = tmp;
      //     if (!el['sections']) el['sections'] = []
      //     return el
      //   });
      //   return newPoliciesList;
      // },
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
      }
    },
    watch: {
      policiesComputed (oldArr, newArr) {
        console.log('record', oldArr, newArr)
      }
    },
    mounted() {
      this.updateList ()
      // this.$store
      //   .dispatch("getPolicyById", { policyId: this.policyId })
      //   .then((response) => {
      //     this.policy = response;
      //     console.log('response', response);
      //   })
      //   .catch((err) => {
      //     console.error(err);
      //     this.makeToast('Error', err.message)
      //   });
    },
  };
</script>
