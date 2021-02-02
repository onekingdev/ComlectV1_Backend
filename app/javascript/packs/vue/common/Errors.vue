<template functional lang="pug">
  .d-block.invalid-feedback(v-if="errors && errors[0]" role="alert" aria-live="assertive" aria-atomic="true") {{errors[0]}}
</template>

<script>
export default {
  props: {
    errors: Array
  }
}
</script>