<template lang="pug">
  div
    Loading
    .card.m-b-20
      .card-title.p-20
        h2.card-title__name Annual Budget
        .card-title__actions
          button.btn.btn.btn-default.mr-3 Edit
      .card-body.white-card-body
        .card-body
          .chart
            .d-flex.justify-content-end.mb-3
              p.mb-0
                b Left:&nbsp;
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
