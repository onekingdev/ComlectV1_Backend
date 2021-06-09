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
      b-form-checkbox(v-if="item.access" v-model="item.access") {{item.access ? '' : '-'}}
      div(v-if="!item.access") -
    td.text-right {{ dateToHuman(item.created_at) }}
    td.text-right
      b-dropdown.actions(size="sm" variant="light" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        b-dropdown-item Message
        b-dropdown-item Edit Role
        b-dropdown-item View contract
        b-dropdown-item.delete Delete
</template>

<script>
  import UserAvatar from '@/common/UserAvatar'
  import { DateTime } from 'luxon'

  export default {
    name: "roleItem",
    props: ['item'],
    components: {
      UserAvatar,
    },
    computed: {

    },
    methods: {
      dateToHuman(value) {
        const date = DateTime.fromJSDate(new Date(value))
        if (!date.invalid) {
          return date.toFormat('MM/dd/yyyy')
        }
        if (date.invalid) {
          return value
        }
      },
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
