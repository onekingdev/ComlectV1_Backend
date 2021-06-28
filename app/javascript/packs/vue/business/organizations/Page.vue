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
              AccessPersonTable(v-if="!loading && accessPersons.length" :users="accessPersons")
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
import AccessPersonTable from "./components/AccessPerson/Table"

export default {
  components: {
    Loading,
    AccessPersonTable,
  },
  data() {
    return {
      accessPersons: [
        {
          id: 1,
          first_name: 'Bradly',
          last_name: 'Hudson',
          email: 'email@example.com',
          role: 'admin',
          status: true,
          state: 'Arizona, USA'
        },
        {
          id: 2,
          first_name: 'Jonson',
          last_name: 'Baby',
          email: 'email@example.com',
          role: 'trusted',
          status: true,
          state: 'California, USA'
        },
        {
          id: 3,
          first_name: 'Richard',
          last_name: 'Brenson',
          email: 'email@example.com',
          role: 'trusted',
          status: false,
          state: 'New York, USA'
        }
      ] ,
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
