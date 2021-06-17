<template lang="pug">
  tr
    td
      .d-flex
        UserAvatar(:user="item")
        .d-block.m-l-2
          p.mb-1: b {{ item.first_name + ' ' +  item.last_name }}
          p.mb-0 {{ item.email }}
    td
      .d-flex.align-items-center.pt-2
        ion-icon.black(v-if="item.role === 'admin'" name="people-outline" size="small")
        b-icon(v-if="item.role === 'trusted'" icon="check-square-fill" scale="2" variant="success")
        ion-icon.grey(v-if="item.role === 'basic'" name="person-circle-outline" size="small")
        span.ml-3 {{ item.role }}
    td(v-if="disabled") {{ item.reason }}
    td
      .d-flex.align-items-center.pt-2
        b-icon(v-if="item.access" icon="check-circle-fill" scale="2" variant="success")
        div(v-if="!item.access") -
    td.text-right {{ item.created_at | dateToHuman }}
    td.text-right(v-if="disabled") {{ item.disabled_at | dateToHuman }}
    td.text-right
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        b-dropdown-item Edit
        UserModalArchive(:archiveStatus="item.status" :inline="false")
          b-dropdown-item {{ item.status ? 'Archive' : 'Unarchive' }}
        UserModalDelete(v-if="!item.status" :inline="false")
          b-dropdown-item.delete Delete
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import { DateTime } from 'luxon'
  import UserModalArchive from "../modals/UserModalArchive";
  import UserModalDelete from "../modals/UserModalDelete";

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
      dateToHuman(value) {
        if (!value) return ''
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          return date.toFormat('MM/dd/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
    }
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
