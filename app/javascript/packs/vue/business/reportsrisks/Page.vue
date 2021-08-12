<template lang="pug">
  .page
    //.page-header
    //  h2.page-header__title {{ pageTitle }}
    .card-body.p-x-40
      //.row(v-if="loading")
      //  .col
      //    .card-body.white-card-body
      //      Loading
      .row(v-if="!loading")
        .col-lg-7.col-12.m-b-2
          ReportRiskHeatmap
        .col-lg-5.col-12.m-b-2
          ReportRiskSummary
      //.row
      //  .col
      //    .card-body.white-card-body
      //      RisksTable
</template>

<script>
  // import Loading from '@/common/Loading/Loading'
  // import RisksTable from '../riskregister/RisksTable.vue'
  import ReportRiskHeatmap from "./components/ReportRiskHeatmap";
  import ReportRiskSummary from "./components/ReportRiskSummary";

  export default {
    components: {
      //Loading,
      ReportRiskHeatmap,
      ReportRiskSummary,
      // RisksTable,
    },
    created() {},
    data() {
      return {
        pageTitle: "Reports",
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

