<template lang="pug">
  div
    .container
      .row
        .col-12
          .row.p-x-1
            .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
              div
                h2: b Internal Reviews
              div
                AnnualModalCreate()
                  button.btn.btn-dark.float-end New Review
    .card-body.white-card-body
      .container
        .row
          .col-12
            ReviewTable(:reviews="reviews")
</template>

<script>
import { mapGetters } from "vuex"
import AnnualModalCreate from "./modals/AnnualModalCreate"
import ReviewTable from "./components/ReviewTable"

export default {
  components: {
    ReviewTable,
    AnnualModalCreate
  },
  computed: {
    ...mapGetters({
      reviews: 'annual/reviews'
    })
  },
  async mounted () {
    try {
      await this.$store.dispatch('annual/getReviews')
    } catch (error) {
      this.makeToast('Error', error.message)
    }
  },
  methods: {
    makeToast(title, str) {
      this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
    }
  }
}
</script>
