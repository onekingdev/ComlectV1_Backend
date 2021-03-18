<template lang="pug">
    div
        .row.my-3
            .col-4
                .position-relative
                    b-icon.icon-searh(icon='search')
                    input.form-control(type="text" placeholder="Search" v-model="searchInput")
            .col-4 {{ searchInput }}
        .row
            .col-12
                .table
                    .table__row
                        .table__cell.table__cell_title Name
                        .table__cell.table__cell_title
                            | Status
                            b-icon.ml-2(icon='chevron-expand')
                        .table__cell.table__cell_title
                            | Last Modified
                            b-icon.ml-2(icon='chevron-expand')
                        .table__cell.table__cell_title
                            | Date Created
                            b-icon.ml-2(icon='chevron-expand')
                        .table__cell.table__cell_title
                            | Risk Level
                            b-icon.ml-2(icon='chevron-expand')
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
                                button.px-0.actions__btn(@click="isActive = !isActive", :class="{ active: isActive }")
                                b-icon(icon="three-dots")
                                ul.actions-dropdown(:class="{ active: isActive }")
                                    li.actions-dropdown__item.save(@click="saveSubSectionChild") Save it
                                    li.actions-dropdown__item.move-up Move up
                                    li.actions-dropdown__item.delete Delete
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
                                button.btn.px-0
                                    b-icon(icon="three-dots")
                    .table__row
                        .table__cell.table__cell_name
                            .dropdown-toggle.active
                                b-icon.mr-2(icon='chevron-compact-right')
                                | Code of Ethics and Personal Tranding
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
                                button.btn.px-0
                                    b-icon(icon="three-dots")
                    .table__row
                        .table__cell.table__cell_name
                            .dropdown-toggle.active
                                b-icon.mr-2(icon='chevron-compact-right')
                                | Code of Ethics and Personal Trading Policy
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
                                button.btn.px-0
                                    b-icon(icon="three-dots")
                    .table__row
                        .table__cell.table__cell_name
                            .dropdown-toggle
                                b-icon.mr-2(icon='chevron-compact-right')
                                | Code of Ethics and Personal Trading Policy
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
                                button.btn.px-0
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
</template>

<script>
    export default {
        props: {
            policies: {
                type: Object,
                required: false
            }
        },
        data() {
            return {
                searchInput: '',
            }
        },
        methods: {

        },
        computed: {

        }
    }
</script>