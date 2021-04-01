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
                      PolicyTable(:policies="filteredList", @searching="searching")
                b-tab(title="Archive")
                  .card-body.white-card-body
                    .container
                      PolicyTable(:policies="archivedList", @searching="searching")
                b-tab(title="Setup")
                  .card-body.white-card-body
                    .container
                      div Setup
</template>

<script>
  import PolicyTable from "./PolicyTable";
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  import PoliciesModalCreate from "./Modals/PoliciesModalCreate"

  export default {
    mixins: [EtaggerMixin],
    components: {
      PolicyTable,
      PoliciesModalCreate,
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
      archivedList () {
        return this.policiesListComputed.filter(policy => policy.archived)
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
