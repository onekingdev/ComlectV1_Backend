<template lang="pug">
  div
    Loading
    .card
      .card-title.p-20
        h2.card-title__name Payments
      .card-body.white-card-body
        .payments
          .payments__item
            p.payments__name.mb-1 This month (Feb 2021)
            h3.payments__coast $200
          .payments__item
            p.payments__name.mb-1 Upcoming (Next 30 Days)
            h3.payments__coast $400
          .payments__item
            p.payments__name.mb-1 YTD
            h3.payments__coast $500
          .payments__item
            p.payments__name.mb-1 Total (All Time)
            h3.payments__coast $12,000
</template>

<script>
  import Loading from '@/common/Loading/Loading'

  export default {
    components: {
      Loading,
    },
    data() {
      return {

      }
    },
    methods: {

    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
  }
</script>

<style scoped>

</style>
