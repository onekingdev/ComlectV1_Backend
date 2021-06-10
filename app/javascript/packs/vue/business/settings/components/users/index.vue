<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card
          .card-title.px-3.px-xl-5.py-xl-4.mb-0
            h3.mb-0 Users
          .card-body.white-card-body.px-3.px-xl-5
            .row
              .col
                b-tabs(content-class='mt-3')
                  b-tab(active)
                    template(#title)
                      | Directory&nbsp;
                      span ({{ filteredUsersActive.length }})
                    .div
                      .row.my-3
                        .col-md-8
                          SearchItem(:users="filteredUsersActive" @searchingConfirmed="searching")
                        .col-md-4
                          .d-flex.justify-content-end
                            button.btn.btn-default.mr-2 Export
                            UserModalAdd
                              button.btn.btn-dark Add User
                    .row
                      .col-12
                        Loading
                        UsersTable(v-if="!loading" :users="filteredUsersActive")
                        table.table(v-if="!filteredUsersActive.length")
                          tbody
                            tr
                              td.text-center(colspan=5)
                                h4.py-2 No Users
                  b-tab(title='Disabled Users')
                    template(#title)
                      | Directory&nbsp;
                      span ({{ filteredUsersDisabled.length }})
                    .div
                      .row.my-3
                        .col-md-8
                          SearchItem(:users="filteredUsersDisabled" @searchingConfirmed="searching")
                        .col-md-4
                          .d-flex.justify-content-end
                            button.btn.btn-default.mr-2 Export
                            UserModalAdd
                              button.btn.btn-dark Add User
                    .row
                      .col-12
                        Loading
                        UsersTable(v-if="!loading" :users="filteredUsersDisabled" :disabled="true")
                        table.table(v-if="!filteredUsersDisabled.length")
                          tbody
                            tr
                              td.text-center(colspan=5)
                                h4.py-2 No Users
                  b-tab(title='Activity' disabled)
                    p I'm a disabled tab!
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import UsersTable from "./components/UsersTable";
  import SearchItem from "./components/SearchItem";
  import UserModalAdd from "./modals/UserModalAdd";

  export default {
    components: {
      UserModalAdd,
      Loading,
      UsersTable,
      SearchItem,
    },
    data() {
      return {
        searchInput: '',
      };
    },
    methods: {
      searching (value) {
        this.searchInput = value
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      users() {
        return [
          {
            first_name: 'Holgaria',
            last_name: 'Bolgaria',
            email: 'holgaria@gmail.com',
            checked: true,
            access: false,
            created_at: '31/01/2017',
            status: false,
            reason: 'Termination',
            disabled_at: '06/10/2021'
          },
          {
            first_name: 'Jason',
            last_name: 'Stetham',
            email: 'stetham@gmail.com',
            checked: true,
            access: false,
            created_at: '31/01/2017',
            status: false,
            reason: 'Registration',
            disabled_at: '06/10/2021'
          },
          {
            first_name: 'Sandra ',
            last_name: 'Bullock',
            email: 'sandra111111111@gmail.com',
            checked: true,
            access: false,
            created_at: '25/01/2017',
            status: true,
          },
          {
            first_name: 'Julia',
            last_name: 'Roberts',
            email: 'julia89099890970@gmail.com',
            checked: true,
            access: false,
            created_at: '27/01/2017',
            status: true
          }
        ]
      },
      filteredUsers () {
        return this.users.filter(user => {
          const fullName = `${user.first_name} ${user.last_name}`
          return fullName?.toLowerCase().includes(this.searchInput.toLowerCase())
        })
      },
      filteredUsersActive () {
        return this.filteredUsers.filter(user => user.status === true )
      },
      filteredUsersDisabled () {
        return this.filteredUsers.filter(user => user.status === false )
      }
    },
    mounted() {

    },
  };
</script>
