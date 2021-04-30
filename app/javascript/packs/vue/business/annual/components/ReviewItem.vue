<template lang="pug">
  tr
    td
      a.link(:href="`/business/annual_reviews/${item.id}`")
        | {{ item.id }}-{{ item.year }} Annual Review
    td
      <!--.reviews-table__progress.d-flex-->
        <!--.reviews-table__progress-numbers-->
          <!--| {{ item.progress }}/{{ item.review_categories.length }}-->
        <!--.reviews-table__progress-bar.d-flex-->
          <!--.reviews-table__progress-bar__item(:style="`width: ${progressWidth}%`")-->
      .reviews-table__progress.d-flex.align-items-center
        .reviews-table__progress-numbers.mr-2(:class="progressWidth === 100 ? 'text-success' : 'text-dark'") {{ item.progress }}/{{ item.review_categories.length }}
        b-progress.w-100(:value="progressWidth" :max="100" show-progress variant="success")
    td.text-right {{ item.findings }}
    td.text-right {{ dateToHuman(item.updated_at) }}
    td.text-right {{ dateToHuman(item.created_at) }}
    td.text-right
      a.link(:href="item.pdf_url")
        b-icon.mr-2(icon='box-arrow-down')
        | Download
    td.text-right
      .actions
        b-dropdown(size="sm" variant="light" class="m-0 p-0" right)
          template(#button-content)
            b-icon(icon="three-dots")
          b-dropdown-item(:href="`/business/annual_reviews/${item.id}`") Edit
          b-dropdown-item(@click="duplicateReview(item.id)") Dublicate
          AnnualModalDelete(@deleteConfirmed="deleteReview(item.id)", :inline="false")
            b-dropdown-item.delete Delete
</template>

<script>
import { DateTime } from 'luxon'
import AnnualModalDelete from '../modals/AnnualModalDelete'

export default {
  name: "ReviewItem",
  props: ['item'],
  components: {
    AnnualModalDelete
  },
  computed: {
    progressWidth() {
      const part = 100 / +this.item.review_categories.length
      // return +part * +this.item.progress
      return Math.floor(Math.random() * 100)
    }
  },
  methods: {
    dateToHuman(value) {
      const date = DateTime.fromJSDate(new Date(value))
      if (!date.invalid) {
        return date.toFormat('dd/MM/yyyy')
      }
      if (date.invalid) {
        return value
      }
    },
    duplicateReview(reviewId){
      this.$store.dispatch('annual/duplicateReview', { id: reviewId })
        .then(response => this.toast('Success', `The annual review has been duplicated! ${response.id}`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    },
    deleteReview(reviewId){
      this.$store.dispatch('annual/deleteReview', { id: reviewId })
        .then(response => this.toast('Success', `The annual review has been deleted! ${response.id}`))
        .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
    }
  }
}
</script>

<style scoped>

</style>
