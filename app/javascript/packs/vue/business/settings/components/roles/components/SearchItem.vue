<template lang="pug">
  .row
    .col-lg-4.col-12
      .position-relative
        b-icon.icon-searh(icon='search')
        input.form-control.form-control_search(type="text" placeholder="Search" v-model="searchInput", @keyup="searching")
        button.btn-clear(v-if="isActive" @click="clearInput")
          b-icon.icon-clear(icon='x-circle')
    .col-4(v-if="users.length !== 0 && searchInput")
      p Found {{ users.length }} {{ users.length === 1 ? 'result' : 'results' }}
</template>

<script>
  export default {
    name: "searchItem",
    props: ['users'],
    data() {
      return {
        searchInput: '',
        isActive: false,
      };
    },
    methods: {
      searching () {
        if(this.searchInput.length) this.isActive = true
        if(!this.searchInput.length) this.isActive = false
        this.$emit('searchingConfirmed', this.searchInput)
      },
      clearInput() {
        this.searchInput = ''
        this.isActive = false
        this.$emit('searchingConfirmed', this.searchInput)
      },
    },
  };
</script>

<style scoped>

</style>
