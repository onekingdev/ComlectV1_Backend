<template lang="pug">
  div
    Loading
    .card
      .card-title.p-3.mb-0
        h3.mb-0 Compilance Spend
      .card-body.white-card-body
        .card-body
          .chart
            .d-flex.justify-content-end
              p.mb-0
                b Ytd:
                span $24,560
            Chart
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import Chart from "./chart";

  export default {
    components: {
      Chart,
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
