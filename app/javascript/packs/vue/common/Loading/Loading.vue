<template lang="pug">
  div(v-if="loading" :class="{ absolute: absolute }")
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
    props: ['absolute'],
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

<style scoped>
  .absolute {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    margin: auto;
    width: 250px;
    height: 250px;
  }
</style>
