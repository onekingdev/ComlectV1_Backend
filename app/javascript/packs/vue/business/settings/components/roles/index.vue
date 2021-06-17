<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 Role and Permisssions
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
                h3 Specialists
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
                table.table(v-if="!users.length")
                  tbody
                    tr
                      td.text-center(colspan=5)
                        h4.py-2 No Users
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
      // searching (value) {
      //   this.searchInput = value
      // },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      users() {
        return [
          {
            id: 1,
            first_name: 'Bradly',
            last_name: 'Hudson',
            role: 'admin',
            status: true,
            state: 'Arizona, USA'
          },
          {
            id: 2,
            first_name: 'Jonson',
            last_name: 'Baby',
            role: 'trusted',
            status: true,
            state: 'California, USA'
          },
          {
            id: 3,
            first_name: 'Richard',
            last_name: 'Brenson',
            role: 'trusted',
            status: false,
            state: 'New York, USA'
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
    mounted() {

    },
  };
</script>
