<template lang="pug">
  div
    Loading
    .card
      .card-title.p-3.mb-0
        h3.mb-0 Compilance Spend
      .card-body.white-card-body
        .card-body
          .chart
            .d-flex.justify-content-end.mb-3
              p.mb-0
                b Ytd:
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
