<template lang="pug">
  tr
    td
      p.name {{ item.first_name + ' ' +  item.last_name }}
      p.email {{ item.email }}
    td
      RoleIcon(:role="item.role")
    td
      UserEditReasonModal
        a.link(href="#") {{ item.reason }}
    td
      b-icon.status__icon.m-r-1(font-scale="1" :icon="item.status ? 'check-circle-fill' : 'check-circle'" :class="{ done_task: item.status }")
    td {{ item.start_date | asDate }}
    td {{ item.end_date | asDate }}
    td.text-right
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        UserEditReasonModal(:inline="false")
          b-dropdown-item Edit
        UserModalArchive(v-if="item.status" :archiveStatus="item.status" :inline="false")
          b-dropdown-item Archive
        b-dropdown-item(v-if="!item.status" @click="unarchive") Unarchive
        UserModalDelete(:inline="false")
          b-dropdown-item Delete
</template>

<script>
  // import { DateTime } from 'luxon'
  import UserModalArchive from "@/common/Users/modals/UserModalArchive";
  import UserModalDelete from "@/common/Users/modals/UserModalDelete";
  import RoleIcon from "@/common/Users/components/RoleIcon";
  import UserRoleModalAddEdit from "@/common/Users/modals/UserRoleModalAddEdit";
  import UserEditReasonModal from "@/common/Users/modals/UserEditReasonModal";

  export default {
    name: "roleItem",
    components: {UserEditReasonModal, UserRoleModalAddEdit, RoleIcon, UserModalDelete, UserModalArchive},
    props: ['item'],
    computed: {

    },
    methods: {
      deleteUser(userId){
        this.$store.dispatch('users/deleteUser', { id: userId })
          .then(response => this.toast('Success', `The user has been deleted! ${response.id}`))
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`))
      },
      unarchive() {
        // Unarchive - if enough seats, then this just sends disabled user back to active user state (historical settings reactivated).
        // If not enough seats, then action cannot be performed without purchase of additional seats.
      }
    },
    filters: {
      capitalize: function (value) {
        if (!value) return ''
        value = value.toString()
        return value.charAt(0).toUpperCase() + value.slice(1)
      },
    }
  }
</script>

<style scoped>

</style>
