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
                    .risks-heatmap__box-row
                      .risks-heatmap__box-name Hight
                      .risks-heatmap__box.risks-heatmap__box_level-medium 0
                      .risks-heatmap__box.risks-heatmap__box_level-high 2
                      .risks-heatmap__box.risks-heatmap__box_level-high 3
                    .risks-heatmap__box-row
                      .risks-heatmap__box-name Medium
                      .risks-heatmap__box.risks-heatmap__box_level-medium 3
                      .risks-heatmap__box.risks-heatmap__box_level-medium 1
                      .risks-heatmap__box.risks-heatmap__box_level-medium 2
                    .risks-heatmap__box-row
                      .risks-heatmap__box-name Low
                      .risks-heatmap__box.risks-heatmap__box_level-low 0
                      .risks-heatmap__box.risks-heatmap__box_level-low 1
                      .risks-heatmap__box.risks-heatmap__box_level-medium 4
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
      };
    },
    methods: {
      getRisks(risk) {
        return this.risks
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      riskHeatmap() {

      },
      riskSummary() {
        const riskList = this.$store.getters.risksList
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
            percent: totalLength * (counterHigh / totalPercent)
          },
          medium: {
            count: counterMedium,
            percent: totalLength * (counterMedium / totalPercent)
          },
          low: {
            count: counterLow,
            percent: totalLength * (counterLow / totalPercent)
          },
          total: {
            count: totalLength,
            percent: totalPercent
          }
        }
      },
    },
    mounted() {
      function Create2DArray(rows, columns) {
        var x = new Array(rows);
        for (var i = 0; i < rows; i++) {
          x[i] = new Array(columns);
        }
        return x;
      }
      console.log(Create2DArray(2, [1,2]))
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

