$(document).ready(function() {
  if (typeof(annual_budget_chart_columns) != "undefined") {
    c3.generate({
      bindto: document.getElementById('annual_budget_chart'),
      data: {
        columns: annual_budget_chart_columns,
        type: 'bar',
        groups: [["Spent", "Annual Budget"]],
        colors: {
          "Spent": '#ffcc01',
          "Annual Budget": "#4EEDF0"
        }
      },
      bar: {
        width: {
          ratio: 0.35 // this makes bar width 50% of length between ticks
        }
        // or
        //width: 100 // this makes bar width 100px
      },
      axis: {
        y: {
          tick: {
            format: d3.format("$,s")
          }
        }
      },
      grid: {
        y: { show: true }
      },
      tooltip: {
        show: false
      }
    });
  }

  if (typeof(compliance_spend_data) != "undefined") {
    c3.generate({
      bindto: document.getElementById("compliance_spend_chart"),
      data: {
        columns: [
          compliance_spend_data,
          ['x', "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        ],
        type: 'spline',
        colors: {
          "Spent": "#ffcc01"
        }
      },
      axis: {
        x: {
          type: 'category',
          categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        }
      },
      grid: {
        y: { show: true }
      },
      legend: {
        show: false
      }
    })
  }
});