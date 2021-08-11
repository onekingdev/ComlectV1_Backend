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
          stroke: {
            show: true,
            width: 2,
          },
          plotOptions: {
            bar: {
              horizontal: false,
              columnWidth: '20%',
              endingShape: 'rounded'
            },
          },
          dataLabels: {
            enabled: false
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
          data: [5000, 1000, 14000, 300, 200, 1000, 0.2, 1000, 5000, 0, 0, 12000]
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
