<template lang="pug">
    div
        .policy-details-subsection
            .policy-details__name.mb-0 Subsection Name
            .d-flex.align-items-center
                b-icon.mr-2(icon='chevron-compact-right')
                input.policy-details__input.mb-0(:value="subSectionName")
                .actions
                    button.policy-details__btn.mr-3.btn.btn-default(@click="addSectionChild")
                        b-icon.mr-2(icon='plus-circle-fill')
                        | Add Subsection
                    button.px-0.actions__btn(@click="isActive = !isActive", :class="{ active: isActive }")
                        b-icon(icon="three-dots")
                        ul.actions-dropdown(:class="{ active: isActive }")
                            li.actions-dropdown__item.save(@click="saveSubsection") Save it
                            li.actions-dropdown__item.move-up(@click="moveUpSubsection") Move up
                            li.actions-dropdown__item.delete(@click="deleteSubsection") Delete
            .policy-details__name.mb-0 Description
            .policy-details__text-editor(@click="toggleVueEditorHandler", v-if="!toggleVueEditor") {{ content }}
            vue-editor.policy-details__text-editor(v-if="toggleVueEditor", v-model="content")
            component(v-for="subSectionChild in subSectionsChildrens", v-bind:is="subSectionChild.component", :key="subSectionChild.id", :subSectionChild="subSectionChild", :subSectionsID="subSectionsID" @clicked="onClickButton", @clickedSaveIt="onClickSaveSubsection")
        button.policy-details__btn.mr-3.btn.btn-default(@click="addSection") Add Section
</template>

<script>
import { VueEditor } from "vue2-editor";
import PolicySubsectionChildren from "./PolicySubsectionChildren";

export default {
    name: 'PolicySubsection',
    props: {
        subSection: {
            type: Object,
            required: false,
        },
        policyID: {
            type: Number,
            required: false,
        },
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
            subSectionID: Math.floor(Math.random() * 100),
            subSectionsChildrens: [],
            count: 0,
        }
    },
    computed: {
        subSectionName () {
            return `Subsection Name New Policy ${this.subSection.id}`
        }
    },
    methods: {
        toggleVueEditorHandler() {
            if (!this.content) {
                this.content = "";
                this.toggleVueEditor = !this.toggleVueEditor;
            }
        },
        addSection (event) {
            if(event) event.target.style.display = 'none';
            this.$emit('clickedAddSection', 'someValue')
        },
        addSectionChild (event) {
            if(event) event.target.style.display = 'none';
            this.subSectionsChildrens.push({
                component: PolicySubsectionChildren,
                id: this.count++,
                subSectionsID: this.subSectionID,
            })
        },
        moveUpSubsection () {
            console.log('moveUpSubsection')
            this.$emit('clickedmoveUpSection', 'someValue')
        },
        deleteSubsection () {
            console.log('deleteSubsection')
            this.$emit('clickedDeleteSection', this.subSectionID)
        },
        onClickButton (event) {
            console.log(event)
            this.$emit('clicked', 'someValue')
            this.addSection()
        },
        onClickSaveSubsection(event){
            console.log(event)
        },
        saveSubsection () {
            const dataSubsectionToSend = {
                id: this.count,
                policyID: this.policyID,
                subSectionsID: Math.floor(Math.random() * 100),
                title: this.subSectionName,
                description: this.content,
                children: [],
            };
            console.log(dataSubsectionToSend);

            this.$emit('clickedSaveIt', dataSubsectionToSend)

            // SAVE DATA TO POLICY
            this.$store
                .dispatch("createSection", dataSubsectionToSend)
                .then(() => {
                    // this.$router.push("/list");
                    console.log("Section is successfull saved!");
                })
                .catch((err) => {
                    console.log(err);
                });
        }
    },
};
</script>
