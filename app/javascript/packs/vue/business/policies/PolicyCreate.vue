<template lang="pug">
  div.policy
    .container-fluid
      .row
        .col-12.col-lg-3.px-0(v-if="leftMenu && policiesComputed.length")
          .card-body.white-card-body
            button.btn.btn-dark.mb-3.mr-3(@click="createPolicy('new')") New Policy
            DragDropComponent(:policies="policiesComputed")
        .col
          .row
            .col-md-12.px-0
              .card-body.white-card-body.p-3.px-4
                .d-flex.justify-content-between
                  .d-flex.align-items-center
                    button.btn.btn__menu.mr-3(@click="leftMenu = !leftMenu")
                      b-icon(icon='list')
                    button.btn.btn-default.mr-3 Draft
                    h3.policy__main-title.m-y-0 {{ title }}
                  .d-flex.justify-content-end.align-items-center
                    a.link.btn.mr-3(@click="saveDraft") Save Draft
                    button.btn.btn.btn-default.mr-3(@click="download") Download
                    button.btn.btn-dark.mr-3(@click="publish") Publish
                    button.btn.btn__close.mr-3
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
                              input.policy-details__input(v-model="title")
                            .policy-details__name Description
                            .policy-details__text-editor(@click="toggleVueEditorHandler", v-if="!toggleVueEditor", v-b-tooltip.hover.left title="Click to edit text") {{ content }}
                            vue-editor.policy-details__text-editor(v-if="toggleVueEditor", v-model="content", @blur="handleBlur")
                            button.policy-details__btn.mr-3.btn.btn-default(@click="addSection")
                              b-icon.mr-2(icon='plus-circle-fill')
                              | Add Section
                          SubsectionPolicy(
                          :section="section"
                          :index="index"
                          v-for="(section, index) in sections"
                          :key="section.id"
                          @addSection="addSection"
                          @deleteSection="deleteSection")
                          <!--component(v-for="subSection in subSections", v-bind:is="subSection.component", :key="subSection.id", :subSection="subSection", :policyID="policyID", @clickedAddSection="addSectionFromChild", @clickedDeleteSection="deleteSection", @clickedSaveIt="onClickSaveSubsection")-->
                      HistoryPolicy
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
</template>

<script>
  import DragDropComponent from "./DragDropComponent";
  import { VueEditor } from "vue2-editor";
  import SubsectionPolicy from "./PolicySubsection";
  import HistoryPolicy from "./PolicyHistory";

  export default {
    props: {
      policy: {
        type: Object,
        required: false,
      },
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
        content: "N/A",
        title: "New Policy",
        toggleVueEditor: false,
        component: "",
        policyID: 0,
        sections: [],
        count: 0,
        ownerId: 13,
      };
    },
    methods: {
      saveDraft () {
        this.updatePolicy()
      },
      download () {

      },
      publish () {

      },

      createPolicy(newPolicy) {
        this.policyID = Math.floor(Math.random() * 100)

        if (newPolicy) {
          this.sections = [];
          document.querySelector('.policy-details__btn').style.display = 'block';
        }
        if (this.title && this.content) {
          const dataToSend = {
            policyID: this.policyID,
            ownerId: this.ownerId,
            title: this.title,
            description: this.content,
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
          policyID: 1,
          ownerId: this.ownerId,
          title: this.title,
          description: this.content,
          sections: this.sections,
        };
        console.log(dataToSend);

        // UPDATE STORE
        this.$store
          .dispatch("updatePolicy", dataToSend)
          .then((response) => {
            // this.$router.push("/list");
            // console.log("Policy successfull saved!");
            // console.log('response', response)
          })
          .catch((err) => {
            console.log(err)
          });
      },

      addSection(event) {
        if(event) event.target.closest('.policy-details__btn').style.display = 'none';
        const id = Math.floor(Math.random() * 100)

        this.sections.push({
          id: this.count++,
          title: `${this.title}-№-${this.count}-${id}`,
          description: this.content,
          children: [],
        })
      },
      deleteSection(index) {
        this.sections.splice(index, 1)
        if (this.sections.length === 0) document.querySelector('.policy-details__btn').style.display = 'block';
      },
      toggleVueEditorHandler() {
        this.toggleVueEditor = !this.toggleVueEditor;
      },
      handleBlur() {
        this.toggleVueEditorHandler()
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      policiesComputed() {
        const policies = this.$store.getters.policies
        let tmp
        const newPolicies = policies.map(el => {
          tmp = el['sections']
          el['children'] = tmp;
          return el
        });
        return newPolicies;
      }
    },
    watch: {
      // policiesComputed (oldVal, newVal) {
      //   console.log('oldVal', oldVal)
      //   console.log('newVal', newVal)
      // }
    },
    mounted() {
      // this.createPolicy();
      /*
      this.$store.dispatch('getPolicies', {})
        .then((response) => {
          console.log('response getPolicies', response)
        })
        .catch((err) => {
          console.log(err)
        });
        */
    },
  };
</script>
