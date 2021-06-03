<template lang="pug">
  .col-md-12
    .row.py-2
      .col-sm-12
        b-form-group(label="Search" label-for="search-input")
           b-form-input#search-input(v-model="search" placeholder="Enter keywords, skills, etc." @keyup.enter="addTag")
        b-form-group
          b-badge.mr-2(variant="none" v-for="(tag, idx) in value" :key="tag")
            | {{ tag }}
            ion-icon.ml-2.close(name='close-outline' @click="removeTag(idx)")
</template>

<script>
export default {
  name: 'MarketPlaceSearchInput',
  data() {
    return {
      search: '',
      value: []
    };
  },
  methods: {
    addTag () {
      if(!this.search) return
      this.value.push(this.search)
      this.search = ''
    },
    removeTag (id) {
      this.value.splice(id, 1)
    }
  }
}
</script>

<style scoped>

</style>
