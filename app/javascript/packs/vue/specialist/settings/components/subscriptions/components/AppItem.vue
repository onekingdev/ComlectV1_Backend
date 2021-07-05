<template lang="pug">
  tr
    td
      a.link(:href="item.url") {{ item.name }}
    td.text-center
      b-badge.status(:variant="item.status ? 'success' : 'light'") {{ item.status }}
    td.text-right
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        b-dropdown-item Edit
        b-dropdown-item.delete Delete
</template>

<script>
  export default {
    name: "appItem",
    props: ['item'],
    components: {

    },
    data() {
      return {
        statusVariant: 'light',
      }
    },
    computed: {

    },
    methods: {
      deleteApp(userId){
        this.$store.dispatch('users/deleteApp', { id: userId })
          .then(response => this.toast('Success', `The app has been deleted! ${response.id}`))
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
      }
    }
  }
</script>

<style scoped>

</style>
