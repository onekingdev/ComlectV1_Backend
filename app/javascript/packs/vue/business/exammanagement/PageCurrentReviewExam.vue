<template lang="pug">
  div.exam
    .card-body.white-card-body
      .container-fluid
        .row
          .col-md-12.p-t-1.d-flex.justify-content-between
            div
              h3 Regulatory Exams&nbsp;
                span.separator /&nbsp;
                b {{ exam ? exam.year : '' }} {{ exam ? exam.name : '' }}
              h2: b {{ exam ? exam.year : '' }} {{ exam ? exam.name : '' }}
            div
              button.btn.btn-default.mr-3 Download
              button.btn.btn-dark.mr-3(@click="saveAndExit") Save and Exit
              AnnualModalDelete(@deleteConfirmed="deleteexam(exam.id)")
                button.btn.btn__close
                  b-icon(icon="x")
    .exams__tabs
      b-tabs(content-class="mt-0")
        b-tab(title="Detail" active)
          .container-fluid(v-if="exam")
            .row
              .col-md-3
                examsList(
                  :annual-id="annualId"
                  :current-id="revcatId"
                  :exams-categories="exam.exam_categories"
                )
              .col-md-9.position-relative
                .annual-actions
                  b-dropdown.bg-white(text='Actions', variant="secondary", right)
                    AnnualModalEdit(:exam="exam" :inline="false")
                      b-dropdown-item Edit
                    AnnualModalDelete(@deleteConfirmed="deleteexam(exam.id)" :inline="false")
                      b-dropdown-item.delete Delete
                .card-body.white-card-body.exams__card.px-5
                  .exams__card--internal.p-y-1.d-flex
                    h3
                      | {{ currentCategory.name }}
                      b-badge.ml-2(variant="light") {{ currentCategory.exam_topics ? currentCategory.exam_topics.length : 0 }} Tasks
                    AnnualModalDeleteCategory.ml-auto(@deleteConfirmed="deleteCategory(currentCategory.id)", :inline="false")
                      b-button(variant="light") Delete
                  .exams__topiclist(v-if="currentCategory.exam_topics")
                    template(v-for="(currentTopic, i) in currentCategory.exam_topics")
                      .exams__card--internal.p-y-1(:key="`${currentCategory.name}-${i}`")
                        .row.m-b-2
                          .col-md-10
                            label.exams__topic-label Topic Title
                            input.exams__input.exams__topic-name(v-model="currentTopic.name")
                          .col-md-2.text-right
                            b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                              template(#button-content)
                                | Actions
                                b-icon.ml-2(icon="chevron-down")
                              b-dropdown-item(@click="addTopicItem(i)") Add item
                              AnnualModalCreateTask(@saved="createTask(i)" :inline="false")
                                b-dropdown-item Create task
                              b-dropdown-item(@click="deleteTopic(i)").delete Delete Topic
                        template(v-for="(topicItem, topicItemIndex) in currentTopic.items")
                          .row(:key="`${currentCategory.name}-${i}-${topicItemIndex}`")
                            .col-md-1
                              .exams__checkbox.d-flex.justify-content-between
                                .exams__checkbox-item.exams__checkbox-item--true(@click="topicItem.checked = true" :class="{ 'checked': topicItem.checked }")
                                  b-icon(icon="check2")
                                .exams__checkbox-item.exams__checkbox-item--false(@click="topicItem.checked = false" :class="{ 'checked': !topicItem.checked }")
                                  b-icon(icon="x")
                            .col-md-10
                              textarea.exams__input.exams__topic-body(v-model="topicItem.body")
                            .col-md-1.text-right
                              b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                                template(#button-content)
                                  b-icon(icon="three-dots")
                                b-dropdown-item(@click="addFindings(i, topicItemIndex)") Log Finding
                                b-dropdown-item.delete(@click="deleteTopicItem(i, topicItemIndex)") Delete item
                            .col-md-11.offset-md-1(v-if="topicItem.findings.length")
                              label.form-label Finding
                            template(v-for="(finding, findingIndex) in topicItem.findings")
                              .col-md-10.offset-md-1(:key="`${currentTopic.name}-${i}-${topicItemIndex}-${findingIndex}`")
                                textarea.form-control.m-b-1(v-model="currentCategory.exam_topics[i].items[topicItemIndex].findings[findingIndex]" type="text")
                  button.btn.btn-default.m-y-2(@click="addTopic")
                    b-icon.mr-2(icon='plus-circle-fill')
                    | New Topic
                  .white-card-body.p-y-1
                    .d-flex.justify-content-end
                      button.btn.btn-default.mr-2(@click="saveCategory") Save
                      AnnualModalComplite(@compliteConfirmed="markComplete", :completedStatus="currentCategory.complete" :name="currentCategory.name" :inline="false")
                        button.btn(:class="currentCategory.complete ? 'btn-default' : 'btn-dark'") Mark {{ currentCategory.complete ? 'Incomplete' : 'Complete' }}
        b-tab(title="Tasks")
          PageTasks
        b-tab(title="Documents")
          PageDocuments
        b-tab(title="Activity")
          PageActivity
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import { VueEditor } from "vue2-editor"
import examsList from "./components/examsList";
import AnnualModalComplite from './modals/AnnualModalComplite'
import AnnualModalEdit from './modals/AnnualModalEdit'
import AnnualModalDelete from './modals/AnnualModalDelete'
import AnnualModalDeleteCategory from './modals/AnnualModalDeleteCategory'
import AnnualModalCreateTask from './modals/AnnualModalCreateTask'
import PageTasks from './PageTasks'
import PageDocuments from './PageDocuments'
import PageActivity from './PageActivity'

export default {
  props: ['annualId', 'revcatId'],
  components: {
    examsList,
    VueEditor,
    AnnualModalComplite,
    AnnualModalEdit,
    AnnualModalDelete,
    AnnualModalDeleteCategory,
    AnnualModalCreateTask,
    PageTasks,
    PageDocuments,
    PageActivity
  },
  data () {
    return {
      customToolbar: [
        ["bold", "italic", "underline"],
        ["blockquote"],
        [{ list: "bullet" }],
        ["link"]
      ]
    }
  },
  computed: {
    ...mapGetters({
      exam: 'annual/currentExam'
    }),
    currentCategory () {
      return this.exam.exam_categories.find(item => item.id === this.revcatId)
    }
  },
  async mounted () {
    try {
      await this.getCurrentexamexam(this.annualId)
    } catch (error) {
      this.makeToast('Error', error.message)
    }
  },
  methods: {
    ...mapActions({
      updateexamCategory: 'annual/updateexamCategory',
      getCurrentexamexam: 'annual/getCurrentexam'
    }),
    async saveCategory () {
      const examCategory = this.currentCategory
      const data = {
        annualId: this.annualId,
        ...examCategory
      }
      try {
        await this.updateexamCategory(data)
        this.makeToast('Success', "Saved changes to annual exam.")
        await this.getCurrentexamexam(this.annualId)
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    async markComplete () {
      const examCategory = this.currentCategory
      const data = {
        annualId: this.annualId,
        ...examCategory,
        complete: !examCategory.complete,
      }
      try {
        await this.updateexamCategory(data)
        this.makeToast('Success', "Saved changes to annual exam.")
        await this.getCurrentexamexam(this.annualId)
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    addTopic() {
      const examCategory = this.currentCategory
      if (!examCategory.exam_topics) {
        this.currentCategory.exam_topics = [
          {
            items: [],
            name: "New topic"
          }
        ]
        return
      }
      this.currentCategory.exam_topics.push({
        items: [],
        name: "New topic"
      })
    },
    addTopicItem(i) {
      this.currentCategory.exam_topics[i].items.push({
        findings: [],
        body: "New topic",
        checked: false
      })
    },
    addFindings(i, itemIndex) {
      this.currentCategory.exam_topics[i].items[itemIndex].findings.push("")
    },
    deleteTopicItem(i, itemIndex) {
      this.currentCategory.exam_topics[i].items.splice(itemIndex, 1);
    },
    deleteTopic(i) {
      this.currentCategory.exam_topics.splice(i, 1);
    },
    deleteCategory(id) {
      console.log('currentCategory id: ', id)
      this.$store.dispatch('annual/deleteexamCategory', { annualId: this.exam.id, id: id })
        .then(response => {
          this.toast('Success', `The annual exam category has been deleted! ${response.id}`)
          window.location.href = `${window.location.origin}/business/annual_exams/${response.annual_report_id}`
        })
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    createTask(i){
      console.log('createTask: ', i)
    },
    saveAndExit() {
      this.saveCategory()
      window.location.href = `${window.location.origin}/business/annual_exams/`
    },
    deleteexam(examId){
      this.$store.dispatch('annual/deleteexam', { id: examId })
        .then(response => {
          this.toast('Success', `The annual exam has been deleted! ${response.id}`)
          window.location.href = `${window.location.origin}/business/annual_exams`
        })
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    }
  }
}
</script>
