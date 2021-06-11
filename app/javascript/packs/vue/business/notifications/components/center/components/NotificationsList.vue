<template lang="pug">
  b-list-group
    NotificationsItem(v-for="item in notifications" :key="item.id" :item="item")
</template>

<script>
  import NotificationsItem from "./NotificationsItem"
  export default {
    components: {
      NotificationsItem
    },
    props: {
      notifications: {
        type: Array,
        required: true
      }
    },
  }
</script>
