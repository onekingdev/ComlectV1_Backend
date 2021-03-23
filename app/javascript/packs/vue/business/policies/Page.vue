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
                PoliciesModal(@saved="refetch")
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
                      // DragDropComponent(policy="policy")
                b-tab(title="Archive")
                  .card-body.white-card-body
                    .container
                      div Archive
                b-tab(title="Setup")
                  .card-body.white-card-body
                    .container
                      div Setup
            .col-12
              pre {{ filteredList }}
              pre {{ policiesListComputed }}
              .test-block block
                .test-block__element element
                .test-block__element.test-block__element_modificator modificator
                .ssadasdasd asdsad

</template>

<script>
  import PolicyTable from "./PolicyTable";
  import PoliciesModal from "./PoliciesModal";
  import DragDropComponent from "./DragDropComponent";
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  // import Loading from '@/common/Loading/Loading'

  export default {
    mixins: [EtaggerMixin],
    components: {
      PolicyTable,
      PoliciesModal,
      DragDropComponent,
      // Loading
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
      }
    },
    computed: {
      filteredList () {
        return this.policiesListComputed.filter(policy => {
            return policy.name.toLowerCase().includes(this.searchInput.toLowerCase())
        })
      },
      policyById () {
        // return this.$store.dispach('getPolicyById', this.id)
      },
      policiesListComputed() {
        return this.$store.getters.policies;
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
    }
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
