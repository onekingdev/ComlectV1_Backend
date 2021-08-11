<template lang="pug">
  div
    Loading
    .card
      .card-title.p-x-20
        h2.card-title__name Payment Details
        .card-title__actions
          button.btn.btn.btn-default Download
      .card-body.white-card-body
        b-tabs.special-navs-financials(content-class="mt-2")
          b-tab(title="Upcoming" active)
            b-row
              .col.px-3
                EmptyState
          b-tab(title="Completed")
            b-row
              .col.px-3
                EmptyState
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
