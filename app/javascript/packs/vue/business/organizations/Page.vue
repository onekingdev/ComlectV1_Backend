<template lang="pug">
  div.p-x-40.p-y-20
    .card.m-b-20
      .card-title.p-20
        h2.card-title__name Access Persons
        .card-title__actions
          button.btn.btn.btn-default.mr-3 Export
          button.btn.link View all
      .card-body.white-card-body
        Loading
        AccessPersonTable(v-if="!loading && accessPersons.length" :users="accessPersons")
        .row.h-100(v-if="!accessPersons.length && !loading")
          .col.h-100.text-center
            EmptyState

    .card.m-b-20
      .card-title.p-20
        h2.card-title__name Terminated Employees
        .card-title__actions
          button.btn.btn.btn-default.mr-3 Export
          button.btn.link View all
      .card-body.white-card-body
        Loading
        TerminatedEmployees(v-if="!loading && terminatedEmployees.length" :users="terminatedEmployees")
        .row.h-100(v-if="!terminatedEmployees.length && !loading")
          .col.h-100.text-center
            EmptyState

    .card
      .card-title.p-20
        h2.card-title__name Resignations
        .card-title__actions
          button.btn.btn.btn-default.mr-3 Export
          button.btn.link View all
      .card-body.white-card-body
        Loading
        Resignations(v-if="!loading && resignations.length" :users="resignations")
        .row.h-100(v-if="!resignations.length && !loading")
          .col.h-100.text-center
            EmptyState
</template>

<script>
import Loading from '@/common/Loading/Loading'
import AccessPersonTable from "./components/AccessPerson/Table"
import TerminatedEmployees from "./components/TerminatedEmployees"
import Resignations from "./components/Resignations"

export default {
  components: {
    Loading,
    AccessPersonTable,
    TerminatedEmployees,
    Resignations,
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
      terminatedEmployees: [
        {
          id: 1,
          first_name: 'Bradly',
          last_name: 'Hudson',
          email: 'email@example.com',
          role: 'admin',
          reason: 'Termination',
          accessPerson: '-',
          startDate: '25.06.2021',
          endDate: '29.06.2021',
          status: true,
          state: 'Arizona, USA'
        },
        {
          id: 2,
          first_name: 'Jonson',
          last_name: 'Baby',
          email: 'email@example.com',
          role: 'trusted',
          reason: 'Termination',
          accessPerson: '-',
          startDate: '25.06.2021',
          endDate: '29.06.2021',
          status: true,
          state: 'California, USA'
        },
        {
          id: 3,
          first_name: 'Richard',
          last_name: 'Brenson',
          email: 'email@example.com',
          role: 'trusted',
          reason: 'Termination',
          accessPerson: '-',
          startDate: '25.06.2021',
          endDate: '29.06.2021',
          status: false,
          state: 'New York, USA'
        }
      ],
      resignations: [
        {
          id: 1,
          first_name: 'Bradly',
          last_name: 'Hudson',
          email: 'email@example.com',
          role: 'admin',
          reason: 'Termination',
          accessPerson: '-',
          startDate: '25.06.2021',
          endDate: '29.06.2021',
          status: true,
          state: 'Arizona, USA'
        },
        {
          id: 2,
          first_name: 'Jonson',
          last_name: 'Baby',
          email: 'email@example.com',
          role: 'trusted',
          reason: 'Termination',
          accessPerson: '-',
          startDate: '25.06.2021',
          endDate: '29.06.2021',
          status: true,
          state: 'California, USA'
        },
        {
          id: 3,
          first_name: 'Richard',
          last_name: 'Brenson',
          email: 'email@example.com',
          role: 'trusted',
          reason: 'Termination',
          accessPerson: '-',
          startDate: '25.06.2021',
          endDate: '29.06.2021',
          status: false,
          state: 'New York, USA'
        },
        {
          id: 4,
          first_name: 'Richarddsadas',
          last_name: 'Brensondsadasd',
          email: 'email@example.com',
          role: 'trusted',
          reason: 'Termination',
          accessPerson: '-',
          startDate: '25.06.2021',
          endDate: '29.06.2021',
          status: false,
          state: 'New York, USA'
        },
        {
          id: 5,
          first_name: 'Richard sadasdasd',
          last_name: 'Brensonasdasdsad',
          email: 'email@example.com',
          role: 'trusted',
          reason: 'Termination',
          accessPerson: '-',
          startDate: '25.06.2021',
          endDate: '29.06.2021',
          status: false,
          state: 'New York, USA'
        }
      ]
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
