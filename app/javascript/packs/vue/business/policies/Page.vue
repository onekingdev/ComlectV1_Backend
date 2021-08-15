<template lang="pug">
  .page
    .page-header
      h2.page-header__title Policies and Procedures
      .page-header__actions
        button.btn.btn.btn-default.mr-3 Download
        PoliciesModalCreate(@savedConfirmed="updateList")
          button.btn.btn-dark.float-end New Policy
    b-tabs.special-navs(content-class="mt-0")
      b-tab(title="Compliance" active)
        .card-body.white-card-body.card-body_full-height.p-x-40
          PoliciesTable.m-b-20(:policies="filteredUnArchivedListLimited", @searching="searching")
          b-pagination(v-if="!loading && filteredUnArchivedList.length" v-model='currentPage' :total-rows='filteredUnArchivedList.length' :per-page='perPage' aria-controls='PoliciesTable')
      b-tab(title="Archive")
        .card-body.white-card-body.card-body_full-height.p-x-40
          PoliciesTable(:policies="filteredArchivedList", @searching="searchingArchived")
      b-tab(title="Setup" lazy)
        .card-body.white-card-body.card-body_full-height.p-x-40
          PoliciesSetup
</template>

<script>
  import PoliciesTable from "./PoliciesTable";
  import PoliciesSetup from "./PoliciesSetup";
  import EtaggerMixin from '@/mixins/EtaggerMixin'
  import PoliciesModalCreate from "./Modals/PoliciesModalCreate"
  // import { mapGetters } from 'vuex'

  function paginate(array, page_size, page_number) {
    return array.slice((page_number - 1) * page_size, page_number * page_size);
  }

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
        perPage: 10,
        currentPage: 1,
      };
    },
    methods: {
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
            this.toast('Error', err.message, true)
          });
      },
    },
    computed: {
      // ...mapGetters({
      //   archivedList: 'policies/policiesListArchived',
      //   unArchivedList: 'policies/policiesListUnArchived',
      // }),
      loading() {
        return this.$store.getters.loading;
      },
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
      // policyById () {
      //     return this.$store.dispach('getPolicyById', this.id)
      // },
      filteredUnArchivedListLimited () {
        return paginate(this.filteredUnArchivedList, this.perPage, this.currentPage)
      },
    },
    // beforeCreate() { // or mounted?
    mounted() { // or beforeCreate?
      this.$store
        .dispatch("getPolicies")
        .then((response) => {
          // console.log('response mounted', response);
        })
        .catch((err) => {
          console.error(err);
          this.toast('Error', err.message, true)
        });
    },
  };
</script>

<style module>
  @import "./styles.css";
</style>
