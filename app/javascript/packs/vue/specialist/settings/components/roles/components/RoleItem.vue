<template lang="pug">
  tr
    td
      .d-flex
        MessagesModalCreate(:item="item")
          .link {{ item.first_name + ' ' +  item.last_name }}
    td
      .role-info
        ion-icon.role-info__icon.role-info__icon_admin(v-if="item.role === 'admin'" name="people")
        ion-icon.role-info__icon.role-info__icon_trusted(v-if="item.role === 'trusted'" name="checkmark")
        ion-icon.role-info__icon.role-info__icon_basic(v-if="item.role === 'basic'" name="person-circle-outline")
        span.ml-3 {{ item.role | capital }}
    td
      b-badge.status(:variant="item.status ? 'success' : 'light'") {{ item.status ? 'Active' : 'Inactive' }}
    td.text-right
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        MessagesModalCreate(:item="item" :inline="false")
          b-dropdown-item Message
        b-dropdown-item View Contract
        //b-dropdown-item.delete Delete
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import MessagesModalCreate from "../../../../notifications/components/center/modals/MessagesModalCreate";

  export default {
    name: "roleItem",
    props: ['item'],
    components: {
      MessagesModalCreate,
      UserAvatar,
    },
  }
</script>

<style scoped>

</style>
