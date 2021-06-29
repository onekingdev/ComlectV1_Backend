<template lang="pug">
  div
    CommonTable(:users="users")
    b-pagination(v-model='currentPage' :total-rows='rows' :per-page='perPage' aria-controls='my-table')
</template>

<script>
  import CommonTable from '../common/Table'
  export default {
    name: "index",
    props: ['items', 'users'],
    components: { CommonTable },
    data() {
      return {
        perPage: 3,
        currentPage: 1,
      }
    },
    computed: {
      rows() {
        return this.users.length
      }
    }
  }
</script>

<style scoped>

</style>
