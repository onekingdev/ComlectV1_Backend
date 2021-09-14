<template lang="pug">
  .page
    .page-header
      h2.page-header__title Internal Reviews
      .page-header__actions
        AnnualModalCreate(:reviews="reviews")
          button.btn.btn-dark.float-end New Review
    .card-body.white-card-body.card-body_full-height.p-x-40
      Notifications.m-b-20(:notify="notify")
        a.btn.btn-default(href='https://www.sec.gov/exams', target="_blank") View
      p(v-show="!loading" v-html="noticeText")
      Loading
      ReviewTable(v-if="!loading && reviews.length" :reviews="reviews")
      .row.h-100(v-if="!reviews.length && !loading")
        .col.h-100.text-center
          EmptyState
</template>

<script>
import Notifications from "@/common/Notifications/Notifications";
import { mapGetters } from "vuex"
import Loading from '@/common/Loading/Loading'
import EmptyState from '@/common/EmptyState'
import AnnualModalCreate from "./modals/AnnualModalCreate"
import ReviewTable from "./components/ReviewTable"
import { DateTime } from 'luxon'

export default {
  components: {
    Notifications,
    Loading,
    EmptyState,
    ReviewTable,
    AnnualModalCreate
  },
  data() {
    return {
      notify: {
        show: 'show',
        mainText: 'Key Regulatory Developments 2021',
        subText: 'New regulatory changes can have an impact on your policies and procedures.',
        variant: 'primary',
        dismissible: false,
        icon: null,
        scale: 2,
        animation: ""
      }
    }
  },
  methods: {

  },
  computed: {
    loading() {
      return this.$store.getters.loading;
    },
    ...mapGetters({
      reviews: 'annual/reviews'
    }),
    recentCompletedReview() {
      const completedReview = this.reviews.filter(item => item.completed_at && item.complete)
      const orderCompeletedReview = completedReview.sort((reviewFirst, reviewSecond) => {
        if (reviewFirst.completed_at > reviewSecond.completed_at) {
          return -1
        }

        if (reviewFirst.completed_at < reviewSecond.completed_at) {
          return 1
        }
        
        return 0
      })
      return orderCompeletedReview.length > 0 ? orderCompeletedReview[0] : null
    },
    noticeText() {
      const text = "Rule 206(4)-7 under the Adviser Act requires that you conduct a review of your compliance program no less than annually."
      if (this.recentCompletedReview) {
        const date = DateTime.fromISO(this.recentCompletedReview.completed_at).toFormat('MM/dd/yyyy')
        return `${text} Your last completed internal review was on&nbsp; <a class="link" href="/business/annual_reviews/${this.recentCompletedReview.id}"> ${date}</a>`
      }

      return text
    }
  },
  async mounted () {
    try {
      await this.$store.dispatch('annual/getReviews')
    } catch (error) {
      this.toast('Error', error.message, true)
    }
  },
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
</style>
