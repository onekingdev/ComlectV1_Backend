<template lang="pug">
  tr
    td
      a(:href="`/business/annual_reviews/${item.id}`")
        | {{ item.year }} Annual Review
    td
      .reviews-table__progress.d-flex
        .reviews-table__progress-numbers
          | {{ item.progress }}/{{ item.review_categories.length }}
        .reviews-table__progress-bar.d-flex
          .reviews-table__progress-bar__item(:style="`width: ${progressWidth}%`")
    td {{ item.findings }}
    td {{ dateToHuman(item.updated_at) }}
    td {{ dateToHuman(item.created_at) }}
    td
      a(:href="item.pdf_url")
        b-icon.ml-2(icon='b ox-arrow-down')
        | Download
    td
      .actions
        b-dropdown(size="sm" variant="light" class="m-0 p-0" right)
          template(#button-content)
            b-icon(icon="three-dots")
          b-dropdown-item(:href="`/business/annual_reviews/${item.id}`") Edit
          b-dropdown-item() Dublicate
          b-dropdown-item() Delete
</template>

<script>
import { DateTime } from 'luxon'
export default {
  name: "ReviewItem",
  props: ['item'],
  computed: {
    progressWidth() {
      const part = 100 / +this.item.review_categories.length
      return +part * +this.item.progress
    }
  },
  methods: {
    dateToHuman(value) {
      const date = DateTime.fromJSDate(new Date(value))
      if (!date.invalid) {
        return date.toFormat('dd/MM/yyyy')
      }
      if (date.invalid) {
        return value
      }
    }
  }
}
</script>

<style scoped>

</style>
