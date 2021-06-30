<template lang="pug">
  div
    Loading
    .card
      .card-title.p-3.mb-0
        h3.mb-0 Payments
      .card-body.white-card-body
        .payments
          .payments__item
            p.mb-1 This month (Feb 2021)
            h3 $200
          .payments__item
            p.mb-1 Upcoming (Next 30 Days)
            h3 $400
          .payments__item
            p.mb-1 YTD
            h3 $500
          .payments__item
            p.mb-1 Total (all Time)
            h3 $12,000
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
  .payments {
    display: flex;
  }
  .payments__item {
    margin-top: 1rem;
    margin-bottom: 1rem;
    padding: 1rem;
  }
  .payments__item:not(:last-child) {
    border-right: solid 1px black;
  }
</style>
