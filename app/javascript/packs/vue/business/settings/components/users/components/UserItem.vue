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
    td(v-if="disabled")
      UserEditReasonModal(:user="item" @editReasonConfirmed="editReason")
        .link {{ item.reason | capital }}
    td
      b-icon.status__icon.m-r-1(font-scale="1" :icon="item.access_person ? 'check-circle-fill' : 'check-circle'" :class="{ done_task: item.access_person }")
    td.text-right {{ item.start_date | asDate }}
    td.text-right(v-if="disabled") {{ item.disabled_at | asDate }}
    td.text-right
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        UserModalAddEdit(:user="item",  :inline="false")
          b-dropdown-item Edit
        UserModalArchive(v-if="item.active" :user="item" :archiveStatus="item.active" :inline="false" @archiveConfirmed="archiveUser")
          b-dropdown-item {{ item.active ? 'Disable' : 'Enable' }}
        b-dropdown-item(v-if="!item.active" @click="archiveUser(item)") Enable
        UserModalDelete(v-if="!item.active" :inline="false" @deleteConfirmed="deleteUser(item.id)")
          b-dropdown-item.delete Delete
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import UserModalArchive from "@/common/Users/modals/UserModalArchive";
  import UserModalDelete from "@/common/Users/modals/UserModalDelete";
  import UserModalAddEdit from "@/common/Users/modals/UserModalAddEdit";
  import RoleIcon from "@/common/Users/components/RoleIcon";
  import UserEditReasonModal from "@/common/Users/modals/UserEditReasonModal";

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
      UserEditReasonModal,
      RoleIcon,
      UserModalAddEdit,
      UserModalDelete,
      UserModalArchive,
      UserAvatar,
    },
    computed: {

    },
    methods: {
      editReason(value){
        const dataToSend = {
          id: value.id,
          reason: value.reason,
          status: false,
        }
        if (value.description) dataToSend.description = value.description

        this.$store.dispatch('settings/disableEmployee', dataToSend)
          .then(response => {
            if (response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                this.toast('Error', `Something wrong! ${key} ${value}`, true)
              }
            }
            if (!response.errors) {
              this.toast('Success', `Updated.`)
            }
          })
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`, true))
      },
      archiveUser(value){
        const dataToSend = {
          id: value.id,
          reason: value.reason,
          status: !value.status,
        }
        if (value.description) dataToSend.description = value.description

        this.$store.dispatch('settings/disableEmployee', dataToSend)
          .then(response => {
            if (response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                this.toast('Error', `Something wrong! ${key} ${value}`, true)
              }
            }
            if (!response.errors) {
              this.toast('Success', `Updated.`)
            }
          })
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`, true))
      },
      deleteUser(id){
        this.$store.dispatch('settings/deleteEmployee', { id })
          .then(response => {
            if (response.errors) {
              for (const [key, value] of Object.entries(response.errors)) {
                this.toast('Error', `Something wrong! ${key} ${value}`, true)
              }
            }
            if (!response.errors) {
              this.toast('Success', `The user has been deleted.`)
            }
          })
          .catch(error => this.toast('Error', `Something wrong! ${error.message}`, true))
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
