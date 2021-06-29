<template lang="pug">
  div
    Loading
    .card
      .card-title.p-3.mb-0
        h3.mb-0 Compilance Spend
      .card-body.white-card-body
        .card-body(v-if="loading")
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
