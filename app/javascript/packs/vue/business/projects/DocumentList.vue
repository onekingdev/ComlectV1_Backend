<template lang="pug">
  .row.p-x-1
    .alert.alert-info.col-md-4(v-for="document in documents" :key="document.id")
      button.btn.btn-default.float-right(v-if="document.isEditable") &hellip;
      p {{ document.name }}
      p: a(href='#') Download
</template>

<script>
export default {
  computed: {
    documents() {
      return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map(id => ({
        id,
        name: 'document ' + id + '.pdf',
        isEditable: Math.random() > 0.5
      }))
    }
  }
}
</script>