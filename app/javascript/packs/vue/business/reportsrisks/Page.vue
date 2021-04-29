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
              .card-body.white-card-body
                .card-header
                  h3.m-y-0 Risk Heatmap
                .card-body
                  .risks-heatmap
                    .risks-heatmap__impact Impact
                    .risks-heatmap__box-row(v-for='(row, rowIdx) in riskHeatmap' :key='rowIdx')
                      .risks-heatmap__box-name {{ showLevel(rowIdx) }}
                      .risks-heatmap__box(v-for='(column, colIdx) in row' :key='colIdx' :class="riskLevelClass(rowIdx, colIdx)") {{ column }}
                    .risks-heatmap__box-row
                      .risks-heatmap__box-name
                      .risks-heatmap__box-name.justify-content-center Low
                      .risks-heatmap__box-name.justify-content-center Medium
                      .risks-heatmap__box-name.justify-content-center High
                    .risks-heatmap__likelihood Likelihood
            .col-md-5.col-12
              .card-body.white-card-body
                .card-header
                  h3.m-y-0 Risk Summary
                .card-body
                  table.table
                    thead
                      tr
                        th Risk Level
                          b-icon.ml-2(icon='chevron-expand')
                        th.text-right Count
                          b-icon.ml-2(icon='chevron-expand')
                        th.text-right %
                          b-icon.ml-2(icon='chevron-expand')
                    tbody
                      tr
                        td.text-danger
                          b-icon.mr-2(icon="exclamation-triangle-fill" variant="danger")
                          | Hight
                        td.text-right {{ riskSummary.hight.count }}
                        td.text-right {{ riskSummary.hight.percent }}%

                      tr
                        td.text-warning
                          b-icon.mr-2(icon="exclamation-triangle-fill" variant="warning")
                          | Medium
                        td.text-right {{ riskSummary.medium.count }}
                        td.text-right {{ riskSummary.medium.percent }}%

                      tr
                        td.text-success
                          b-icon.mr-2(icon="exclamation-triangle-fill" variant="success")
                          | Low
                        td.text-right {{ riskSummary.low.count }}
                        td.text-right {{ riskSummary.low.percent }}%
                      tr
                        td
                          b Total
                        td.text-right {{ riskSummary.total.count }}
                        td.text-right {{ riskSummary.total.percent }}%
          .row
            .col
              .card-body.white-card-body
                RisksTable

</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import RisksTable from '../riskregister/RisksTable.vue'

  export default {
    components: {
      Loading,
      RisksTable
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

