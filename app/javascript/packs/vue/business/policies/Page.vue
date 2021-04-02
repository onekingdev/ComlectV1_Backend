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
                      PolicyTable(:policies="filteredUnArchivedList", @searching="searching")
                b-tab(title="Archive")
                  .card-body.white-card-body
                    .container
                      PolicyTable(:policies="filteredArchivedList", @searching="searchingArchived")
                b-tab(title="Setup")
                  .card-body.white-card-body
                    .container
                      PolicySetup
</template>

<script>
  import PolicyTable from "./PolicyTable";
  import PolicySetup from "./PolicySetup";
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  import PoliciesModalCreate from "./Modals/PoliciesModalCreate"

  export default {
    mixins: [EtaggerMixin],
    components: {
      PolicyTable,
      PolicySetup,
      PoliciesModalCreate,
    },
    data() {
      return {
        title: "test123",
        searchInput: "",
        searchInputArchived: "",
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
      searchingArchived (value) {
        this.searchInputArchived = value;
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
      filteredUnArchivedList () {
        return this.unArchivedList.filter(policy => {
            return policy.name?.toLowerCase().includes(this.searchInput.toLowerCase())
        })
      },
      filteredArchivedList () {
        return this.archivedList.filter(policy => {
          return policy.name?.toLowerCase().includes(this.searchInputArchived.toLowerCase())
        })
      },
      archivedList () {
        return this.policiesListComputed.filter(policy => policy.archived)
      },
      unArchivedList () {
        return this.policiesListComputed.filter(policy => !policy.archived)
      },
      policyById () {
        // return this.$store.dispach('getPolicyById', this.id)
      },
      policiesListComputed: {
        get() {
          return this.$store.getters.policiesListNested
        },
        set(value) {
          this.$store.dispatch("updatePolicySectionsById", {
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
          console.log('response', response);
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
