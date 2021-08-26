<template lang="pug">
  div
    .row
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 Role and Permissions
          .card-body.white-card-body.px-3.px-xl-5
            // .row
            //   .col
            //     b-tabs(content-class='mt-3')
            //       b-tab(active)
            //         template(#title)
            //           | Directory&nbsp;
            //           span (7)
            .row.my-3
              .col
                h4 Clients
            //.div.d-none
            //  .row.my-3
            //    .col-md-8
            //      SearchItem(:users="filteredUsersActive" @searchingConfirmed="searching")
            //    .col-md-4
            //      .d-flex.justify-content-end
            //        button.btn.btn-default.mr-2 Export
            //        button.btn.btn-dark Add User
            .row
              .col-12
                Loading
                RolesTable(v-if="!loading" :users="users")
                EmptyState(v-if="!users.length")
                  // b-tab(title='Disabled Users')
                  //   .div
                  //     .row.my-3
                  //       .col-md-8
                  //         SearchItem(:users="filteredUsersDisabled" @searchingConfirmed="searching")
                  //   .row
                  //     .col-12
                  //       Loading
                  //       RolesTable(v-if="!loading" :users="filteredUsersDisabled")
                  //       table.table(v-if="!filteredUsersDisabled.length")
                  //         tbody
                  //           tr
                  //             td.text-center(colspan=5)
                  //               h4.py-2 No Users
                  // b-tab(title='Activity' disabled)
                  //   p I'm a disabled tab!
</template>

<script>
  import { mapGetters, mapActions } from "vuex"
  import Loading from '@/common/Loading/Loading'
  import RolesTable from "./components/RolesTable";
  // import SearchItem from "./components/SearchItem";

  export default {
    components: {
      // SearchItem,
      Loading,
      RolesTable,
    },
    data() {
      return {
        // searchInput: '',
      };
    },
    methods: {
      ...mapActions({
        getEmployeesSpecialists: 'settings/getEmployeesSpecialists',
      }),
      // searching (value) {
      //   this.searchInput = value
      // },
    },
    computed: {
      ...mapGetters({
        loading: 'loading',
        // users: 'settings/employeesSpecialists'
      }),
      users() {
        return [
          {
            id: 1,
            first_name: 'Bradly',
            last_name: 'Hudson',
            role: 'admin',
            status: true,
            state: 'Arizona, USA',
            specialist: {
              first_name: 'Bradly',
              last_name: 'Hudson',
              rate: '$25',
              availability: 'available',
              total_jobs: 10,
            }
          },
          {
            id: 2,
            first_name: 'Jonson',
            last_name: 'Baby',
            role: 'trusted',
            status: true,
            state: 'California, USA',
            specialist: {
              first_name: 'Jonson',
              last_name: 'Baby',
              rate: '$35',
              availability: 'not available',
              total_jobs: 20,
            }
          },
          {
            id: 3,
            first_name: 'Richard',
            last_name: 'Brenson',
            role: 'trusted',
            status: false,
            state: 'New York, USA',
            specialist: {
              first_name: 'Richard',
              last_name: 'Brenson',
              rate: '$45',
              availability: 'available',
              total_jobs: 30,
            }
          }
        ]
      },
      // filteredUsers () {
      //   return this.users.filter(user => {
      //     const fullName = `${user.first_name} ${user.last_name}`
      //     return fullName?.toLowerCase().includes(this.searchInput.toLowerCase())
      //   })
      // },
      // filteredUsersActive () {
      //   return this.filteredUsers.filter(user => user.status === true )
      // },
      // filteredUsersDisabled () {
      //   return this.filteredUsers.filter(user => user.status === false )
      // }
    },
    async mounted() {
      try {
        const result = await this.getEmployeesSpecialists()
        if(result) console.log('result', result)
      } catch (error) {
        console.error(error)
      }
    },
  };
</script>
