<template lang="pug">
  div
    span(v-for="(item, i) in items" :key="i")
      span(v-if="i") &nbsp;/&nbsp;
      | {{ item }}
</template>

<script>
export default {
  props: {
    items: Array
  }
}
</script>