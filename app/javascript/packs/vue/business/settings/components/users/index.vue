<template lang="pug">
  div
    .row
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
                    .col-lg-8
                      SearchItem(:users="filteredUsersActive" @searchingConfirmed="searching")
                    .col-lg-4
                      .d-flex.justify-content-end
                        button.btn.btn-default.mr-2 Download
                        UserModalAddEdit(:userLimit="userLimit" @saved="userAdded" @editPlan="showModal")
                          button.btn.btn-dark Add User
                        PlanModalEdit(:plan="plan")
                          button.d-none(ref="editPlanModal") Add User

                UsersTable(:users="filteredUsersActive")
                Loading
                EmptyState(v-if="!filteredUsersActive.length")
              b-tab(title='Disabled Users')
                template(#title)
                  | Disabled&nbsp;
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
                UsersTable(v-if="!loading" :users="filteredUsersDisabled" :disabled="true")
                Loading
                EmptyState(v-if="!filteredUsersDisabled.length && !loading")
              //b-tab(title='Activity' disabled)
              //  p I'm a disabled tab!
</template>

<script>
  import { mapGetters, mapActions } from "vuex"
  import Loading from '@/common/Loading/Loading'
  import UsersTable from "./components/UsersTable";
  import SearchItem from "./components/SearchItem";
  import UserModalAddEdit from "@/common/Users/modals/UserModalAddEdit";
  import PlanModalEdit from "@/business/settings/components/subscriptions/modals/PlanModalEdit";

  export default {
    components: {
      UserModalAddEdit,
      Loading,
      UsersTable,
      SearchItem,
      PlanModalEdit,
    },
    data() {
      return {
        searchInput: '',
        userLimit: null,
        plan: {
          id: 1,
          name: 'Team Plan',
          users: '10',
          billinPeriod: 'monthly',
          monthCoast: '100$/month',
          paymentCardType: 'Visa',
          paymentCard: '**** **** **** 4242',
          nextPaymentDate: 'October 25, 2021',

          coastMonthly: 145,
          coastAnnually: 1500,
          usersCount: 10,
          additionalUserMonthly: 15,
          additionalUserAnnually: 120,
        }
      };
    },
    methods: {
      ...mapActions({
        getEmployees: 'settings/getEmployees',
        getSeatCount: 'settings/getAvailableSeatsCount'
      }),
      searching (value) {
        this.searchInput = value
      },
      userAdded () {

      },
      showModal() {
        this.$refs.editPlanModal.click()
      },
    },
    computed: {
      ...mapGetters({
        loading: 'loading',
        users: 'settings/employees'
      }),
      filteredUsers () {
        const users = this.users
        return users.filter(user => {
          const fullName = `${user.first_name} ${user.last_name}`
          return fullName?.toLowerCase().includes(this.searchInput.toLowerCase())
        })
      },
      filteredUsersActive () {
        return this.filteredUsers.filter(user => user.active === true )
      },
      filteredUsersDisabled () {
        return this.filteredUsers.filter(user => user.active === false )
      }
    },
    async mounted() {
      try {
        await this.getEmployees()
        const result = await this.getSeatCount()
        if(result) this.userLimit = result.count
      } catch (error) {
        console.error(error)
      }
    },
  };
</script>
