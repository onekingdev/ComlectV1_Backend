<template lang="pug">
  div
    .policy-details-subsection
      .policy-details__name.mb-0 Subsection Name
      .d-flex.align-items-center
        b-icon.mr-2(v-if="section.children && section.children.length > 0" icon="chevron-compact-down")
        b-icon.mr-2(v-else icon="chevron-compact-right")
        input.policy-details__input.mb-0(:value="section.title")
        .actions
          button.policy-details__btn.mr-3.btn.btn-default(@click="addSubSection")
            b-icon.mr-2(icon='plus-circle-fill')
            | Add Subsection
          button.px-0.actions__btn(@click="isActive = !isActive", :class="{ active: isActive }")
            b-icon(icon="three-dots")
            ul.actions-dropdown(:class="{ active: isActive }")
              <!--li.actions-dropdown__item.save(@click="saveSubsection") Save it-->
              li.actions-dropdown__item.move-up(@click="moveUpSubsection") Move up
              li.actions-dropdown__item.delete(@click="deleteSubSection") Delete
      .policy-details__name.mb-0 Description
      .policy-details__text-editor(@click="toggleVueEditorHandler", v-if="!toggleVueEditor") {{ content }}
      vue-editor.policy-details__text-editor(v-if="toggleVueEditor", v-model="content", @blur="handleBlur")
      div(v-if="section.children && section.children.length > 0")
        PolicySubsection(
        v-for="(child, subIndex) in section.children"
        v-bind:section="child"
        :index="subIndex"
        :key="child.id"
        :parentSection="section"
        @addSection="addSection"
        @deleteSubSection="deleteSubSection")
      <!--component(v-for="subSectionChild in subSectionsChildrens", v-bind:is="subSectionChild.component", :key="subSectionChild.id", :subSectionChild="subSectionChild", :subSectionsID="subSectionsID" @clicked="onClickButton", @clickedSaveIt="onClickSaveSubsection")-->
    button.policy-details__btn.mr-3.btn.btn-default(@click="addSection") Add Section
</template>

<script>
  import { VueEditor } from "vue2-editor";

  export default {
    name: 'PolicySubsection',
    props: {
      policyID: {
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
    },
    data() {
      return {
        content: "N/A",
        title: "New Policy",
        toggleVueEditor: false,
        isActive: false,
        subSectionID: Math.floor(Math.random() * 100),
        count: 0,
      }
    },
    computed: {
      subSectionName () {
        return `Subsection Name New Policy ${this.subSection.id}`
      }
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
            id: this.count++ + id,
            title: `${this.title}-№-${this.count}-${id}`,
            description: this.content,
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
          title: `${this.title}-№-${this.count}-${id}`,
          description: 'N/A',
          children: [],
        })

      },

      toggleVueEditorHandler() {
        this.toggleVueEditor = !this.toggleVueEditor;
      },
      handleBlur() {
        this.toggleVueEditorHandler()
      },
      moveUpSubsection () {
        console.log('moveUpSubsection')
        this.$emit('clickedmoveUpSection', 'someValue')
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
