<template lang="pug">
  div
    span(v-for="(item, i) in items" :key="i")
      span(v-if="i")
        | &nbsp;
        span.text-warning /
        | &nbsp;
      b(v-if="i+1 === items.length") {{ item }}
      span(v-else) {{ item }}
</template>

<script>
export default {
  props: {
    items: Array
  }
}
</script>