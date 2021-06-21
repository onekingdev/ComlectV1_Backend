<template lang="pug">
  .reviews__list-item.mb-2
    router-link.link.d-flex.justify-content-between.align-items-center(:to='url' :class="linkClass")
      .reviews__list-text
        | {{ title }}
      .reviews__list-icon(:class="{ 'checked': checked }")
        b-icon(icon='check-circle-fill' v-if="checked")
        b-icon(icon='check-circle' v-else)
</template>

<script>
export default {
  name: "ReviewLink",
  props: {
    id: {
      type: Number,
    },
    title: {
      type: String,
      default: "General"
    },
    checked: {
      type: Boolean
    },
    currentId: {
      type: Number
    },
    annualId: {
      type: Number
    },
    general: {
      type: Boolean
    },
  },
  computed: {
    url () {
      if (this.id) {
        return `/business/annual_reviews/${this.annualId}/${this.id}`
      }
      return `/business/annual_reviews/${this.annualId}`
    },
    linkClass() {
      return {
        'reviews__list-link--active': this.id ? this.currentId === this.id : this.general
      }
    }
  }
}
</script>
