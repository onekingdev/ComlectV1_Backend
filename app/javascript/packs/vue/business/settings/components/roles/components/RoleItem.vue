<template lang="pug">
  tr
    td
      .d-flex
        UserAvatar(:user="item")
        .d-block.m-l-2
          p.mt-2.mb-0: b {{ item.first_name + ' ' +  item.last_name }}
    td
      .role-info
        ion-icon.role-info__icon.black(v-if="item.role === 'admin'" name="people-outline" size="small")
        b-icon.role-info__icon(v-if="item.role === 'trusted'" icon="check-square-fill" scale="2" variant="success")
        ion-icon.role-info__icon.grey(v-if="item.role === 'basic'" name="person-circle-outline" size="small")
        span.ml-3 {{ item.role | capitalize }}
    td
      b-badge.status(:variant="item.status ? 'success' : 'light'") {{ item.status ? 'Active' : 'Inactive' }}
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
    },
    filters: {
      capitalize: function (value) {
        if (!value) return ''
        value = value.toString()
        return value.charAt(0).toUpperCase() + value.slice(1)
      }
    }
  }
</script>

<style scoped>

</style>
