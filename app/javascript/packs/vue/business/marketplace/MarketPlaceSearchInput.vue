<template lang="pug">
  .col-md-12
    .row.py-2
      .col-sm-12
        b-form-group(label="Search" label-for="search-input")
        b-form-input#search-input(v-model="search" placeholder="Enter keywords, skills, etc.")
    .row.py-2
      .col
        b-badge(variant="light")
          | Mock audit
        ion-icon.ml-2(name='close-outline')
</template>

<script>
export default {
  name: 'MarketPlaceSearchInput'
}
</script>