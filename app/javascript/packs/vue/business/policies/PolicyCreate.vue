<template lang="pug">
    div.policy
        .container-fluid
            .row
                .col-12.col-lg-3.px-0(v-if="leftMenu && policiesComputed.length")
                    .card-body.white-card-body
                        button.btn.btn-dark.mb-3.mr-3 New Policy
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
                                        a.link.btn.mr-3(@click="saveContent") Save Draft
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
                                                    .policy-details-section
                                                        .policy-details__name Name
                                                        .d-flex
                                                            input.policy-details__input(v-model="title")
                                                        .policy-details__name Description
                                                        .policy-details__text-editor(@click="toggleVueEditorHandler", v-if="!toggleVueEditor") {{ content }}
                                                        vue-editor.policy-details__text-editor(v-if="toggleVueEditor", v-model="content")
                                                        button.policy-details__btn.mr-3.btn.btn-default(v-if="subSections.length === 0", @click="addSection")
                                                            b-icon.mr-2(icon='plus-circle-fill')
                                                            | Add Section
                                                    component(v-for="subSection in subSections", v-bind:is="subSection.component", :key="subSection.id", :subSection="subSection", :policyID="policyID", @clickedAddSection="addSectionFromChild", @clickedDeleteSection="deleteSection", @clickedSaveIt="onClickSaveSubsection")
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
            subSections: [],
            count: 0,
            policyID: Math.floor(Math.random() * 100),
            ownerId: 13,
        };
    },
    computed: {
        loading() {
            return this.$store.getters.loading;
        },
        policiesComputed() {
            return this.$store.getters.policies;
        }
    },
    methods: {
        saveContent: function() {
            // You have the content to save
            console.log(this.content);
            // this.toggleVueEditor = !this.toggleVueEditor;

            this.createPolicy();
            //   this.content = this.content.replace(/<[^>]*>?/gm, "");
        },
        toggleVueEditorHandler() {
            this.content = "";
            this.toggleVueEditor = !this.toggleVueEditor;
        },
        addSection(event){
            // if(event) event.target.style.display = 'none';
            this.subSections.push({
                component: SubsectionPolicy,
                id: this.count++
            })
        },
        addSectionFromChild (event) {
            this.$emit('clicked', event)
            this.addSection()
        },
        deleteSection(subSectionID) {
            console.log(subSectionID)
            this.subSections.splice(this.index, 1)
        },
        onClickSaveSubsection(event){
            console.log('From parent Component', event)
        },
        createPolicy() {
            if (this.title && this.content) {
                const dataToSend = {
                    id: this.policyID,
                    ownerId: this.ownerId,
                    title: this.title,
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
                console.log(dataToSend);

                // Save data to store
                this.$store
                    .dispatch("createPolicy", dataToSend)
                    .then((response) => {
                        // this.$router.push("/list");
                        // console.log("Policy successfull saved!");
                        console.log(response)
                    })
                    .catch((err) => {
                        console.log(err);
                    });
            }
        },
    },
    mounted() {
        this.createPolicy();
    }
};
</script>
