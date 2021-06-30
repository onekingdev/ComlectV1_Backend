<template lang="pug">
  div
    Loading
    .card
      .card-title.p-3.mb-0
        h3.mb-0 Paymnet Detals
      .card-body.white-card-body
        b-tabs(content-class="mt-2")
          b-tab(title="Upcomming" active)
            b-row
              .col Upcomming
          b-tab(title="Completed")
            b-row
              .col Completed
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
