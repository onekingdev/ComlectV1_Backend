<template lang="pug">
  .review__list
    ReviewLink(
      :annual-id="annualId"
      :current-id="currentId"
      :general="general"
    )
    template(v-for="reviewCategory in reviewsCategories")
      ReviewLink(
        :title="reviewCategory.name"
        :checked="reviewCategory.complete"
        :id="reviewCategory.id"
        :annual-id="annualId"
        :current-id="currentId"
      )
    .review__category-add
      button.btn.btn-default(v-if="!category.visible" @click="category.visible = true")
        b-icon.mr-2(icon='plus-circle-fill')
        | Add Category
      .review__category-add__form(v-else)
        input.form-control(v-model="category.name" type="text" ref="input" @blur="addCategory")
        //button.btn.btn-default(@click="addCategory")
        //  b-icon.mr-2(icon='plus-circle-fill')
        //  | Add Category
</template>

<script>
import { mapActions } from "vuex"
import ReviewLink from "./ReviewLink";

export default {
  name: "ReviewsList",
  props: ['annualId', 'reviewsCategories', 'currentId', 'general'],
  data() {
    return {
      category: {
        visible: false,
        name: ""
      }
    }
  },
  components: {
    ReviewLink
  },
  methods: {
    ...mapActions({
      createReviewCategory: 'annual/createReviewCategory',
      getCurrentReviewReview: 'annual/getCurrentReview'
    }),
    async addCategory () {
      if (this.category.name.length === 0) {
        this.category.visible = false
        return
      }
      const reviewCategory = this.category
      const data = {
        annualId: this.annualId,
        name: reviewCategory.name,
        complete: false
      }
      try {
        this.category.visible = false
        const response = await this.createReviewCategory(data)
        if (response) {
          this.toast('Success', "New category added")
          await this.getCurrentReviewReview(this.annualId)
          this.category.name = ""
          //window.location.href = `${window.location.origin}/business/annual_reviews/${response.annual_report_id}/${response.id}`
          this.$router.push(`/business/compliance_policies/${response.annual_report_id}/${response.id}`)
        }
      } catch (error) {
        this.toast('Error', error.message, true)
      }
    },
  }
}
</script>

<style scoped>

</style>
