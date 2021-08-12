<template lang="pug">
  .loading(v-if="loading" :class="{ absolute: absolute }")
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
    computed: {
      loading() {
        return this.$store.getters.loading;
      },
    }
  }
</script>
