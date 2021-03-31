<template lang="pug">
  div
    .container
      .row
        .col-12
          .row.p-x-1
            .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
              div
                h2: b Policies and Procedures
              div
                a.btn.btn-default.mr-3(href='#') Export
                PoliciesModalCreate(@saved="updateList")
                  button.btn.btn-dark.float-end New policy
          .row
            .col-12
              b-tabs(content-class="mt-0")
                b-tab(title="Compilance Manual" active)
                  .card-body.white-card-body
                    .container
                      //Loading
                      PolicyTable(:policies="filteredList", @searching="searching")
                      <!--Get(policies="/api/business/compliance_policies"): template(v-slot="{policies}"): table.table-->
                        <!--thead-->
                          <!--tr-->
                            <!--th Name-->
                            <!--th Status-->
                            <!--th Last Modified-->
                            <!--th Date Created-->
                            <!--th Risk Level-->
                            <!--th-->
                        <!--tbody-->
                          <!--tr(v-for="policy in policies" :key="policy.id")-->
                            <!--td ({{ policy.id }}) {{ policy.name }}-->
                            <!--td: .badge.badge-success {{ policy.status }}-->
                            <!--td {{ policy.updated_at}}-->
                            <!--td {{ policy.created_at}}-->
                            <!--td &hellip;-->
                            <!--td-->
                          <!--tr(v-if="!policies.length")-->
                            <!--td.text-center(colspan=6) No policies-->
                      .row
                        .col-12
                          .table(v-if="policiesListComputed.length !== 0")
                            .table__row
                              .table__cell.table__cell_title Name
                              .table__cell.table__cell_title.table__cell_clickable
                                | Status
                                b-icon.ml-2(icon='chevron-expand')
                              .table__cell.table__cell_title.table__cell_clickable
                                | Last Modified
                                b-icon.ml-2(icon='chevron-expand')
                              .table__cell.table__cell_title.table__cell_clickable
                                | Date Created
                                b-icon.ml-2(icon='chevron-expand')
                              .table__cell.table__cell_title.table__cell_clickable
                                | Risk Level
                                b-icon.ml-2(icon='chevron-expand')
                              .table__cell
                            nested-draggable(:policies='filteredList')
                          .table(v-else)
                            .table__row
                              .table__cell.text-center
                                h3 Policies not exist
                      <!--rawdisplayer(:value='policiesListComputed' title='List')-->
                      <!--.row-->
                        <!--.col-12-->
                          <!--h3 Draggable table-->
                          <!--table.table.table-striped-->
                            <!--thead.thead-dark-->
                              <!--tr-->
                                <!--th(scope='col') Id-->
                                <!--th(scope='col') Name-->
                                <!--th(scope='col') Sport-->
                            <!--draggable(v-model='policiesListComputed' tag='tbody')-->
                              <!--tr(v-for='item in policiesListComputed' :key='item.title')-->
                                <!--td(scope='row') {{ item.id }}-->
                                <!--td {{ item.name }}-->
                                <!--td {{ item.status }}-->
                        <!--rawdisplayer.col-3(:value='policiesListComputed' title='List')-->
                b-tab(title="Archive")
                  .card-body.white-card-body
                    .container
                      div Archive
                b-tab(title="Setup")
                  .card-body.white-card-body
                    .container
                      div Setup
            .col-12
              <!--pre {{ filteredList }}-->
              <!--pre {{ policiesListComputed }}-->
              <!--.test-block block-->
                <!--.test-block__element element-->
                <!--.test-block__element.test-block__element_modificator modificator-->
                <!--.ssadasdasd asdsad-->

</template>

<script>
  import PolicyTable from "./PolicyTable";
  import PoliciesModalCreate from "./PoliciesModalCreate"
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  // import Loading from '@/common/Loading/Loading'
  import nestedDraggable from "./infra/nestedMain"
  import rawdisplayer from "./infra/raw-displayer"
  // import draggable from "vuedraggable"

  export default {
    mixins: [EtaggerMixin],
    components: {
      PolicyTable,
      PoliciesModalCreate,
      // Loading,
      nestedDraggable,
      rawdisplayer,
      // draggable
    },
    data() {
      return {
        title: "test123",
        searchInput: "",
        policies: [],
        id: 1,
        policy: {},
      };
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
      searching (value) {
        this.searchInput = value;
      },
      updateList () {
        this.$store
          .dispatch("getPolicies")
          .then((response) => {
            // console.log(response);
          })
          .catch((err) => {
            console.error(err);
            this.makeToast('Error', err.message)
          });
      },
    },
    computed: {
      filteredList () {
        return this.policiesListComputed.filter(policy => {
            return policy.name?.toLowerCase().includes(this.searchInput.toLowerCase())
        })
      },
      policyById () {
        // return this.$store.dispach('getPolicyById', this.id)
      },
      // policiesListComputed() {
      //   const policies = this.$store.getters.policiesList;
      //   policies.sort((a, b) => a.position - b.position)
      //   return policies;
      // },
      policiesListComputed: {
        get() {
          const policies = this.$store.getters.policiesList
          let tmp;
          const newPoliciesList = policies.map(el => {
            tmp = el['name'];
            el['title'] = tmp;
            tmp = el['sections']
            el['children'] = tmp;
            if (!el['sections']) el['sections'] = []
            return el
          });
          newPoliciesList.sort((a, b) => a.position - b.position)
          console.log('newPoliciesList', newPoliciesList)
          return newPoliciesList;
        },
        set(value) {
          console.log(value)
          this.$store.dispatch("updatePolicyById", {
            id: this.policy.id,
            sections: value
          });
        }
      },
    },
    beforeCreate() { // or mounted?
      this.$store
        .dispatch("getPolicies")
        .then((response) => {
          // console.log(response);
        })
        .catch((err) => {
          console.error(err);
          this.makeToast('Error', err.message)
        });
    },
  };
</script>

<style>
  @import "./styles.css";
</style>

<style>
  @import "./styles.scss";
</style>

<style lang="scss">
  .test-block {
    border: solid 1px black;

    &__element {
      font-size: 1.5rem;

      &_modificator {
        background-color: lightblue;
      }
    }
  }
</style>
