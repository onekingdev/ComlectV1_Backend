<template lang="pug">
  .card-body.white-card-body.p-0
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
            td.text-right {{ riskSummary.hight.percent ? riskSummary.hight.percent : 0 }}%

          tr
            td.text-warning
              b-icon.mr-2(icon="exclamation-triangle-fill" variant="warning")
              | Medium
            td.text-right {{ riskSummary.medium.count }}
            td.text-right {{ riskSummary.medium.percent ? riskSummary.medium.percent : 0 }}%

          tr
            td.text-success
              b-icon.mr-2(icon="exclamation-triangle-fill" variant="success")
              | Low
            td.text-right {{ riskSummary.low.count }}
            td.text-right {{ riskSummary.low.percent ? riskSummary.low.percent : 0 }}%
          tr
            td
              b Total
            td.text-right {{ riskSummary.total.count }}
            td.text-right {{ riskSummary.total.percent }}%
</template>

<script>
    export default {
      computed: {
        loading() {
          return this.$store.getters.loading;
        },
        riskList() {
          return this.$store.getters.risksList
        },
        riskSummary() {
          const riskList = this.riskList
          const totalLength = riskList.length;
          const totalPercent = totalLength ? 100 : 0;
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
    }
</script>

<style scoped>

</style>
