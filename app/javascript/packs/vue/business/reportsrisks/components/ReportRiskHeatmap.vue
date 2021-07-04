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
      data() {
        return {
          levelOptionsImpact: ['High', 'Medium', 'Low'],
        }
      },
      methods: {
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
          let riskHeatmapArray = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
          this.riskList.forEach(function (risk) {
            let counter = riskHeatmapArray[risk.impact][risk.likelihood]
            counter = counter + 1
            riskHeatmapArray[risk.impact][risk.likelihood] = counter
          })
          return riskHeatmapArray
        },
      }
    }
</script>

<style scoped>

</style>
