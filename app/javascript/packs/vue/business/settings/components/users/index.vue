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
                      span (7)
                    .row.my-3
                      .col-4
                        .position-relative
                          b-icon.icon-searh(icon='search')
                          input.form-control.form-control_search(type="text" placeholder="Search" v-model="searchInput", @keyup="searching")
                          button.btn-clear(v-if="isActive" @click="clearInput")
                            b-icon.icon-clear(icon='x-circle')
                      .col-4(v-if="filteredUsers.length !== 0 && searchInput")
                        p Found {{ filteredUsers.length }} {{ filteredUsers.length === 1 ? 'result' : 'results' }}
                      .col
                        .d-flex.justify-content-end
                          button.btn.btn-default.mr-2 Export
                          button.btn.btn-dark Add User
                    .row
                      .col-12
                        Loading
                        UsersTable(v-if="!loading" :users="filteredUsers")
                        table.table(v-if="!filteredUsers.length")
                          tbody
                            tr
                              td.text-center(colspan=5)
                                h4.py-2 No Users
                  b-tab(title='Disabled Users')
                    p I'm the second tab
                  b-tab(title='Activity' disabled)
                    p I'm a disabled tab!
</template>

<script>
  import Loading from '@/common/Loading/Loading'
  import UsersTable from "./components/UsersTable";

  export default {
    components: {
      Loading,
      UsersTable,
    },
    data() {
      return {
        searchInput: '',
        isActive: false,
      };
    },
    methods: {
      searching () {
        if(this.searchInput.length) this.isActive = true
        if(!this.searchInput.length) this.isActive = false
        this.$emit('searching', this.searchInput)
      },
      clearInput() {
        this.searchInput = ''
        this.isActive = false
        this.$emit('searching', this.searchInput)
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
      users() {
        return [{
          first_name: 'Holgaria',
          last_name: 'Bolgaria',
          email: 'holgaria@gmail.com',
          checked: true,
          access: false,
          created_at: '31/01/2017'
        }]
      },
      filteredUsers () {
        return this.users.filter(user => {
          const fullName = `${user.first_name} ${user.last_name}`
          return fullName?.toLowerCase().includes(this.searchInput.toLowerCase())
        })
      },
    },
    mounted() {

    },
  };
</script>
