<template lang="pug">
  .page
    .card-body.p-x-40
      .row(v-if="!loading")
        .col-lg-7.col-12.m-b-2
          ReportRiskHeatmap
        .col-lg-5.col-12.m-b-2
          ReportRiskSummary
</template>

<script>
  import ReportRiskHeatmap from "./components/ReportRiskHeatmap"
  import ReportRiskSummary from "./components/ReportRiskSummary"

  export default {
    components: {
      ReportRiskHeatmap,
      ReportRiskSummary,
    },
    mounted() {
      this.$store
        .dispatch('getRisks')
        .then(response => {
          console.log('response', response)
        })
        .catch(error => {
          console.error(error)
        })
    },
    data() {
      return {
        pageTitle: "Reports",
      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading
      },
    },
  };
</script>

<style>
  @import "./styles.css"
</style>

