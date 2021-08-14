<template lang="pug">
  tr
    td
      .d-flex.align-items-center
        UserAvatar.avatar.m-r-1(:user="item")
        .d-block
          p.name {{ item.first_name + ' ' +  item.last_name }}
          p.email {{ item.email }}
    td
      RoleIcon(:role="item.role")
    td
      b-icon.status__icon.m-r-1(font-scale="1" :icon="item.status ? 'check-circle-fill' : 'check-circle'" :class="{ done_task: item.status }")
    td {{ item.start_date | asDate }}
    td
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        UserModalAddEdit(:user="item",  :inline="false")
          b-dropdown-item Edit
        UserModalArchive(:user="item",  :inline="false")
          b-dropdown-item Archive
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import UserModalAddEdit from "../../../settings/components/users/modals/UserModalAddEdit";
  import UserModalArchive from "../../../../specialist/settings/components/users/modals/UserModalArchive";
  import RoleIcon from "@/common/Users/components/RoleIcon";

  export default {
    name: "roleItem",
    props: ['item'],
    components: {
      RoleIcon,
      UserModalArchive,
      UserModalAddEdit,
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
  }
</script>

<style scoped>

</style>
