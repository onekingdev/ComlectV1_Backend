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
                  :reviews-categories="review.review_categories"
                  :general="true"
                )
              .col-md-9
                .card-body.white-card-body.reviews__card
                  .reviews__card--internal.p-y-1
                    h3
                      | General
                  .reviews__card--internal.p-y-1
                    .row
                      .col-md-12
                        h4
                          b Review Period
                        p For annual reviews, this time period typically spans a calendar or fiscal year and wil be referred to hereafter as "the Review Period
                      .col-6
                        label.form-label Start Date
                        DatePicker(v-model="review.review_start")
                      .col-6
                        label.form-label End Date
                        DatePicker(v-model="review.review_end")
                  .reviews__card--internal.p-y-1
                    .row
                      .col-md-12
                        h4
                          b Material Business Changes
                        p List any changes to your business processes, key vendors, and/or key employees during the Review Period
                      .col-12
                        VueEditor(v-model="review.material_business_changes" :editor-toolbar="customToolbar")
                  .p-y-1
                    .row
                      .col-md-12
                        h4
                          b Material Regulatory Changes
                        p List any regulatory changes that impacted you during the Review Period and how the business responded.
                      .col-6
                        label.form-label Change
                        textarea.form-control(v-model="review.regulatory_changes[0].change" type="text" placeholder="Describe the change")
                      .col-6
                        label.form-label Response
                        textarea.form-control(v-model="review.regulatory_changes[1].change" type="text" placeholder="Describe the response")
                  .white-card-body.p-y-1
                    .d-flex.justify-content-end
                      button.btn.btn-default.float-end(@click="saveGeneral") Save
                      button.btn.btn-dark.float-end Mark Complete
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import { VueEditor } from "vue2-editor"
import ReviewsList from "./components/ReviewsList";

export default {
  props: ['annualId'],
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
    })
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
      updateAnnual: 'annual/updateReview',
      getCurrentReviewReview: 'annual/getCurrentReview'
    }),
    async saveGeneral () {
      const review = this.review
      const data = {
        id: review.id,
        review_start: review.review_start,
        review_end: review.review_end,
        regulatory_changes_attributes: review.regulatory_changes,
        material_business_changes: review.material_business_changes
      }
      try {
        await this.updateAnnual(data)
        this.makeToast('Success', "Saved changes to annual review.")
        await this.getCurrentReviewReview(this.annualId)
      } catch (error) {
        this.makeToast('Error', error.message)
      }
    },
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    }
  }
}
</script>
