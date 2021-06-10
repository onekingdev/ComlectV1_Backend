<template lang="pug">
  tr
    td
      .d-flex
        UserAvatar(:user="item")
        .d-block.m-l-2
          p.mt-2.mb-0: b {{ item.first_name + ' ' +  item.last_name }}
    td
      b-form-checkbox(v-model="item.checked") {{item.checked ? 'Trusted' : 'Basic'}}
    td
      b-badge.status(:variant="item.status ? 'success' : 'light'") {{ item.status }}
    td.text-right
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        b-dropdown-item Message
        EditRoleModal(:specialist="item",  :inline="false")
          b-dropdown-item Edit Role
        b-dropdown-item View contract
        b-dropdown-item.delete Delete
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import EditRoleModal from "../modals/RolesModalEdit";

  export default {
    name: "roleItem",
    props: ['item'],
    components: {
      EditRoleModal,
      UserAvatar,
    },
    computed: {

    },
    methods: {
      deleteUser(userId){
        this.$store.dispatch('users/deleteUser', { id: userId })
          .then(response => this.toast('Success', `The user has been deleted! ${response.id}`))
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
      }
    }
  }
</script>

<style scoped>

</style>
