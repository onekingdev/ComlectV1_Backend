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
    td(v-if="disabled") {{ item.reason }}
    td
      b-icon.status__icon.m-r-1(font-scale="1" :icon="item.status ? 'check-circle-fill' : 'check-circle'" :class="{ done_task: item.status }")
    td.text-right {{ item.created_at | asDate }}
    td.text-right(v-if="disabled") {{ item.disabled_at | asDate }}
    td.text-right
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        UserModalAddEdit(:user="item",  :inline="false")
          b-dropdown-item Edit
        UserModalArchive(:archiveStatus="item.status" :inline="false")
          b-dropdown-item {{ item.status ? 'Archive' : 'Unarchive' }}
        UserModalDelete(v-if="!item.status" :inline="false")
          b-dropdown-item.delete Delete
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import UserModalArchive from "../modals/UserModalArchive";
  import UserModalDelete from "../modals/UserModalDelete";
  import UserModalAddEdit from "../modals/UserModalAddEdit";
  import RoleIcon from "@/common/Users/components/RoleIcon";

  export default {
    name: "userItem",
    props: {
      item: {
        type: Object,
        required: true
      },
      disabled: {
        type: Boolean,
        required: false,
        default: false
      }
    },
    components: {
      RoleIcon,
      UserModalAddEdit,
      UserModalDelete,
      UserModalArchive,
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
    },
  }
</script>

<style scoped>

</style>
<style>
  ion-icon.black {
    color: #303132;
  }
  ion-icon.grey {
    color: #c6c8ce;
  }
</style>
