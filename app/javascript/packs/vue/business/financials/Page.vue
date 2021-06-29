<template lang="pug">
  div
    .container-fluid
      .row
        .col-12
          .row.p-x-1
            .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
              div
                h2: b {{ pageTitle }}
          .row(v-if="loading")
            .col
              .card-body.white-card-body
                Loading
          .row(v-if="!loading")
            .col-lg-7.col-12.m-b-2
              ReportRiskHeatmap
            .col-lg-5.col-12.m-b-2
              ReportRiskSummary
          .row
            .col
              .card-body.white-card-body
                RisksTable

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import RisksTable from '../riskregister/RisksTable.vue'
  import ReportRiskHeatmap from "./components/ReportRiskHeatmap";
  import ReportRiskSummary from "./components/ReportRiskSummary";

  export default {
    components: {
      Loading,
      ReportRiskHeatmap,
      ReportRiskSummary,
      RisksTable,
    },
    created() {},
    data() {
      return {
        pageTitle: "Financials",
      }
    },
    methods: {

    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

