<template lang="pug">
  div.review
    .card-body.white-card-body
      .container-fluid
        .row
          .col-md-12.p-t-1.d-flex.justify-content-between
            div
              h2: b Annual Review {{review.year}}
            div
              button.btn.btn-default.float-end Download
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
                .card-body.white-card-body.reviews__card
                  .reviews__card--internal.p-y-1
                    h3
                      | {{ currentCategory.name }}
                  .reviews__topiclist(v-if="currentCategory.review_topics")
                    template(v-for="(currentTopic, i) in currentCategory.review_topics")
                      .reviews__card--internal.p-y-1(:key="`${currentCategory.name}-${i}`")
                        .row
                          .col-md-11
                            input.reviews__input.reviews__topic-name(v-model="currentTopic.name")
                          .col-md-1
                            b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                              template(#button-content)
                                | Actions
                              b-dropdown-item(@click="addTopicItem(i)") Add item
                              b-dropdown-item(@click="deleteTopic(i)") Delete Topic
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
                            .col-md-1
                              b-dropdown(size="xs" variant="light" class="m-0 p-0" right)
                                template(#button-content)
                                  b-icon(icon="three-dots")
                                b-dropdown-item(@click="addFindings(i, topicItemIndex)") Log Finding
                                b-dropdown-item(@click="deleteTopicItem(i, topicItemIndex)") Delete item
                            .col-md-11.offset-md-1(v-if="topicItem.findings.length")
                              label.form-label findings
                            template(v-for="(finding, findingIndex) in topicItem.findings")
                              .col-md-10.offset-md-1(:key="`${currentTopic.name}-${i}-${topicItemIndex}-${findingIndex}`")
                                textarea.form-control(v-model="currentCategory.review_topics[i].items[topicItemIndex].findings[findingIndex]" type="text")
                  button.btn.btn-default(@click="addTopic")
                    b-icon.mr-2(icon='plus-circle-fill')
                    | New Topic
                  .white-card-body.p-y-1
                    .d-flex.justify-content-end
                      button.btn.btn-default.float-end(@click="saveCategory") Save
                      button.btn.btn-dark.float-end Mark Complete
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import { VueEditor } from "vue2-editor"
import ReviewsList from "./components/ReviewsList";

export default {
  props: ['annualId', 'revcatId'],
  components: {
    ReviewsList,
    VueEditor
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
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    }
  }
}
</script>
