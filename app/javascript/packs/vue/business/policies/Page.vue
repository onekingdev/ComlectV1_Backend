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
                                PoliciesModal
                                    button.btn.btn-dark.float-end New policy
                    .row
                        .col-12
                            b-tabs(content-class="mt-0")
                                b-tab(title="Compilance Manual" active)
                                    .card-body.white-card-body
                                        .container
                                            PolicyTable
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
                                .test-block__module element
                                .test-block__module.test-block__module_modificator modificator

</template>

<script>
import PolicyTable from "./PolicyTable";
import PoliciesModal from "./PoliciesModal";
import DragDropComponent from "./DragDropComponent";

export default {
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
