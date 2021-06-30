<template lang="pug">
  div
    Loading
    .card
      .card-title
        .d-flex.justify-content-between.pb-1.pt-3.px-3
          div
            h3.mb-0 Annual Budget
          div
            button.btn.btn.btn-default.mr-3 Edit
      .card-body.white-card-body
        .card-body
          .chart abc
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
