<template lang="pug">
  .card
    .card-header.d-flex.justify-content-between
      h3 Add-On Notifications
      button.btn View all
    .card-body
      div(v-for="(n, i) in notifications" :key="i")
        hr(v-if="0 !== i")
        .row
          .col(style="max-width: 60px")
            b-avatar(:src="n.src")
          .col
            h6 {{n.title}}
            span(v-html="n.text")
            br
            span.text-muted {{n.time}}
</template>

<script>
export default {
  computed: {
    notifications() {
      return [{ src: 'https://placekitten.com/300/300', title: "Addon Name", text: 'You have a notification from installed add-on', time: '3:33 PM' },
              { src: 'https://placekitten.com/300/300', title: "Addon Name", text: 'You have a notification from installed add-on', time: '3:33 PM' },
              { src: 'https://placekitten.com/300/300', title: "Addon Name", text: 'You have a notification from installed add-on', time: '3:33 PM' },
              { src: 'https://placekitten.com/300/300', title: "Addon Name", text: 'You have a notification from installed add-on', time: '3:33 PM' }]
    }
  }
}
</script>