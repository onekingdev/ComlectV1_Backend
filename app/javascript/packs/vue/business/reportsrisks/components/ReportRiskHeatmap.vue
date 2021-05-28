<template lang="pug">
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
</template>

<script>
    export default {
      props: ['riskHeatmap']
    }
</script>

<style scoped>

</style>
