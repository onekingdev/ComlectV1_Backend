<template lang="pug">
  div.exam
    .card-body.white-card-body
      .container-fluid
        .row
          .col-md-12.p-t-1.d-flex.justify-content-between
            div
              h3 Regulatory Exams&nbsp;
                span.separator /&nbsp;
                b {{ exam ? exam.name : '' }}
              h2: b {{ exam ? exam.name : '' }}
            div
              a.btn.link.mr-3 Share Link
              button.btn.btn-default.mr-3 Mark Complite
              button.btn.btn-dark.mr-3(@click="saveAndExit") Save and Exit
              button.btn.btn__close
                b-icon(icon="x")
    .reviews__tabs.exams__tabs
      b-tabs(content-class="mt-0")
        b-tab(title="Detail" active)
          .container-fluid(v-if="exam")
            .row
              .col-md-9.mx-auto.position-relative
                .annual-actions
                  b-dropdown.bg-white(text='Actions', variant="secondary", right)
                    b-dropdown-item Edit
                    b-dropdown-item.delete Delete
                .card-body.white-card-body.reviews__card.px-5
                  .reviews__card--internal.p-y-1.d-flex.justify-content-between
                    h3 Requests
                    b-button(variant='default') View Portal
                  .reviews__topiclist
                    .p-t-2.d-flex.justify-content-between
                      b-form-group
                        b-button(size="md" type='button' variant='dark') All
                        b-button(size="md" type='button' variant='outline-dark') Shared
                      ExamRequestModalCreate(:examId="examId")
                        b-button(variant='default') Add request
                    template(v-if="currentExam.exam_requests" v-for="(currentRequst, i) in currentExam.exam_requests")
                      .reviews__card--internal.exams__card--internal(:key="`${currentExam.name}-${i}`" :class="{ 'completed': currentRequst.complete }")
                        .row.m-b-1
                          .col-md-1
                            .reviews__checkbox.d-flex.justify-content-between
                              .reviews__checkbox-item.reviews__checkbox-item--true(@click="markComplete(currentRequst.id, true)" :class="{ 'checked': currentRequst.complete }")
                                b-icon(icon="check2")
                              .reviews__checkbox-item.reviews__checkbox-item--false(@click="markComplete(currentRequst.id, false)" :class="{ 'checked': !currentRequst.complete }")
                                b-icon(icon="x")
                          .col-md-11
                            .d-flex.justify-content-between.align-items-center
                              .d-flex
                                b-badge.mr-2(v-if="currentRequst.shared" variant="success") {{ currentRequst.shared ? 'Shared' : '' }}
                                .exams__input.exams__topic-name {{ currentRequst.name }}
                              .d-flex.actions
                                b-dropdown(size="xs" variant="default" class="m-0 p-0" right)
                                  template(#button-content)
                                    | Add Item
                                    b-icon.ml-2(icon="chevron-down")
                                  b-dropdown-item(@click="addTextEntry(i)") Text Entry
                                  b-dropdown-item Upload New
                                  b-dropdown-item(@click="deleteTopic(i)") Select Existing
                                button.btn.btn-default.m-x-1 Create Task
                                b-dropdown(size="sm" variant="none" class="m-0 p-0" right)
                                  template(#button-content)
                                    b-icon(icon="three-dots")
                                  ExamRequestModalEdit(:examId="currentExam.id" :request="currentRequst" :inline="false")
                                    b-dropdown-item Edit
                                  b-dropdown-item(@click="shareReqeust(currentRequst.id, true)") Share
                                  ExamModalDelete(@deleteConfirmed="deleteExamRequest(currentRequst.id)" :inline="false")
                                    b-dropdown-item.delete Delete
                        .row.m-b-1
                          .col-md-11.offset-md-1
                            p {{ currentRequst.details }}
                        .row.m-b-1
                          .col-md-11.offset-md-1
                            .d-flex.justify-content-between.align-items-center
                              span
                                b-icon.mr-2(:icon="currentRequst.text_items ? 'chevron-down' : 'chevron-right'")
                                | {{ currentRequst.text_items ? currentRequst.text_items.length : 0 }} Items
                            div(v-if="currentRequst.text_items")
                              hr
                              .row
                                template(v-for="(textItem, textIndex) in currentRequst.text_items")
                                .col-11(:key="`${currentRequst.name}-${i}-${textItem}-${textIndex}`")
                                  textarea.exams__topic-body.w-100(v-model="currentRequst.text_items[textIndex]")
                                .col-1
                                  button.btn.btn__close(@click="removeTextEntry(i, textIndex)")
                                    b-icon(icon="x" font-scale="1")
                            .row
                              template(v-for="(file, fileIndex) in currentRequst.exam_request_files")
                                .col-md-6(:key="`${currentRequst.name}-${i}-${file}-${fileIndex}`")
                                  b-icon.mr-2(icon="file-earmark-text-fill")
                                  p {{ file.name }} file name
                                  .link Download
                                  b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                                    template(#button-content)
                                      b-icon(icon="three-dots")
                                    b-dropdown-item.delete Delete file
                  ExamRequestModalCreate(:examId="examId")
                    b-button.m-b-2(variant='default')
                      b-icon.mr-2(icon='plus-circle-fill')
                      | Add Request
                  .white-card-body.p-y-1
                    .d-flex.justify-content-end
                      button.btn.btn-default.mr-2(@click="saveCategory") Save
                      button.btn(:class="currentExam.complete ? 'btn-default' : 'btn-dark'") Mark {{ currentExam.complete ? 'Incomplete' : 'Complete' }}
        b-tab(title="Tasks")
          span Tasks
        b-tab(title="Attachments")
          span Attachments
        b-tab(title="Activity")
          span Activity
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import { VueEditor } from "vue2-editor"
import ExamRequestModalCreate from "./modals/ExamRequestModalCreate";
import ExamModalDelete from "./modals/ExamModalDelete";
import ExamRequestModalEdit from "./modals/ExamRequestModalEdit";

export default {
  props: ['examId'],
  components: {
    ExamRequestModalEdit,
    ExamRequestModalCreate,
    ExamModalDelete,
    VueEditor,
  },
  data () {
    return {
      customToolbar: [
        ["bold", "italic", "underline"],
        ["blockquote"],
        [{ list: "bullet" }],
        ["link"]
      ],
    }
  },
  computed: {
    ...mapGetters({
      exam: 'exams/currentExam'
    }),
    currentExam () {
      // return this.exam.exam_categories.find(item => item.id === this.revcatId)
      return this.exam
    }
  },
  async mounted () {
    try {
      await this.getCurrentExam(this.examId)
    } catch (error) {
      this.makeToast('Error', error.message)
    }
  },
  methods: {
    ...mapActions({
      updateExam: 'exams/updateExam',
      getCurrentExam: 'exams/getExamById',
      updateCurrentExamRequest: 'exams/updateExamRequest',
      deleteCurrentExamRequest: 'exams/deleteExamRequest'
    }),
    async saveCategory () {
      const examCategory = this.currentExam
      const data = {
        examlId: this.examlId,
        ...examCategory
      }
      try {
        await this.updateexamCategory(data)
        this.makeToast('Success', "Saved changes to annual exam.")
        await this.getCurrentExam(this.examlId)
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    async markComplete (id, status) {
      const data = {
        id: this.currentExam.id,
        request: {
          id,
          complete: status,
        }
      }
      try {
        await this.updateCurrentExamRequest(data)
        this.makeToast('Success', "Request updated!")
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    async shareReqeust (id, status) {
      const data = {
        id: this.currentExam.id,
        request: {
          id,
          shared: status,
        }
      }
      try {
        await this.updateCurrentExamRequest(data)
        this.makeToast('Success', "Request updated!")
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    addTopic() {
      const examCategory = this.currentExam
      if (!examCategory.exam_topics) {
        this.currentExam.exam_topics = [
          {
            items: [],
            name: "New topic"
          }
        ]
        return
      }
      this.currentExam.exam_topics.push({
        items: [],
        name: "New topic"
      })
    },
    addTextEntry(i) {
      if (!this.currentExam.exam_requests[i].text_items) this.currentExam.exam_requests[i].text_items = []
      this.currentExam.exam_requests[i].text_items.push('')
    },
    removeTextEntry(i, itemIndex) {
      this.currentExam.exam_requests[i].text_items.splice(itemIndex, 1);
    },
    addFindings(i, itemIndex) {
      this.currentExam.exam_topics[i].items[itemIndex].findings.push("")
    },
    deleteTopicItem(i, itemIndex) {
      this.currentExam.exam_topics[i].items.splice(itemIndex, 1);
    },
    deleteTopic(i) {
      this.currentExam.exam_topics.splice(i, 1);
    },
    async deleteExamRequest(id) {
      try {
        await this.deleteCurrentExamRequest({ id: this.examId, requestId: id })
        this.toast('Success', `The request has been deleted!`)
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    createTask(i){
      console.log('createTask: ', i)
    },
    saveAndExit() {
      this.saveCategory()
      window.location.href = `${window.location.origin}/business/exam_management/`
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

<style scoped>
  .separator {
    color: #ffc107;
  }

  .reviews__checkbox {
    margin-top: 5px;
  }

  .exams__topic-body {
    border: 1px solid #dee2e6;
  }

  .exams__card--internal {
    margin-bottom: 2rem;
    padding: 1rem;
    border: solid 1px #dcdee4;
    border-radius: 5px;
  }

  .completed {
    background-color: #f3f6f9;
  }
</style>
