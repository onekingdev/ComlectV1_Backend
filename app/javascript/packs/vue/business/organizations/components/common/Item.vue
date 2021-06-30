<template lang="pug">
  tr
    td
      p.mb-1 {{ item.first_name + ' ' +  item.last_name }}
      p.mb-0 {{ item.email }}
    td
      .d-flex.align-items-center
        ion-icon.black(v-if="item.role === 'admin'" name="people-outline" size="small")
        b-icon(v-if="item.role === 'trusted'" icon="check-square-fill" scale="2" variant="success")
        ion-icon.grey(v-if="item.role === 'basic'" name="person-circle-outline" size="small")
        span.ml-3 {{ item.role | capitalize }}
    td
      a.link(href="#") {{ item.reason }}
    td {{ item.accessPerson }}
    td {{ item.startDate | dateToHuman }}
    td {{ item.endDate | dateToHuman }}
    td.text-right
      b-dropdown.actions(size="sm" variant="none" class="m-0 p-0" right)
        template(#button-content)
          b-icon(icon="three-dots")
        b-dropdown-item Message
        b-dropdown-item Edit Role
        b-dropdown-item View contract
        b-dropdown-item.delete Delete
</template>

<script>
  import { DateTime } from 'luxon'

  export default {
    name: "roleItem",
    props: ['item'],
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
      },
      dateToHuman(value) {
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
