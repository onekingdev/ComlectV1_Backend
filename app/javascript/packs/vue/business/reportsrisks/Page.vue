<template lang="pug">
  div
    .container
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
          .row.mb-3(v-if="!loading")
            .col-md-7.col-12
              ReportRiskHeatmap(:riskHeatmap="riskHeatmap")
            .col-md-5.col-12
              ReportRisSummary(:riskSummary="riskSummary")
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
        pageTitle: "Reports",
        levelOptionsImpact: ['High', 'Medium', 'Low'],
      }
    },
    methods: {
      getRisks(risk) {
        return this.risks
      },
      showLevel(num) {
        return this.levelOptionsImpact[num]
      },
      riskLevelClass(row, col){
        let riskHeatmapArray = [
          ['risks-heatmap__box_level-low','risks-heatmap__box_level-low','risks-heatmap__box_level-medium'],
          ['risks-heatmap__box_level-medium','risks-heatmap__box_level-medium','risks-heatmap__box_level-medium'],
          ['risks-heatmap__box_level-medium','risks-heatmap__box_level-high','risks-heatmap__box_level-high']]
        return riskHeatmapArray[row][col]
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      riskList() {
        return this.$store.getters.risksList
      },
      riskHeatmap() {
        let riskHeatmapArray = [[0,0,0], [0,0,0], [0,0,0]]
        this.riskList.forEach(function (risk) {
          let counter = riskHeatmapArray[risk.impact][risk.likelihood]
          counter = counter + 1
          riskHeatmapArray[risk.impact][risk.likelihood] = counter
        })
        return riskHeatmapArray
      },
      riskSummary() {
        const riskList = this.riskList
        const totalLength = riskList.length;
        const totalPercent = 100;
        let counterHigh = 0;
        let counterMedium = 0;
        let counterLow = 0;
        riskList.forEach(function (record) {
          if(record.risk_level === 0) counterLow++
          if(record.risk_level === 1) counterMedium++
          if(record.risk_level === 2) counterHigh++
        })
        return {
          hight: {
            count: counterHigh,
            percent: totalPercent / totalLength * counterHigh
          },
          medium: {
            count: counterMedium,
            percent: totalPercent / totalLength * counterMedium
          },
          low: {
            count: counterLow,
            percent: totalPercent / totalLength * counterLow
          },
          total: {
            count: totalLength,
            percent: totalPercent
          }
        }
      },
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

