<template lang="pug">
  div.review
    .card-body.white-card-body
      .container-fluid
        .row
          .col-md-12.p-t-1.d-flex.justify-content-between
            div
              h3 Internal Review&nbsp;
                span.separator /&nbsp;
                b Annual Review {{ review ? review.year : '' }}
              h2: b Annual Review {{ review ? review.year : '' }}
            div
              button.btn.btn-default.mr-3 Download
              button.btn.btn-dark.mr-3 Save and Exit
              button.btn.btn-light
                b-icon(icon="x")
    .reviews__tabs
      b-tabs(content-class="mt-0")
        b-tab(title="Detail" active)
          .container-fluid(v-if="review")
            .row
              .col-md-3
                ReviewsList(
                  :annual-id="annualId"
                  :current-id="revcatId"
                  :reviews-categories="review.review_categories"
                )
              .col-md-9
                .card-body.white-card-body.reviews__card.px-5
                  .reviews__card--internal.p-y-1.d-flex
                    h3
                      | {{ currentCategory.name }}
                      b-badge.ml-2(variant="light") 0 Tasks
                    AnnualModalDeleteCategory.ml-auto(@deleteConfirmed="deleteCategory", :inline="false")
                      b-button(variant="light") Delete
                  .reviews__topiclist(v-if="currentCategory.review_topics")
                    template(v-for="(currentTopic, i) in currentCategory.review_topics")
                      .reviews__card--internal.p-y-1(:key="`${currentCategory.name}-${i}`")
                        .row.m-b-2
                          .col-md-10
                            input.reviews__input.reviews__topic-name(v-model="currentTopic.name")
                          .col-md-2.text-right
                            b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                              template(#button-content)
                                | Actions
                                b-icon.ml-2(icon="chevron-down")
                              b-dropdown-item(@click="addTopicItem(i)") Add item
                              b-dropdown-item(@click="deleteTopic(i)").delete Delete Topic
                        template(v-for="(topicItem, topicItemIndex) in currentTopic.items")
                          .row(:key="`${currentCategory.name}-${i}-${topicItemIndex}`")
                            .col-md-1
                              .reviews__checkbox.d-flex.justify-content-between
                                .reviews__checkbox-item.reviews__checkbox-item--true(@click="topicItem.checked = true" :class="{ 'checked': topicItem.checked }")
                                  b-icon(icon="check2")
                                .reviews__checkbox-item.reviews__checkbox-item--false(@click="topicItem.checked = false" :class="{ 'checked': !topicItem.checked }")
                                  b-icon(icon="x")
                            .col-md-10
                              textarea.reviews__input.reviews__topic-body(v-model="topicItem.body")
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
                                textarea.form-control(v-model="currentCategory.review_topics[i].items[topicItemIndex].findings[findingIndex]" type="text")
                  button.btn.btn-default(@click="addTopic")
                    b-icon.mr-2(icon='plus-circle-fill')
                    | New Topic
                  .white-card-body.p-y-1
                    .d-flex.justify-content-end
                      button.btn.btn-default.mr-2(@click="saveCategory") Save
                      AnnualModalComplite(@compliteConfirmed="markComplete", :inline="false")
                        button.btn.btn-dark Mark Complete
        b-tab(title="Tasks")
          div Tasks
        b-tab(title="Documents")
          div Documents
        b-tab(title="Activity")
          div Activity
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import { VueEditor } from "vue2-editor"
import ReviewsList from "./components/ReviewsList";
import AnnualModalComplite from './modals/AnnualModalComplite'
import AnnualModalDeleteCategory from './modals/AnnualModalDeleteCategory'

export default {
  props: ['annualId', 'revcatId'],
  components: {
    ReviewsList,
    VueEditor,
    AnnualModalComplite,
    AnnualModalDeleteCategory
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
  async mounted () {
    try {
      await this.getCurrentReviewReview(this.annualId)
    } catch (error) {
      this.makeToast('Error', error.message)
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
        this.makeToast('Success', "Saved changes to annual review.")
        await this.getCurrentReviewReview(this.annualId)
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    async markComplete () {
      const reviewCategory = this.currentCategory
      const data = {
        annualId: this.annualId,
        complete: true,
        ...reviewCategory,
      }
      try {
        await this.updateReviewCategory(data)
        // this.makeToast('Success', "Saved changes to annual review.")
        // await this.getCurrentReviewReview(this.annualId)
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    addTopic() {
      const reviewCategory = this.currentCategory
      if (!reviewCategory.review_topics) {
        this.currentCategory.review_topics = [
          {
            items: [],
            name: "New topic"
          }
        ]
        return
      }
      this.currentCategory.review_topics.push({
        items: [],
        name: "New topic"
      })
    },
    addTopicItem(i) {
      this.currentCategory.review_topics[i].items.push({
        findings: [],
        body: "New topic",
        checked: false
      })
    },
    addFindings(i, itemIndex) {
      this.currentCategory.review_topics[i].items[itemIndex].findings.push("")
    },
    deleteTopicItem(i, itemIndex) {
      this.currentCategory.review_topics[i].items.splice(itemIndex, 1);
    },
    deleteTopic(i) {
      this.currentCategory.review_topics.splice(i, 1);
    },
    deleteCategory() {
      console.log('this.currentCategory', this.currentCategory)
    },
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    }
  }
}
</script>
