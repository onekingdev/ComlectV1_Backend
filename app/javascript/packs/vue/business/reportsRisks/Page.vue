<template lang="pug">
  div
    .container
      .row
        .col-12
          .row.p-x-1
            .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
              div
                h2: b {{ pageTitle }}
          .row.mb-3
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
            .col-md-4.col-12
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
                        td.text-right 31
                        td.text-right 31.3%
                      tr
                        td.text-warning
                          b-icon.mr-2(icon="exclamation-triangle-fill" variant="warning")
                          | Medium
                        td.text-right 31
                        td.text-right 31.3%
                      tr
                        td.text-success
                          b-icon.mr-2(icon="exclamation-triangle-fill" variant="success")
                          | Low
                        td.text-right 31
                        td.text-right 31.3%
                      tr
                        td
                          b Total
                        td.text-right 16
                        td.text-right 100%
          .row
            .col
              .card-body.white-card-body
                RisksTable

</template>

<script>
  import RisksTable from '../riskregister/RisksTable.vue'
  export default {
    components: {
      RisksTable
    },
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

    },
    mounted() {

    },
  };
</script>

<style>
  @import "./styles.css";
</style>

