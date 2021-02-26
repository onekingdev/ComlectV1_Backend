<template lang="pug">
  .card
    .card-header.d-flex.justify-content-between
      h3 Recent Activity
    .card-body
      div(v-for="(e, i) in entries" :key="i")
        hr(v-if="0 !== i")
        .row
          .col(style="max-width: 60px")
            b-avatar(:src="e.src")
          .col
            span(v-html="e.text")
            br
            span.text-muted {{e.time}}
</template>

<script>
export default {
  computed: {
    entries() {
      return [{ src: 'https://placekitten.com/256/256', text: 'Let\'s get started on <a href="#">This task</a>', time: '3:33 PM' },
              { src: 'https://placekitten.com/256/256', text: 'Let\'s get started on <a href="#">This task</a>', time: '3:33 PM' },
              { src: 'https://placekitten.com/256/256', text: 'Let\'s get started on <a href="#">This task</a>', time: '3:33 PM' },
              { src: 'https://placekitten.com/256/256', text: 'Let\'s get started on <a href="#">This task</a>', time: '3:33 PM' }]
    }
  }
}
</script>