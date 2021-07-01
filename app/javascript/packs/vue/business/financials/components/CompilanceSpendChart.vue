<template lang="pug">
  div.chart-wrapper
    apexchart(width="770" height="220" type="bar" :options="options" :series="series")
</template>

<script>
  import VueApexCharts from 'vue-apexcharts'

  export default {
    components: {
      apexcharts: VueApexCharts,
    },
    data: function() {
      return {
        options: {
          chart: {
            id: 'vuechart-example'
          },
          xaxis: {
            categories: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "May",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Oct",
              "Nov",
              "Dec"
            ]
          },
          // title: {
          //   text: 'Monthly Stock Pricing',
          //   align: 'center',
          //   style: {
          //     fontSize:  '20px',
          //   },
          // },
          colors: ['#ffc900']
        },
        series: [{
          // name: 'series-1',
          data: [5.5, 10, 14, 3, 2, 1, 0.2, 1, 5, 0, 0, 12]
        }],
      }
    },
  };
</script>

<style scoped>
  div.chart-wrapper {
    display: flex;
    align-items: center;
    justify-content: center;
  }
</style>
