<template lang="pug">
    div.policy
        .container-fluid
            .row
                .col-12.col-lg-3.px-0(v-if="leftMenu")
                    .card-body.white-card-body
                        button.btn.btn-dark.mb-3.mr-3 New Policy
                        .table
                            .table__row(v-for="(policy, i) in 12" :key="i")
                                .table__cell.table__cell_name policy {{ policy + i }}
                        //- DragDropComponent
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
                                        a.link.btn.mr-3 Save Draft
                                        button.btn.btn.btn-default.mr-3 Download
                                        button.btn.btn-dark.mr-3(@click="saveContent") Publish
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
                                                    .policy-details__name Name
                                                    .d-flex
                                                        input.policy-details__input(v-model="title")
                                                    .policy-details__name Description
                                                    .policy-details__text-editor(@click="toggleVueEditorHandler", v-if="!toggleVueEditor") {{ content }}
                                                    vue-editor.policy-details__text-editor(v-if="toggleVueEditor", v-model="content")
                                                    button.policy-details__btn.mr-3.btn.btn-default
                                                        b-icon.mr-2(icon='plus-circle-fill')
                                                        | Add Section
                                                SubsectionPolicy
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
// import DragDropComponent from "./DragDropComponent";
import { VueEditor } from "vue2-editor";
import { SubsectionPolicy } from "./PolicySubsection";
import { HistoryPolicy } from "./PolicyHistory";

export default {
  props: {
    policy: {
      type: Object,
      required: false,
    },
  },
  components: {
    // DragDropComponent,
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
    };
  },
  computed: {
    loading() {
      return this.$store.getters.loading;
    },
  },
  methods: {
    saveContent: function() {
      // You have the content to save
      console.log(this.content);
      this.toggleVueEditor = !this.toggleVueEditor;

      this.createPolicy();
      //   this.content = this.content.replace(/<[^>]*>?/gm, "");
    },
    toggleVueEditorHandler() {
      this.content = "";
      this.toggleVueEditor = !this.toggleVueEditor;
    },

    createPolicy() {
      if (this.title && this.content) {
        const dataToSend = {
          name: this.title,
          description: this.content,
          sections: [
            {
              title: "Section 1",
              desc: "section 1 desc",
              children: [
                {
                  title: "Section 1 child 1",
                  desc: "section 1 child 1 desc",
                  children: [
                    {
                      title: "Section 1 child 1-1",
                      desc: "Section 1 child 1-1 desc",
                      children: [],
                    },
                  ],
                },
              ],
            },
            {
              title: "Section 2",
              desc: "section 2 desc",
              children: [],
            },
          ],
        };

        this.$store
          .dispatch("createPolicy", dataToSend)
          .then(() => {
            // this.$router.push("/list");
            console.log("success");
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },
  },
};
</script>

<style>
/* ---------- Policy Tabs ---------- */
.policy .nav-tabs {
  margin-bottom: 2rem;
  background-color: white;
  border-top: 1px solid #dee2e6;
}
.policy .nav-tabs .nav-item .nav-link,
.policy .nav-tabs .nav-item .nav-link.active {
  padding-top: 1rem;
  padding-bottom: 1rem;
  font-weight: 600;
}

.policy__main-title {
  max-width: 70%;
  text-overflow: ellipsis;
}

.policy .tab-pane {
  margin-bottom: 2rem;
  border: solid 1px #dee2e6;
  border-radius: 3px;
}

/* ---------- Policy Details ---------- */
.policy-actions {
  position: absolute;
  top: 0.7rem;
  right: 3rem;
}

.policy-details {
  margin-bottom: 0;
}
.policy-details__title {
  padding: 2rem 2.5rem;
  border-bottom: solid 1px #e9ebee;
}
.policy-details__title_no-border {
  border: none;
}
.policy-details__body {
  padding: 2rem 2.5rem;
  border-bottom: solid 1px #e9ebee;
}
.policy-details__body_border {
  border: solid 1px #e9ebee;
  border-radius: 5px;
}
.policy-details__name,
.policy-details__input,
.policy-details__text-editor {
  margin-bottom: 1rem;
}
.policy-details__name {
  color: #919396;
}
.policy-details__input {
}

/* ---------- Policy History ---------- */
.policy-history {
}
.policy-history__version {
  border: solid 1px blue;
}
.policy-history__version-info {
}
.policy-history__author {
}
.policy-history__date {
}
.test {
}
</style>

<style lang="scss">
@import "./style.scss";
</style>
