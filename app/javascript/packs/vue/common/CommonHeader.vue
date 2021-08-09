<template lang="pug">
  .page-header.p-y-20
    .d-flex.flex-column
      Breadcrumbs.mb-2(:items="breadcrumbs")
      h2.page-header__title.my-0.ml-0.mb-2 {{ title }}
      p(v-if="sub") {{ sub }}
    .page-header__actions
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
