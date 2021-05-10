<template lang="pug">
  .container-fluid
    .row
      .col-12
        .container
          .row
            .col-md-12.d-flex.justify-content-between.p-t-3.p-b-1
              div
                h2: b Policies and Procedures
              div
                button.btn.btn.btn-default.mr-3 Export
                PoliciesModalCreate(@saved="updateList")
                  button.btn.btn-dark.float-end New policy
    .row
      .col-12.px-0
        b-tabs(content-class="mt-0")
          b-tab(title="Compilance Manual" active)
            .card-body.white-card-body
              .container
                PoliciesTable(:policies="filteredUnArchivedList", @searching="searching")
          b-tab(title="Archive")
            .card-body.white-card-body
              .container
                PoliciesTable(:policies="filteredArchivedList", @searching="searchingArchived")
          b-tab(title="Setup")
            .card-body.white-card-body
              .container
                PoliciesSetup
</template>

<script>
  import PoliciesTable from "./PoliciesTable";
  import PoliciesSetup from "./PoliciesSetup";
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  import PoliciesModalCreate from "./Modals/PoliciesModalCreate"
  // import { mapGetters } from 'vuex'

  export default {
    mixins: [EtaggerMixin()],
    components: {
      PoliciesTable,
      PoliciesSetup,
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
      // ...mapGetters({
      //   archivedList: 'policies/policiesListArchived',
      //   unArchivedList: 'policies/policiesListUnArchived',
      // }),
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
        return this.$store.getters.policiesListArchived
      },
      unArchivedList () {
        return this.$store.getters.policiesListUnArchived
      },
      policiesListComputed () {
        return this.$store.getters.policiesListNested
      },
      policyById () {
        // return this.$store.dispach('getPolicyById', this.id)
      },
    },
    // beforeCreate() { // or mounted?
    mounted() { // or beforeCreate?
      this.$store
        .dispatch("getPolicies")
        .then((response) => {
          console.log('response mounted', response);
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

<!--<style>-->
  <!--@import "./styles.scss";-->
<!--</style>-->

<!--<style lang="scss">-->
  <!--.test-block {-->
    <!--border: solid 1px black;-->

    <!--&__element {-->
      <!--font-size: 1.5rem;-->

      <!--&_modificator {-->
        <!--background-color: lightblue;-->
      <!--}-->
    <!--}-->
  <!--}-->
<!--</style>-->
