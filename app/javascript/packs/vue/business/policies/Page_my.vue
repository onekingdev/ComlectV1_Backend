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
                                button.btn.btn-dark.float-end New policy
                    .row
                        .col-12
                            b-tabs(content-class="mt-0")
                                b-tab(title="Compilance Manual" active)
                                    .card-body.white-card-body
                                        .container
                                            .row.mb-3
                                                .col-4
                                                    .position-relative
                                                        b-icon.icon-searh(icon='search')
                                                        input.form-control(type="text" placeholder="Search" v-model="searchInput")
                                                .col-4 {{ searchInput }}
                                            .row
                                                .col-12
                                                    <!--PolicyTable(:policies="policy")-->
                                                    .table
                                                        .table__row
                                                            .table__cell.table__cell_title Name
                                                            .table__cell.table__cell_title Status
                                                            .table__cell.table__cell_title Last Modified
                                                            .table__cell.table__cell_title Date Created
                                                            .table__cell.table__cell_title Risk Level
                                                            .table__cell
                                                        .table__row
                                                            .table__cell.table__cell_name Introduction
                                                            .table__cell
                                                                .status.status__published Published
                                                            .table__cell 1/20/2021
                                                            .table__cell 1/20/2021
                                                            .table__cell N/A
                                                            .table__cell
                                                                .actions
                                                                    button.btn
                                                                        b-icon(icon="three-dots")
                                                        .table__row
                                                            .table__cell.table__cell_name
                                                                .dropdown-toggle Managment Oversight
                                                            .table__cell
                                                                .status.status__draft Draft
                                                            .table__cell 1/20/2021
                                                            .table__cell 1/20/2021
                                                            .table__cell
                                                                .level.level__low
                                                                    b-icon.mr-2(icon="exclamation-triangle-fill")
                                                                    | Low
                                                            .table__cell
                                                                .actions
                                                                    button.btn
                                                                        b-icon(icon="three-dots")
                                                        .table__row
                                                            .table__cell.table__cell_name
                                                                .dropdown-toggle Code of Ethics and Personal Tranding
                                                                ul.dropdow-items
                                                                    .li 1.Code of Ethhics
                                                                    .li 2.Personal Tranding Policy
                                                                    .li Firm Review of Personal Tanserfersing
                                                            .table__cell
                                                                .status.status__draft Draft
                                                            .table__cell 1/20/2021
                                                            .table__cell 1/20/2021
                                                            .table__cell
                                                                .level.level__medium
                                                                    b-icon.mr-2(icon="exclamation-triangle-fill")
                                                                    | Medium
                                                            .table__cell
                                                                .actions
                                                                    button.btn
                                                                        b-icon(icon="three-dots")
                                                        .table__row
                                                            .table__cell.table__cell_name
                                                                .dropdown-toggle Code of Ethics and Personal Trading Policy
                                                                ul.dropdow-items
                                                                    .li 1.Code of Ethhics
                                                                    .li 2.Personal Tranding Policy
                                                                    .li Firm Review of Personal Tanserfersing
                                                                    .li 1.Code of Ethhics
                                                            .table__cell
                                                                .status.status__published Published
                                                            .table__cell 1/20/21
                                                            .table__cell 1/20/21
                                                            .table__cell
                                                                .level.level__high
                                                                    b-icon.mr-2(icon="exclamation-triangle-fill")
                                                                    | High
                                                            .table__cell
                                                                .actions
                                                                    button.btn
                                                                        b-icon(icon="three-dots")
                                                        .table__row
                                                            .table__cell.table__cell_name New Policy
                                                            .table__cell
                                                            .table__cell
                                                            .table__cell
                                                            .table__cell
                                                            .table__cell
                                                        .table__row
                                                            .table__cell.table__cell_name New Policy
                                                            .table__cell
                                                            .table__cell
                                                            .table__cell
                                                            .table__cell
                                                            .table__cell
                                b-tab(title="Archive")
                                    .card-body.white-card-body
                                        .container
                                            div Archive
                                b-tab(title="Setup")
                                    .card-body.white-card-body
                                        .container
                                            div Setup
            .row.p-x-1
                .col-12.col-md-9
                    div(v-for="(policy, i) in policiesList" :key="i")
                        div {{ policy }}
            .row
                .col-12


</template>

<script>
    import PolicyTable from './PolicyTable'
    import PoliciesModal from './PoliciesModal'

    const endpointUrl = '/api//business/compliance_policies/'

    export default {
        components: {
            PolicyTable,
            PoliciesModal
        },
        data() {
            return {
                title: 'test123',
                searchInput: '',
                policies: [],
                id: 1,
                policy: {
                    "compliance_policy": {
                        "name": "POLICY 1",
                        "description": "Policy 1 description",
                        "sections": [
                            {
                                "title": "Section 1",
                                "desc": "section 1 desc",
                                "children": [
                                    {
                                        "title": "Section 1 child 1",
                                        "desc": "section 1 child 1 desc",
                                        "children": [
                                            {
                                                "title": "Section 1 child 1-1",
                                                "desc": "Section 1 child 1-1 desc",
                                                "children": []
                                            }
                                        ]
                                    }
                                ]
                            },
                            {
                                "title": "Section 2",
                                "desc": "section 2 desc",
                                "children": []
                            }
                        ]
                    }
                }
            }

        },
        methods: {
            search() {
                this.policiesList = this.policy.compliance_policy.find(pol => {
                    pol.name === this.searchInput;
                })
            }
        },
        computed: {
            // policiesList() {
            //     console.log(this.$store.getters.url('URL_POLICIES_SHOW', this.id));
            //     return this.$store.getters.url('URL_POLICIES_SHOW', this.id)
            // }
            policiesList: () => {
                fetch(`${endpointUrl}1`, { headers: {'Accept': 'application/json'}})
                    .then(response => {
                        console.log(response)
                        response.json()
                    })
                    .then(result => console.log(result))
                    .catch(err => console.log(err))
            },
        }
    }
</script>

<style>
    @import './styles.css';
</style>

<style scoped>
    .icon-searh {
        position: absolute;
        top: 50%;
        left: .5rem;
        transform: translateY(-50%);
    }
    .form-control {
        padding-left: 2rem;
    }
</style>