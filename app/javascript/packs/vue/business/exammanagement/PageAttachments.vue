<template lang="pug">
  .container
    .row.p-x-1
      .col
        .card-body.white-card-body.reviews__card.px-5
          .reviews__topiclist
            .reviews__card--internal.p-y-1
              .row.m-b-2
                .col-md-12.d-flex.justify-content-between
                  h2 Documents
                  div
                    a.btn.btn-default Download
                    a.btn.m-l-1.btn-dark Create Documents
              DocumentsTable(:currentExam="currentExam")

</template>

<script>
  import DocumentsTable from "./components/DocumentsTable";
  export default {
    props: ['currentExam'],
    components: {
      DocumentsTable
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
