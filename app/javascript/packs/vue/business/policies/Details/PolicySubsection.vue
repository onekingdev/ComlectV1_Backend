<template lang="pug">
  div
    .policy-details-subsection(:data-section-id="index")
      .policy-details__name.mb-0 Subsection Name
      .d-flex.align-items-center
        b-icon.mr-2(v-if="section.children && section.children.length > 0" icon="chevron-compact-down")
        b-icon.mr-2(v-else icon="chevron-compact-right")
        input.policy-details__input.mb-0(v-model="section.title", @blur="handleBlur")
        .actions
          button.policy-details__btn.mr-3.btn.btn-default(v-if="section.children.length === 0", @click="addSubSection")
            b-icon.mr-2(icon='plus-circle-fill')
            | Add Subsection
          button.px-0.actions__btn(@click="isActive = !isActive", :class="{ active: isActive }")
            b-icon(icon="three-dots")
            ul.actions-dropdown(:class="{ active: isActive }")
              <!--li.actions-dropdown__item.save(@click="saveSubsection") Save it-->
              li.actions-dropdown__item.move-up(@click="moveUpSubsection(section)") Move up
              PoliciesModalRemoveSubsection(@removeSubsectionConfirmed="deleteSubSection")
                li.actions-dropdown__item.delete Delete
      .policy-details__name.mb-0 Description
      .policy-details__text-editor(@click="toggleVueEditorHandler", v-if="!toggleVueEditor", v-b-tooltip.hover.left title="Click to edit text", v-html="section.description ? section.description : description")
      vue-editor.policy-details__text-editor(v-if="toggleVueEditor", v-model="section.description", @blur="handleBlur")
      div(v-if="section.children && section.children.length > 0")
        PolicySubsection(
        v-for="(child, subIndex) in section.children"
        v-bind:section="child"
        :index="subIndex"
        :key="child.id"
        :parentSection="section"
        :length = "section.children.length"
        @addSection="addSection"
        @deleteSubSection="deleteSubSection")
      <!--component(v-for="subSectionChild in subSectionsChildrens", v-bind:is="subSectionChild.component", :key="subSectionChild.id", :subSectionChild="subSectionChild", :subSectionsID="subSectionsID" @clicked="onClickButton", @clickedSaveIt="onClickSaveSubsection")-->
    button.policy-details__btn.mr-3.btn.btn-default(v-if="index + 1 === length",  @click="addSection") Add Section
</template>

<script>
  import { VueEditor } from "vue2-editor";
  import PoliciesModalRemoveSubsection from "../Modals/PoliciesModalRemoveSubsection"

  export default {
    name: 'PolicySubsection',
    props: {
      length: {
        type: Number,
        required: false,
      },
      section: {
        type: Object,
        required: true,
      },
      index: {
        type: Number,
        required: true
      },
      parentSection: {
        required: false
      }
    },
    components: {
      VueEditor,
      PoliciesModalRemoveSubsection,
    },
    data() {
      return {
        description: "N/A",
        title: "New section name",
        toggleVueEditor: false,
        isActive: false,
        count: 0,
      }
    },
    computed: {

    },
    methods: {
      deleteSubSection() {
        if (!this.parentSection) {
          this.deleteSection()
          return
        }
        this.parentSection.children.splice(this.index, 1)
      },
      deleteSection() {
        this.$emit('deleteSection', this.index)
      },
      addSection(event) {
        if (!this.parentSection) {
          this.$emit('addSection', event)
          return
        }

        if (typeof this.parentSection.children !== 'undefined') {
          if(event) event.target.style.display = 'none';
          const id = Math.floor(Math.random() * 100)

          this.parentSection.children.push({
            id: id,
            title: `${this.title}-№-${this.count}-${id}`,
            description: this.description,
            children: [],
          })
        }
      },
      addSubSection(event) {
        if(event) event.target.closest('.policy-details__btn').style.display = 'none';
        const id = Math.floor(Math.random() * 100)

        this.section.children.push({
          // component: SubsectionPolicy,
          id: this.count++,
          title: `${this.title}-№-${this.count++}-${id}`,
          description: this.description,
          children: [],
        })
      },

      toggleVueEditorHandler() {
        this.toggleVueEditor = !this.toggleVueEditor;
      },
      handleBlur(e) {
        console.log(e)
        if (e?.target?.nodeName !== "INPUT")
          this.toggleVueEditorHandler()

        if (this.parentSection) {
          this.parentSection.children[this.index] = {
            title: this.section.title,
            description: this.section.description,
            children: this.section.children
          }
          console.log(this.parentSection.children)
        }
      },
      moveUpSubsection (section) {
        console.log('moveUpSubsection')
        console.log(section)
        if(!section) return

        const index = this.parentSection.children.findIndex(sec => sec.title === section.title)
        const prevSections = this.parentSection.children[index - 1]
        if (prevSections) {
          this.parentSection.children[index - 1] = {
            title: this.section.title,
            description: this.section.description,
            children: this.section.children
          }
          this.parentSection.children[index] = prevSections

          const newArr = this.parentSection.children
          this.parentSection.children = newArr

          // const newArr = this.parentSection.children.map(record => {
          //   if (record.title === payload.title) {
          //     return section
          //   } else {
          //     return record
          //   }
          // })
          // this.parentSection.children = newArr
        }
        // this.$emit('clickedmoveUpSection', 'someValue')
      },

      // saveSubsection () {
      //   // SAVE DATA TO POLICY
      //   this.$store
      //     .dispatch("createSection", this.section)
      //     .then((response) => {
      //       // this.$router.push("/list");
      //       // console.log("Section is successfull saved!");
      //       console.log('response', response)
      //     })
      //     .catch((error) => {
      //       console.log('from PolicySubSection');
      //       console.error(error);
      //     });
      // }
    },
  };
</script>
