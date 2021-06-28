<template lang="pug">
  div
    .container-fluid
      .row.mb-3
        .col-12
          .card
            .card-title
              .d-flex.justify-content-between.pb-1.pt-3.px-3
                div
                  h2 Access Persons
                div
                  button.btn.btn.btn-default.mr-3 Export
                  button.btn.link View all
            .card-body.white-card-body
              Loading
              div(v-if="!loading")
                .col-12
                  .table(v-if="!loading && accessPersons.length === 0")
                    .table__row
                      .table__cell.text-center
                        h3 Access persons not exist
      .row.mb-3
        .col-12
          .card
            .card-title
              .d-flex.justify-content-between.pb-1.pt-3.px-3
                div
                  h2 Terminated Employees
                div
                  button.btn.btn.btn-default.mr-3 Export
                  button.btn.link View all
            .card-body.white-card-body
              Loading
              div(v-if="!loading")
                .col-12
                  .table(v-if="!loading && terminatedEmployees.length === 0")
                    .table__row
                      .table__cell.text-center
                        h3 Terminated employees not exist
      .row
        .col-12
          .card
            .card-title
              .d-flex.justify-content-between.pb-1.pt-3.px-3
                div
                  h2 Resignations
                div
                  button.btn.btn.btn-default.mr-3 Export
                  button.btn.link View all
            .card-body.white-card-body
              Loading
              div(v-if="!loading")
                .col-12
                  .table(v-if="!loading && resignations.length === 0")
                    .table__row
                      .table__cell.text-center
                        h3 Resignations not exist
</template>

<script>
import Loading from '@/common/Loading/Loading'
// import ReviewTable from "./components/ReviewTable"

export default {
  components: {
    Loading,
    // ReviewTable,
  },
  data() {
    return {
      accessPersons: [] ,
      terminatedEmployees: [],
      resignations: []
    }
  },
  computed: {
    loading() {
      return this.$store.getters.loading;
    },
  },
  methods: {

  }
}
</script>

<style scoped>

</style>
