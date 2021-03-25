<template lang="pug">
  .container
    .row.p-x-1
      .col-md-12.p-t-3.d-flex.justify-content-between.p-b-1
        div
          Breadcrumbs(:items="breadcrumbs")
          h2 {{ title }}
          p(v-if="sub") {{ sub }}
        div
          slot
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      required: true
    },
    sub: {
      type: String
    },
    breadcrumbs: {
      type: Array,
      required: true
    }
  }
}
</script>