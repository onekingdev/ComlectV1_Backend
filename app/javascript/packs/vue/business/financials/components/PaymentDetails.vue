<template lang="pug">
  div
    Loading
    .card.m-b-20
      .card-title.p-20
        h2.card-title__name Paymnet Detals
        .card-title__actions
          button.btn.btn.btn-default.mr-3 Export
      .card-body.white-card-body
        b-tabs(content-class="mt-2")
          b-tab(title="Upcomming" active)
            b-row
              .col.px-3 Upcomming
          b-tab(title="Completed")
            b-row
              .col.px-3 Completed
</template>

<script>
  import Loading from '@/common/Loading/Loading'

  export default {
    components: {
      Loading,
    },
    data() {
      return {

      }
    },
    methods: {

    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
  }
</script>

<style scoped>

</style>
