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
                      //PolicyTable
                      Get(policies="/api/business/compliance_policies"): template(v-slot="{policies}"): table.table
                        thead
                          tr
                            th Name
                            th Status
                            th Last Modified
                            th Date Created
                            th Risk Level
                            th
                        tbody
                          tr(v-for="policy in policies" :key="policy.id")
                            td {{ policy.name }}
                            td: .badge.badge-success {{ policy.status }}
                            td {{ policy.updated_at}}
                            td {{ policy.created_at}}
                            td &hellip;
                            td
                          tr(v-if="!policies.length")
                            td.text-center(colspan=6) No policies
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
              div {{ policiesListComputed }}
              .test-block block
                .test-block__element element
                .test-block__element.test-block__element_modificator modificator

</template>

<script>
  import PolicyTable from "./PolicyTable";
  import PoliciesModal from "./PoliciesModal";
  import DragDropComponent from "./DragDropComponent";
  import EtaggerMixin from '@/mixins/EtaggerMixin'

  export default {
    mixins: [EtaggerMixin],
    components: {
      PolicyTable,
      PoliciesModal,
      DragDropComponent,
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
      search() {
        this.policiesList = this.policy.compliance_policy.find((pol) => {
          pol.name === this.searchInput;
        });
      },
      getContacts(projects) {
        console.log(projects)
        return projects.reduce((result, project) => {
          for (const p in project.projects) {
            const spec = project.projects[p].specialist
            if (spec && !result.find(s => s.id === spec.id)) {
              result.push({
                id: spec.id,
                name: spec.first_name + ' ' + spec.last_name,
                location: [spec.country, spec.state, spec.city].filter(a => a).join(', '),
                status: spec.visibility,
                rating: 5
              })
            }
          }
          return result
        }, [])
      },
    },
    computed: {
      policiesList: () => {
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
          console.log(response);
        })
        .catch((err) => {
          console.log(err);
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
