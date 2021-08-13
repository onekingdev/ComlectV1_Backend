<template lang="pug">
  div.chart-wrapper
    apexchart(width="100%" height="250px" type="bar" :options="options" :series="series")
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
            id: 'vuechart-example',
            toolbar: {
              show: false,
            },
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
            ],
            labels: {
              style: {
                fontSize: '12px',
                fontFamily: 'Public Sans, sans-serif',
                fontWeight: '600',
                colors: ['#A2A3A9', '#A2A3A9', '#A2A3A9', '#A2A3A9', '#A2A3A9', '#A2A3A9', '#A2A3A9', '#A2A3A9', '#A2A3A9', '#A2A3A9', '#A2A3A9', '#A2A3A9'],
                cssClass: 'apexcharts-xaxis-label',
              },
            }
          },
          yaxis: {
            // title: {
            //   text: 'Growth',
            // },
            labels: {
              formatter: function (y) {
                return  y.toFixed(0) > 1000 ? "$" + y.toFixed(0).replace(/0*$/,"") + "k": "$" + y.toFixed(0).replace(/0*$/,"")
              },
              style: {
                fontSize: '12px',
                fontFamily: 'Public Sans, sans-serif',
                fontWeight: '600',
                colors: ['#A2A3A9'],
                cssClass: 'apexcharts-yaxis-label',
              },
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
          name: '',
          data: [5000, 1000, 14000, 300, 200, 1000, 0.2, 1000, 5000, 0, 0, 12000]
        }],
      }
    },
  };
</script>

<style scoped>
  .chart-wrapper {
    /*display: flex;*/
    /*align-items: center;*/
    /*justify-content: center;*/
  }
</style>
