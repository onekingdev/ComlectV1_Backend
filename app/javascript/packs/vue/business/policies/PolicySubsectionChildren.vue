<template lang="pug">
    div
        .policy-details-subsection
            .policy-details__name.mb-0 Sub Section Child Name
            .d-flex.align-items-center
                b-icon.mr-2(icon='chevron-compact-right')
                input.policy-details__input.mb-0(:value="subSectionChildName")
                .actions
                    button.policy-details__btn.mr-3.btn.btn-default
                        b-icon.mr-2(icon='plus-circle-fill')
                        | Add Subsection
                    button.px-0.actions__btn(@click="isActive = !isActive", :class="{ active: isActive }")
                        b-icon(icon="three-dots")
                        ul.actions-dropdown(:class="{ active: isActive }")
                            li.actions-dropdown__item.save(@click="saveSubSectionChild") Save it
                            li.actions-dropdown__item.move-up Move up
                            li.actions-dropdown__item.delete Delete
            .policy-details__name.mb-0 Description
            .policy-details__text-editor(@click="toggleVueEditorHandler", v-if="!toggleVueEditor") {{ content }}
            vue-editor.policy-details__text-editor(v-if="toggleVueEditor", v-model="content")
            component(v-for="subSection in subSections", v-bind:is="subSection.component", :key="subSection.id", :subSection="subSection", @clicked="onClickButton", @clickedSaveIt="onClickSaveSubsection")
        button.policy-details__btn.mr-3.btn.btn-default(@click="addSection") Add Section
</template>

<script>
    import { VueEditor } from "vue2-editor";
    import PolicySubsection from "./PolicySubsection";

    export default {
        props: {
            subSectionChild: {
                type: Object,
                required: false,
            },
            subSectionsID: {
                type: Number,
                required: true,
            }
        },
        components: {
            VueEditor,
        },
        data() {
            return {
                content: "N/A",
                title: "New Policy",
                toggleVueEditor: false,
                isActive: false,
                subSections: [],
                count: 0,
                parentSection: 0,
            }
        },
        computed: {
            subSectionChildName () {
                return `Sub Section Child Name New Policy ${this.subSectionID}`
            }
        },
        methods: {
            toggleVueEditorHandler() {
                this.content = "";
                this.toggleVueEditor = !this.toggleVueEditor;
            },
            addSection (event) {
                if(event) event.target.style.display = 'none';
                this.subSections.push({
                    component: PolicySubsection,
                    id: this.count++
                })
            },
            onClickButton (event) {
                console.log(event)
                this.$emit('clicked', 'someValue')
                this.addSection()
            },
            onClickSaveSubsection(event){
                console.log(event)
            },
            saveSubSectionChild () {
                const datasubSectionChildToSend = {
                    id: this.count++,
                    parentSectionID: this.subSectionID,
                    title: this.subSectionChildName,
                    description: this.content,
                    children: [],
                };
                console.log(datasubSectionChildToSend);

                this.$emit('clickedSaveIt', datasubSectionChildToSend)

                // Save data to current Policy
                this.$store
                    .dispatch("createSectionChild", datasubSectionChildToSend)
                    .then(() => {
                        // this.$router.push("/list");
                        console.log("Sub Section Children successfully saved!");
                    })
                    .catch((err) => {
                        console.log(err);
                    });
            }
        },
    };
</script>