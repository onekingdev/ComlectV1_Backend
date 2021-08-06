<template lang="pug">
  div.chart-wrapper
    apexchart(height="220" type="bar" :options="options" :series="series")
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
              "Spent",
              "Annual Budget",
            ]
          },
          yaxis: {
            // title: {
            //   text: 'Growth',
            // },
            labels: {
              formatter: function (y) {
                return  y.toFixed(0) > 1000 ? "$" + y.toFixed(0).replace(/0*$/,"") + "k": "$" + y.toFixed(0).replace(/0*$/,"")
              }
            }
          },
          plotOptions: {
            bar: {
              horizontal: false,
              columnWidth: '15%',
              endingShape: 'rounded'
            },
          },
          dataLabels: {
            enabled: false
          },
          // title: {
          //   text: 'Monthly Stock Pricing',
          //   align: 'center',
          //   style: {
          //     fontSize:  '20px',
          //   },
          // },
          colors: ['#1ab27f']
        },
        series: [{
          // name: 'series-1',
          data: [5, 10]
        }],
      }
    },
  };
</script>

<style scoped>
  div.chart-wrapper {
    /*display: flex;*/
    /*align-items: center;*/
    /*justify-content: center;*/
  }
</style>
