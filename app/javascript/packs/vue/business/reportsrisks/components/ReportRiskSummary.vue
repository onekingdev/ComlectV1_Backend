<template lang="pug">
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
</template>

<script>
    export default {
      props: ['riskSummary']
    }
</script>

<style scoped>

</style>
