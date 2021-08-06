<template lang="pug">
  div
    Loading
    .card.m-b-20
      .card-title.p-20
        h2.card-title__name Compilance Spend
      .card-body.white-card-body
        .card-body
          .chart
            .d-flex.justify-content-end.mb-3
              p.mb-0
                b Ytd:&nbsp;
                span $24,560
            CompilanceSpendChart
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import CompilanceSpendChart from "./CompilanceSpendChart";

  export default {
    components: {
      CompilanceSpendChart,
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
