<template lang="pug">
  .container
    .row.p-x-1
      .col
        .card-body.white-card-body.reviews__card
          .reviews__topiclist
            .reviews__card--header.p-b-20
              h2 Activity
              div
                a.btn.btn-default Download
                a.btn.m-l-1.btn-dark Create Activity
            .reviews__card--internal.borderless
              EmptyState

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
