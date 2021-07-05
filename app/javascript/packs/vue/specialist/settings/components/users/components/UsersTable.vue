<template lang="pug">
  table.table
    thead
      tr
        th Name
          b-icon.ml-2(icon='chevron-expand' font-scale="1")
        th
          | Roles
          RoleTypesModalInfo
            b-icon.ml-2(icon="exclamation-circle-fill" variant="secondary" v-b-tooltip.hover title="Toooooooltip" font-scale="1")
        th(v-if="disabled") Reason
          b-icon.ml-2(icon='chevron-expand')
        th Access Person
          b-icon.ml-2(icon='chevron-expand')
        th(@click="sortSelect('created_at', 'date')").text-right Start created
          b-icon.ml-2(icon='chevron-expand')
        th(v-if="disabled" @click="sortSelect('disabled_at', 'date')").text-right Date disabled
          b-icon.ml-2(icon='chevron-expand')
        th(width="35px")
    tbody
      UserItem(v-for="item in sortedData" :key="item.id" :item="item" :disabled="disabled")
</template>

<script>

import UserItem from "./UserItem"
import RoleTypesModalInfo from "../modals/RoleTypesModalInfo";
export default {
  components: {
    RoleTypesModalInfo,
    UserItem
  },
  props: {
    users: {
      type: Array,
      required: true
    },
    disabled: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  data () {
    return {
      sortOptions: {
        field: 'progress',
        type: 'number',
        reverse: false
      }
    }
  },
  computed: {
    sortedData () {
      const sortOption = this.sortOptions
      return this.users.sort((itemA, itemB)=> {
        if (sortOption.type === 'number') {
          if (sortOption.reverse) {
            return  itemB[sortOption.field] - itemA[sortOption.field]
          }
          return itemA[sortOption.field] - itemB[sortOption.field]
        }
        if (sortOption.type === 'date') {
          const dateA = new Date(itemA[sortOption.field])
          const dateB = new Date(itemB[sortOption.field])
          if (sortOption.reverse) {
            return dateB - dateA
          }
          return dateA - dateB
        }
        if (sortOption.type === 'string') {
          const stringA = itemA[sortOption.field].toLowerCase()
          const stringB = itemB[sortOption.field].toLowerCase()
          if (sortOption.reverse) {
            if (stringA > stringB) {
              return -1
            }
            if (stringA < stringB) {
              return 1
            }
            return 0
          }
          if (stringA < stringB) {
            return -1
          }
          if (stringA > stringB) {
            return 1
          }
          return 0
        }
      })
    }
  },
  methods: {
    sortSelect (field, type) {
      const sortOption = this.sortOptions
      if (field === sortOption.field) {
        this.sortOptions.reverse = !sortOption.reverse
        return
      }
      this.sortOptions = {
        field: field,
        type: type,
        reverse: false
      }
    }
  }
}
</script>
