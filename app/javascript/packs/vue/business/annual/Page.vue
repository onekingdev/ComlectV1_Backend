<template lang="pug">
  div
    .container
      .row
        .col-12
          .row.p-x-1
            .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1.p-x-0
              div
                h2 Internal Reviews
              div
                AnnualModalCreate()
                  button.btn.btn-dark.float-end New Review
    .card-body.white-card-body
      .container
        .row
          .col-12
            b-alert.mb-2(show variant="primary" dismissible)
              .d-flex.justify-content-between.align-items-center
                .d-block
                  h4 Key Regulatory Developments 2021
                  p.mb-0 New regulatory changes can have an impact on your policies and procedures.
                b-button.ml-auto(type="button" variant="light") View
            p Rule 206(4)-7 under the Adviser Act and Rule 38a-1 under the Company Act require that you conduct an annual review of your compliance program no less than annually. Your last completed Annual Review was submitted on&nbps;
              a.link(href="#") 7/24/2020
        .row
          .col-12
            Loading
            ReviewTable(v-if="!loading" :reviews="reviews")
            table.table.reviews-table(v-if="!reviews.length && !loading")
              tbody
                tr
                  td.text-center
                    h3 Annual Reviews not exist
</template>

<script>
import { mapGetters } from "vuex"
import Loading from '@/common/Loading/Loading'
import AnnualModalCreate from "./modals/AnnualModalCreate"
import ReviewTable from "./components/ReviewTable"

export default {
  components: {
    Loading,
    ReviewTable,
    AnnualModalCreate
  },
  computed: {
    loading() {
      return this.$store.getters.loading;
    },
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

<style scoped>
  @import "./styles.css";
</style>

<style>
  /* ALERTS*/
  .alert-primary {
    color: #303132;
    background-color: #ecf4ff;
    border-color: transparent;
    /*border-left-color: #0479ff;*/
    border-radius: 0;
    border-width: 0;
    box-shadow: inset 5px 0 0 #0479ff;
  }
  .alert-dismissible .close {
    top: 10px;
    font-size: 1.8rem;
  }
</style>
