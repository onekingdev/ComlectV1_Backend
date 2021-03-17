<template lang="pug">
    div
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
</template>

<script>
    export default {
        props: {
            policies: {
                type: Object,
                required: true
            }
        },
        methods: {

        },
        computed: {

        }
    }
</script>