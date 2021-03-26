<template lang="pug">
  div.policy
    .container-fluid
      .row
        .col-12.col-lg-3.px-0(v-if="leftMenu")
          .card-body.white-card-body.left-tree
            button.btn.btn-dark.mb-3.mr-3(@click="createPolicy('new')") New Policy
            DragDropComponent(:policy="policy")
        .col
          .row
            .col-md-12.px-0
              .card-body.white-card-body.p-3.px-4
                .d-flex.justify-content-between
                  .d-flex.align-items-center
                    button.btn.btn__menu.mr-3(@click="leftMenu = !leftMenu")
                      b-icon(icon='list')
                    button.btn.btn-default.mr-3 {{ policy.status }}
                    h3.policy__main-title.m-y-0 {{ policy.name }}
                  .d-flex.justify-content-end.align-items-center
                    a.link.btn.mr-3(@click="saveDraft") Save Draft
                    button.btn.btn.btn-default.mr-3(@click="download") Download
                    button.btn.btn-dark.mr-3(@click="publish") Publish
                    button.btn.btn__close.mr-3(@click="deletePolicy")
                      b-icon(icon='x')
          .row
            .col-12.px-0
              b-tabs(content-class="mt-0")
                .policy-actions
                  b-dropdown.bg-white(text='Actions', variant="secondary", right)
                    b-dropdown-item Delete all
                    b-dropdown-item Save all
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
                              input.policy-details__input(v-model="policy.name")
                            .policy-details__name Description
                            .policy-details__text-editor(@click="toggleVueEditorHandler", v-if="!toggleVueEditor", v-b-tooltip.hover.left title="Click to edit text", v-html="policy.description")
                            vue-editor.policy-details__text-editor(v-if="toggleVueEditor", v-model="policy.description", @blur="handleBlur")
                            button.policy-details__btn.mr-3.btn.btn-default(v-if="policy.sections.length === 0" @click="addSection")
                              b-icon.mr-2(icon='plus-circle-fill')
                              | Add Section
                          SubsectionPolicy(
                          :section="section"
                          :index="index"
                          :length = "policy.sections.length"
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
            .col-12
              pre {{ policy }}
</template>

<script>
  import DragDropComponent from "./DragDropComponent";
  import { VueEditor } from "vue2-editor";
  import SubsectionPolicy from "./PolicySubsection";
  import HistoryPolicy from "./PolicyHistory";

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
      DragDropComponent,
      VueEditor,
      SubsectionPolicy,
      HistoryPolicy,
    },
    data() {
      return {
        leftMenu: true,
        description: "N/A",
        title: "New Policy",
        toggleVueEditor: false,
        component: "",
        // policyID: 0,
        sections: [],
        count: 0,
        ownerId: 13,
        policy: {
          "id": this.policyId,
          "name": "New Policy",
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
            this.makeToast('Success', 'Policy succesfully published.')
          })
          .catch((err) => {
            this.makeToast('Error', err.message)
          });
      },
      deletePolicy() {
        console.log(`delete${this.policyId}`)
      },

      createPolicy(newPolicy) {
        // this.policyID = Math.floor(Math.random() * 100)

        if (newPolicy) {
          this.sections = [];
          document.querySelector('.policy-details__btn').style.display = 'block';
        }
        if (this.title && this.description) {
          const dataToSend = {
            policyID: this.policyId,
            ownerId: this.ownerId,
            title: this.title,
            description: this.description,
            sections: this.sections,
          };
          console.log(dataToSend);

          // SAVE DATA TO STORE
          this.$store
            .dispatch("createPolicy", dataToSend)
            .then((response) => {
              // this.$router.push("/list");
              // console.log("Policy successfull saved!");
              // console.log('response', response)
            })
            .catch((err) => {
              // console.log(err)
            });
        }
      },
      updatePolicy() {
        const dataToSend = {
          policyID: this.policy.id,
          ownerId: this.ownerId,
          title: this.policy.title,
          description: this.policy.description,
          sections: this.policy.sections,
        };
        console.log('updatePolicy dataToSend');
        console.log(dataToSend);

        // UPDATE STORE
        this.$store
          .dispatch("updatePolicy", dataToSend)
          .then((response) => {
            // this.$router.push("/list");
            // console.log("Policy successfull saved!");
            // console.log('response', response)
          })
          .catch((error) => {
            console.log(error)
            this.makeToast('Error', error)
          });
      },

      addSection(event) {
        if(event) event.target.closest('.policy-details__btn').style.display = 'none';
        const id = Math.floor(Math.random() * 100)

        this.policy.sections.push({
          id: id,
          title: `${this.title}-№-${this.count++}-${id}`,
          description: this.description,
          children: [],
        })
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

      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      // policiesComputed() {
      //   const policies = this.$store.getters.policies
      //   console.log('policies', policies)
      //   let tmp
      //   const newPolicies = policies.map(el => {
      //     tmp = el['sections']
      //     el['children'] = tmp;
      //     return el
      //   });
      //   console.log('newPolicies', newPolicies)
      //   return newPolicies;
      // }
    },
    watch: {
      // policiesComputed (oldVal, newVal) {
      //   console.log('oldVal', oldVal)
      //   console.log('newVal', newVal)
      // }
    },
    mounted() {
      this.$store
        .dispatch("getPolicyById", { policyId: this.policyId })
        .then((response) => {
          this.policy = response;
          console.log('response', response);
        })
        .catch((err) => {
          console.error(err);
          this.makeToast('Error', err.message)
        });
    },
  };
</script>
