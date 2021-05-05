<template lang="pug">
  .container
    .row.p-x-1
      .col
        .card-body.white-card-body.reviews__card.px-5
          .reviews__topiclist
            .reviews__card--internal.p-y-1
              .row.m-b-2
                .col-md-12.d-flex.justify-content-between
                  h2: b Activity
                  div
                    a.btn.btn-default Download
                    a.btn.m-l-1.btn-dark Create Activity
              .row
                .col
                  table.table.task_table
                    tbody
                      tr
                        td.text-center
                          h3 No Activity

</template>

<script>
  export default {
    components: {

    },
    data() {
      return {

      }
    },
    created() {
    },
    methods: {

    },
    computed: {

    },
  }
</script>
