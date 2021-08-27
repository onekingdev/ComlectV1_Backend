<template lang="pug">
  .page.p-x-40.p-y-20
    .card.m-b-20
      .card-title.p-x-20
        h2.card-title__name Access Persons
        .card-title__actions
          button.btn.btn.btn-default.mr-3 Download
          router-link.btn.link(to="/business/settings/users") View all
      .card-body.white-card-body
        AccessPersonTable(v-if="!loading && accessPersons.length" :users="accessPersons")
        Loading
        .row.h-100(v-if="!accessPersons.length && !loading")
          .col.h-100.text-center
            EmptyState

    .card.m-b-20
      .card-title.p-x-20
        h2.card-title__name Terminated Employees
        .card-title__actions
          button.btn.btn.btn-default.mr-3 Download
          router-link.btn.link(to="/business/settings/users") View all
      .card-body.white-card-body
        TerminatedEmployees(v-if="!loading && terminatedEmployees.length" :users="terminatedEmployees")
        Loading
        .row.h-100(v-if="!terminatedEmployees.length && !loading")
          .col.h-100.text-center
            EmptyState

    .card
      .card-title.p-x-20
        h2.card-title__name Resignations
        .card-title__actions
          button.btn.btn.btn-default.mr-3 Download
          router-link.btn.link(to="/business/settings/users") View all
      .card-body.white-card-body
        Resignations(v-if="!loading && resignations.length" :users="resignations")
        Loading
        .row.h-100(v-if="!resignations.length && !loading")
          .col.h-100.text-center
            EmptyState
</template>

<script>
import { mapGetters, mapActions } from "vuex"
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

    }
  },
  computed: {
    ...mapGetters({
      loading: 'loading',
      users: 'settings/employees'
    }),
    accessPersons() {
      return this.users.filter(user => user.access_person)
    },
    terminatedEmployees() {
      return this.users.filter(user => user.reason === 'termination')
    },
    resignations() {
      return this.users.filter(user => user.reason === 'resignation')
    }
  },
  methods: {
    ...mapActions({
      getEmployees: 'settings/getEmployees',
      // getSeatCount: 'settings/getAvailableSeatsCount'
    })
  },
  async mounted() {
    try {
      await this.getEmployees()
      // const result = await this.getSeatCount()
      // if(result) this.userLimit = result.count
    } catch (error) {
      console.error(error)
    }
  },
}
</script>

<style scoped>

</style>
