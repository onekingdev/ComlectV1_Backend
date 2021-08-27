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
      b-icon.status__icon.m-r-1(font-scale="1" :icon="item.access_person ? 'check-circle-fill' : 'check-circle'" :class="{ done_task: item.access_person }")
    td {{ item.start_date | asDate }}
    td
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        UserModalAddEdit(:user="item",  :inline="false")
          b-dropdown-item Edit
        UserModalArchive(v-if="item.active" :user="item" :archiveStatus="item.active" :inline="false" @archiveConfirmed="archiveUser")
          b-dropdown-item {{ item.active ? 'Disable' : 'Enable' }}
        b-dropdown-item(v-if="!item.active" @click="archiveUser(item)") Enable
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import UserModalAddEdit from "@/common/Users/modals/UserModalAddEdit";
  import UserModalArchive from "@/common/Users/modals/UserModalArchive";
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
      archiveUser(value){
        const dataToSend = {
          id: value.id,
          reason: !value.reason,
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
  }
</script>

<style scoped>

</style>
