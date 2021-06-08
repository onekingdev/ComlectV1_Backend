<template lang="pug">
  div.settings
    .container-fluid
      .row
        .col-md-3 test1
        .col-md-9 test2

</template>

<script>
  import Loading from '@/common/Loading/Loading'

  export default {
    components: {
      Loading,
    },
    data() {
      return {

      };
    },
    methods: {

    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    },
    mounted() {

    },
  };
</script>

<style>
  @import "./styles.css";
</style>
