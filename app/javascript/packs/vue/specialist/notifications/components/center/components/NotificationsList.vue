<template lang="pug">
  b-list-group
    NotificationItem(v-for="item in notifications" :key="item.id" :item="item")
</template>

<script>
  import NotificationItem from "./NotificationItem"
  export default {
    components: {
      NotificationItem
    },
    props: {
      notifications: {
        type: Array,
        required: true
      }
    },
  }
</script>
