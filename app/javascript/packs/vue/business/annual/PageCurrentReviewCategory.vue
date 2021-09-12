<template lang="pug">
  .page.review
    .page-header.bg-white
      div
        h2.page-header__breadcrumbs Internal Review
        h2.page-header__title: b {{ review ? review.year : '' }} {{ review ? review.name : '' }}
      .page-header__actions
        div
          button.btn.btn-default.mr-3.d-none Download
          button.btn.btn-dark.mr-3(@click="saveAndExit()") Save and Exit
          button.btn.btn__close(@click="backToList")
            b-icon(icon="x")

    b-tabs.reviews__tabs(content-class="mt-0")
      template(#tabs-end)
        b-dropdown.actions(text='Actions', variant="default", right)
          template(#button-content)
            | Actions
            b-icon.m-l-1(icon="chevron-down" font-scale="1")
          AnnualModalEdit(:review="review || {}" :inline="false")
            b-dropdown-item Edit
          AnnualModalDelete(@deleteConfirmed="deleteReview(review.id)" :inline="false")
            b-dropdown-item.delete Delete
      b-tab(title="Detail" active)
        .p-x-40(v-if="review")
          .row
            .col-md-3
              ReviewsList(
                :annual-id="annualId"
                :current-id="revcatId"
                :reviews-categories="review.review_categories"
              )
            .col-md-9.m-b-40
              .card-body.white-card-body.reviews__card
                .reviews__card--internal.pt-0
                  .d-flex.justify-content-between.align-items-center
                    h3
                      | {{ currentCategory.name }}
                    AnnualModalDeleteCategory.ml-auto(@deleteConfirmed="deleteCategory(currentCategory.id)", :inline="false")
                      b-button.btn.btn-default(variant="light") Delete
                .reviews__topiclist(v-if="currentCategory.review_topics")
                  template(v-for="(currentTopic, i) in currentCategory.review_topics")
                    .reviews__card--internal(:key="`${currentCategory.name}-${i}`")
                      .row.m-b-2
                        .col-md-8
                          input.reviews__input.reviews__topic-name(v-model="currentTopic.name" placeholder="New Topic")
                        .col-md-4.text-right
                          b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                            template(#button-content)
                              | Actions
                              b-icon.ml-2(icon="chevron-down")
                            b-dropdown-item(@click="addTopicItem(i)") New Item
                            TaskFormModal(@saved="createTask(i)" :inline="false")
                              b-dropdown-item New Task
                            b-dropdown-item(@click="deleteTopic(i)").delete Delete
                      template(v-for="(topicItem, topicItemIndex) in currentTopic.items")
                        .row.mb-2(:key="`${currentCategory.name}-${i}-${topicItemIndex}`")
                          .col-md-2.col-lg-2.col-xl-1
                            .reviews__checkbox.d-flex.justify-content-between
                              .reviews__checkbox-item.reviews__checkbox-item--true(@click="topicItem.checked = true" :class="{ 'checked': topicItem.checked }")
                                b-icon(icon="check2")
                              .reviews__checkbox-item.reviews__checkbox-item--false(@click="topicItem.checked = false" :class="{ 'checked': !topicItem.checked }")
                                b-icon(icon="x")
                          .col-md-8.col-lg-8.col-xl-10.new-item-text
                            textarea-autosize.reviews__input.reviews__topic-body(v-model="topicItem.body" placeholder="New Item")
                          .col-md-2.col-lg-2.col-xl-1.text-right
                            b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                              template(#button-content)
                                b-icon(icon="three-dots")
                              b-dropdown-item(@click="addFindings(i, topicItemIndex)") Log Finding
                              b-dropdown-item.delete(@click="deleteTopicItem(i, topicItemIndex)") Delete
                          .col-md-11.offset-md-1(v-if="topicItem.findings.length")
                            label.form-label Finding
                          template(v-for="(finding, findingIndex) in topicItem.findings")
                            .col-md-10.offset-md-1(:key="`${currentTopic.name}-${i}-${topicItemIndex}-${findingIndex}`")
                              textarea.finding-area.form-control.m-b-1(v-model="currentCategory.review_topics[i].items[topicItemIndex].findings[findingIndex]" type="text")
                              button.btn.btn__close.float-right(@click="removeFinding(i, topicItemIndex, findingIndex)")
                                b-icon(icon="x" font-scale="1")
                .reviews__card--internal.borderless.p-t-20
                  .d-flex.justify-content-between.align-items-center
                    button.btn.btn-default(@click="addTopic")
                      b-icon.mr-2(icon='plus-circle-fill')
                      | New Topic
                    .d-flex.justify-content-end
                      button.btn.btn-default.mr-2(@click="saveCategory") Save
                      button.btn(v-if="currentCategory.complete" :class="'btn-dark'" @click="markComplete") Mark as Incomplete
                      AnnualModalComplite(v-else @compliteConfirmed="markComplete", :completedStatus="currentCategory.complete" :name="currentCategory.name" :inline="false")
                        button.btn(:class="'btn-dark'") Mark as Complete
      b-tab(title="Tasks")
        PageTasks
      b-tab(title="Documents")
        PageDocuments
      b-tab(title="Activity")
        PageActivity
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import ReviewsList from "./components/ReviewsList";
import AnnualModalComplite from './modals/AnnualModalComplite'
import AnnualModalEdit from './modals/AnnualModalEdit'
import AnnualModalDelete from './modals/AnnualModalDelete'
import AnnualModalDeleteCategory from './modals/AnnualModalDeleteCategory'
import TaskFormModal from '@/common/TaskFormModal'
import PageTasks from './PageTasks'
import PageDocuments from './PageDocuments'
import PageActivity from './PageActivity'

export default {
  props: ['annualId', 'revcatId'],
  components: {
    ReviewsList,
    AnnualModalComplite,
    AnnualModalEdit,
    AnnualModalDelete,
    AnnualModalDeleteCategory,
    TaskFormModal,
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
      review: 'annual/currentReview'
    }),
    currentCategory () {
      return this.review.review_categories.find(item => item.id === this.revcatId)
    }
  },
  methods: {
    ...mapActions({
      updateReviewCategory: 'annual/updateReviewCategory',
      getCurrentReviewReview: 'annual/getCurrentReview'
    }),
    async saveCategory () {
      const reviewCategory = this.currentCategory
      const data = {
        annualId: this.annualId,
        ...reviewCategory
      }
      try {
        await this.updateReviewCategory(data)
        this.toast('Success', "Internal review has been saved.")
        await this.getCurrentReviewReview(this.annualId)
      } catch (error) {
        this.toast('Error', error.message, true)
      }
    },
    async markComplete () {
      const reviewCategory = this.currentCategory
      const data = {
        annualId: this.annualId,
        ...reviewCategory,
        complete: !reviewCategory.complete,
      }
      try {
        await this.updateReviewCategory(data)
        const text = data.complete ? 'complete' : 'incomplete'
        this.toast('Success', `Category has been marked as ${text}.`)
        await this.getCurrentReviewReview(this.annualId)
      } catch (error) {
        this.toast('Error', error.message, true)
      }
    },
    addTopic() {
      const reviewCategory = this.currentCategory
      if (!reviewCategory.review_topics) {
        this.currentCategory.review_topics = [
          {
            items: [],
            name: ""
          }
        ]
        return
      }
      this.currentCategory.review_topics.push({
        items: [],
        name: ""
      })
    },
    addTopicItem(i) {
      this.currentCategory.review_topics[i].items.push({
        findings: [],
        body: "",
        checked: false
      })
    },
    addFindings(i, itemIndex) {
      this.currentCategory.review_topics[i].items[itemIndex].findings.push("")
    },
    removeFinding(topicIndex, itemIndex, findingIndex) {
      const finding = this.currentCategory.review_topics[topicIndex].items[itemIndex].findings[findingIndex]
      
      if (finding && finding.id) {
        finding['_destroy'] = true
        this.$set(this.currentCategory.review_topics[topicIndex].items[itemIndex].findings, findingIndex, finding)
      } else {
        this.currentCategory.review_topics[topicIndex].items[itemIndex].findings.splice(findingIndex, 1)
      }
    },
    deleteTopicItem(i, itemIndex) {
      this.currentCategory.review_topics[i].items.splice(itemIndex, 1);
    },
    deleteTopic(i) {
      this.currentCategory.review_topics.splice(i, 1);
    },
    deleteCategory(id) {
      console.log('currentCategory id: ', id)
      this.$store.dispatch('annual/deleteReviewCategory', { annualId: this.review.id, id: id })
        .then(response => {
          this.toast('Success', `The annual review category has been deleted! ${response.id}`)
          //window.location.href = `${window.location.origin}/business/annual_reviews/${response.annual_report_id}`
          this.$router.push(`/business/annual_reviews/${response.annual_report_id}`)
        })
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`, true))
    },
    createTask(i){
      console.log('createTask: ', i)
    },
    saveAndExit() {
      this.saveCategory()
      setTimeout(() => {
        this.$router.push(`/business/annual_reviews`)
      }, 3000)
    },
    deleteReview(reviewId){
      this.$store.dispatch('annual/deleteReview', { id: reviewId })
        .then(response => {
          this.toast('Success', `The annual review has been deleted! ${response.id}, true`)
          //window.location.href = `${window.location.origin}/business/annual_reviews`
          this.$router.push(`/business/annual_reviews`)
        })
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`, true))
    },
    backToList() {
      this.$router.push({ name: 'annual-reviews' })
    }
  },
  async mounted () {
    try {
      await this.getCurrentReviewReview(this.annualId)
    } catch (error) {
      this.toast('Error', error.message, true)
    }
  },
}
</script>
<style scoped>
  .finding-area {
    width: calc(100% - 30px);
    float: left;
  }

  @media only screen and (min-width: 1200px) {
    .new-item-text {
      padding-left: 30px !important;
    }
  }

  @media only screen and (min-width: 1700px) {
    .new-item-text {
      padding-left: 0 !important;
    }
  }

  @media only screen and (max-width: 767px) {
    .new-item-text textarea {
      margin-top: 10px;
    }
  }
</style>