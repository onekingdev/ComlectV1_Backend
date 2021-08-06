<template lang="pug">
  div
    .access-denied.access-denied_h-100
      .access-denied-content
        .access-denied__error-num 404
        //.access-denied__logo
        //  img(src='@/assets/rocket.svg')
        h3.access-denied__title No page found
        p.access-denied__subtitle The page you are looking for is either missing of can't be found
        button.btn.btn-dark.access-denied__btn(@click="$router.go(-1)")
          b-icon.mr-2(icon="chevron-left")
          | Go Back
</template>

<script>
  export default {

  }
</script>

<style scoped>

</style>
