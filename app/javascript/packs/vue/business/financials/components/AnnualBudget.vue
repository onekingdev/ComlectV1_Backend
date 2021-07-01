<template lang="pug">
  div
    Loading
    .card
      .card-title
        .d-flex.justify-content-between.pb-1.pt-3.px-3
          div
            h3.mb-0 Annual Budget
          div
            button.btn.btn.btn-default.mr-3 Edit
      .card-body.white-card-body
        .card-body
          .chart
            .d-flex.justify-content-end.mb-3
              p.mb-0
                b Left:
                span $4,000
            AnnualBudgetChart
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import AnnualBudgetChart from './AnnualBudgetChart'

  export default {
    components: {
      Loading,
      AnnualBudgetChart,
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
