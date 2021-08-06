<template lang="pug">
  .empty-state
    h3.empty-state__title {{ name }} not exist
    .empty-state__image
      img(src='@/assets/empty state.svg')
</template>

<script>
  export default {
    props: ['name']
  }
</script>

<style scoped>

</style>
