<template lang="pug">
  .col-md-6.col-sm-12
    b-form-group(label="Search" label-for="search-input" label-class="label" class="search-form")
      b-icon(icon="search" class="search-form__icon")
      b-form-input#search-input(v-model="search" placeholder="Enter keywords, skills, etc." @keyup.enter="addTag" class="search-form__input")
    b-form-group
      b-badge.mr-2(variant="none" v-for="(tag, idx) in values" :key="tag")
        | {{ tag }}
        ion-icon.ml-2.close(name='close-outline' @click="removeTag(idx)")
</template>

<script>
const SEARCH_URL_INDEX = '/specialistmarketplace'
const SEARCH_URL_TAGS = tags => `${SEARCH_URL_INDEX}?tag=${tags.join('&tag=')}`

export default {
  name: 'MarketPlaceSearchInput',
  data() {
    return {
      search: '',
      values: []
    };
  },
  created() {
    const tags = this.$router.currentRoute.query.tag
    if (tags && Array.isArray(tags)) {
      this.values = tags
      this.$emit('searchCompleted', this.values)
    }
  },
  methods: {
    addTag () {
      if (!this.search) return
      this.values.push(this.search)
      this.search = ''
      history.pushState({}, '', SEARCH_URL_TAGS(this.values))
      this.$emit('searchCompleted', this.values)
    },
    removeTag (id) {
      this.values.splice(id, 1)
      if (this.values.length) history.pushState({}, '', SEARCH_URL_TAGS(this.values))
      if (!this.values.length) history.pushState({}, '', SEARCH_URL_INDEX)
      this.$emit('searchCompleted', this.values)
    }
  }
}
</script>
