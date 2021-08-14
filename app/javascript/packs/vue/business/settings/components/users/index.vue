<template lang="pug">
  div
    .row
      .col
        Loading
    .row(v-if='!loading')
      .col
        .card.settings__card
          .card-title.p-x-40
            h2.card-title__name Users
          .card-body.white-card-body.card-body_full-height.p-x-40
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
                        UserModalAddEdit
                          button.btn.btn-dark Add User
                Loading
                UsersTable(v-if="!loading" :users="filteredUsersActive")
                EmptyState(v-if="!filteredUsersActive.length")
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
                        UserModalAddEdit
                          button.btn.btn-dark Add User
                Loading
                UsersTable(v-if="!loading" :users="filteredUsersDisabled" :disabled="true")
                EmptyState(v-if="!filteredUsersDisabled.length")
              b-tab(title='Activity' disabled)
                p I'm a disabled tab!
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import UsersTable from "./components/UsersTable";
  import SearchItem from "./components/SearchItem";
  import UserModalAddEdit from "./modals/UserModalAddEdit";

  export default {
    components: {
      UserModalAddEdit,
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
            role: 'trusted',
            status: false,
            access: false,
            created_at: '2021-05-28T15:51:05.892Z',
            reason: 'Termination',
            disabled_at: '2021-07-28T15:51:05.892Z'
          },
          {
            first_name: 'Jason',
            last_name: 'Stetham',
            email: 'stetham@gmail.com',
            role: 'trusted',
            status: false,
            access: false,
            created_at: '2021-05-28T15:51:05.892Z',
            reason: 'Registration',
            disabled_at: '2021-07-28T15:51:05.892Z'
          },
          {
            first_name: 'Sandra ',
            last_name: 'Bullock',
            email: 'sandra111111111@gmail.com',
            role: 'trusted',
            status: true,
            access: false,
            created_at: '2021-05-28T15:51:05.892Z',
          },
          {
            first_name: 'Julia',
            last_name: 'Roberts',
            email: 'julia89099890970@gmail.com',
            role: 'admin',
            status: true,
            access: false,
            created_at: '2021-05-28T15:51:05.892Z',
          },
          {
            first_name: 'Robert',
            last_name: 'De Niro',
            email: 'robertdeniro@gmail.com',
            role: 'basic',
            status: true,
            access: true,
            created_at: '2021-05-28T15:51:05.892Z',
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
