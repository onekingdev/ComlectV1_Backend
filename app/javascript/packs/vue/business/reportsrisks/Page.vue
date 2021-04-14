<template lang="pug">
  div
    .container
      .row
        .col-12
          .row.p-x-1
            .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
              div
                h2: b {{ pageTitle }}
          .row
            .col-12 sadasd
</template>

<script>
  export default {
    components: {

    },
    data() {
      return {
        pageTitle: "Reports",
      };
    },
    methods: {

    },
    computed: {

    },
    mounted() {

    },
  };
</script>

<style>
  @import "./styles.css";
</style>

