<template lang="pug">
  tr
    td
      .d-flex.align-items-center
        UserAvatar.avatar(:user="item" :sm="true" :bgLight="true")
        .d-block
          p.name {{ item.first_name + ' ' +  item.last_name }}
          p.email {{ item.email }}
    td
      .role-info
        ion-icon.role-info__icon.black(v-if="item.role === 'admin'" name="people-outline" size="small")
        b-icon.role-info__icon(v-if="item.role === 'trusted'" icon="check-square-fill" scale="2" variant="success")
        ion-icon.role-info__icon.grey(v-if="item.role === 'basic'" name="person-circle-outline" size="small")
        span.ml-3 {{ item.role | capitalize }}
    td
      b-icon.status__icon.m-r-1(font-scale="1" :icon="item.status ? 'check-circle-fill' : 'check-circle'" :class="{ done_task: item.status }")
      //b-badge.status(:variant="item.status ? 'success' : 'light'") {{ item.status ? 'Active' : 'Inactive' }}
    td 1/20/2017
    td.text-right
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        EditRoleModal(:specialist="item",  :inline="false")
          b-dropdown-item Edit
        b-dropdown-item Archive
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import EditRoleModal from "./modals/RolesModalEdit";

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
