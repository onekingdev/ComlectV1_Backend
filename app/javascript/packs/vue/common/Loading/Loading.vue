<template lang="pug">
  div(v-if="loading")
    .d-flex.flex-column.justify-content-center.align-items-center.mb-2
      // b-icon(icon="three-dots", animation="cylon", font-scale="4")
      // h5 Loading....
      .lds-ring
        div
        div
        div
        div
</template>

<script>
  export default {
    data() {
      return {

      }
    },
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    }
  }
</script>
