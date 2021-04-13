<template lang="pug">
  div
    .container
      .row
        .col-12
          .row.p-x-1
            .col-md-12.d-flex.justify-content-between.p-t-3.p-b-3
              div
                h2: b {{ pageTitle }}
              div
                button.btn.btn-default.mr-3 Export
                button.btn.btn-dark Actions
          .row
            .col-12
              .card-body.white-card-body

</template>

<script>
  // import nestedDraggable from "../infra/nestedMain";

  export default {
    props: ['riskId'],
    components: {

    },
    data() {
      return {
        pageTitle: 'Risk Register'
      }
    },
    methods: {
      makeToast(title, str) {
        this.$bvToast.toast(str, { title, autoHideDelay: 5000 })
      },
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
    watch: {

    },
    mounted() {
      console.log(riskId)
    },
  };
</script>
