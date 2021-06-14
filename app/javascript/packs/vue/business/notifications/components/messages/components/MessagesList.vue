<template lang="pug">
  b-list-group
    MessageItem(v-for="item in messages" :key="item.id" :item="item")
</template>

<script>
  import MessageItem from "./MessageItem"
  export default {
    components: {
      MessageItem
    },
    props: {
      messages: {
        type: Array,
        required: true
      }
    },
  }
</script>
