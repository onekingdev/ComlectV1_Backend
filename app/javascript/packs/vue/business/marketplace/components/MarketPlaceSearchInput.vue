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
export default {
  name: 'MarketPlaceSearchInput',
  data() {
    return {
      search: '',
      values: []
    };
  },
  methods: {
    addTag () {
      if(!this.search) return
      this.values.push(this.search)
      this.search = ''
      history.pushState({}, '', `/business/specialists?tag=${this.values.join('&tag=')}`)
      this.$emit('searchComplited', this.values)
    },
    removeTag (id) {
      this.values.splice(id, 1)
      if(this.values.length) history.pushState({}, '', `/business/specialists?tag=${this.values.join('&tag=')}`)
      if(!this.values.length) history.pushState({}, '', `/business/specialists`)
      this.$emit('searchComplited', this.values)
    }
  }
}
</script>

<style scoped>

</style>
